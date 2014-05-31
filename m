Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877AbaEaJE3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 05:04:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53249 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752917AbaEaJE0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 05:04:26 -0400
Message-ID: <53899AEA.1010909@zytor.com>
Date: Sat, 31 May 2014 02:03:38 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
CC: linux-arch@vger.kernel.org, joseph@codesourcery.com,
        john.stultz@linaro.org, hch@infradead.org, tglx@linutronix.de,
        geert@linux-m68k.org, lftan@altera.com, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC 01/32] fs: introduce new 'struct inode_time'
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de> <1401480116-1973111-2-git-send-email-arnd@arndb.de>
In-Reply-To: <1401480116-1973111-2-git-send-email-arnd@arndb.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2014 01:01 PM, Arnd Bergmann wrote:
> +#ifdef CONFIG_NEW_INODE_TIME
> +/*
> + * This is the type we use internally in the kernel to represent
> + * absolute times in file system metadata.
> + * This structure must not leak out to user space, and new interfaces
> + * should be using 64-bit types right away.
> + */
> +
> +/*
> + * Variant a) using unsigned seconds lets us extend the life span
> + * for another 69 years beyond 2038.
> + */
> +struct inode_time {
> +	unsigned long	tv_sec;
> +	long		tv_nsec;
> +};

This now differs between 32- and 64-bit systems, and on 32-bit systems
some timestamps well within the range of representation of current
systems just became unrepresentable, which is something that I thought
people were objecting very strongly to.

> +#elif 0
> +/*
> + * This variant can represent the widest range of times, but also
> + * bloats 'struct inode' a little more.
> + */
> +struct inode_time {
> +	long long	tv_sec __attribute__((packed));
> +	int		tv_nsec;
> +};

Seriously, though, can we really impose constraints stricter than what
the filesystems themselves do?  It seems we ought to be able to
represent whatever time the filesystem can represent... (modulo some
kind of window control as Y2038 or any other break point approaches.)

	-hpa





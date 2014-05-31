Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756514AbaEaOyy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 10:54:54 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:60922 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588AbaEaOyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 10:54:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        joseph@codesourcery.com, john.stultz@linaro.org, hch@infradead.org,
        tglx@linutronix.de, geert@linux-m68k.org, lftan@altera.com,
        linux-fsdevel@vger.kernel.org
Subject: Re: [RFC 01/32] fs: introduce new 'struct inode_time'
Date: Sat, 31 May 2014 16:53:01 +0200
Message-ID: <6491264.Vk0CYaEpvf@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <53899AEA.1010909@zytor.com>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de> <1401480116-1973111-2-git-send-email-arnd@arndb.de> <53899AEA.1010909@zytor.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:fH1XSeVM/w5w2nluLTdBp+SP6rlkvxg5dbKUKIh8ysC
 j9/6CsoUgTwOkw/Fz6K7BYhvvq2NvmzaYsGBaU1KUx9Ab3X3eX
 RG7KicX82/2QjVQSE0CbpOx0BmxF+XrKrJmbTxX3tVzk2umFIa
 dcWrLZIwWdPFL/sV4Dmd7msIVjUy5oZ8m0ce5st5WBmDXckWs6
 lyRB1YWYGkK7k2jBxIfISxI8EUCBzLJ4GSjqkvoda9SnFlik/e
 /SPGZOiD3ZGrR6MOBz4VX99J63cq1CPa6M+grv4LJ8kYidAkgy
 9EXR5qgkhYO3iXGrzr9pSDYC4HySL0W+7tl6Uflt2HHx2PkVCX
 UcoGanaNnu0lcVBkQU5k=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 31 May 2014 02:03:38 H. Peter Anvin wrote:
> On 05/30/2014 01:01 PM, Arnd Bergmann wrote:
> > +#ifdef CONFIG_NEW_INODE_TIME
> > +/*
> > + * This is the type we use internally in the kernel to represent
> > + * absolute times in file system metadata.
> > + * This structure must not leak out to user space, and new interfaces
> > + * should be using 64-bit types right away.
> > + */
> > +
> > +/*
> > + * Variant a) using unsigned seconds lets us extend the life span
> > + * for another 69 years beyond 2038.
> > + */
> > +struct inode_time {
> > +     unsigned long   tv_sec;
> > +     long            tv_nsec;
> > +};
> 
> This now differs between 32- and 64-bit systems, and on 32-bit systems
> some timestamps well within the range of representation of current
> systems just became unrepresentable, which is something that I thought
> people were objecting very strongly to.

It really depends on the file system. As you pointed out, I was reading
the ext2/ext3 and xfs code incorrectly, so my assumption when I wrote this
was that they already used the same type, with a 1970-2106 window, rather
than the regular signed Unix epoch.

> > +#elif 0
> > +/*
> > + * This variant can represent the widest range of times, but also
> > + * bloats 'struct inode' a little more.
> > + */
> > +struct inode_time {
> > +     long long       tv_sec __attribute__((packed));
> > +     int             tv_nsec;
> > +};
> 
> Seriously, though, can we really impose constraints stricter than what
> the filesystems themselves do?  It seems we ought to be able to
> represent whatever time the filesystem can represent... (modulo some
> kind of window control as Y2038 or any other break point approaches.)

Just to make sure, do you say we should be using the 'long long/int'
struct, or something else?

	Arnd

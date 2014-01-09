Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756961AbaAIU3N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 15:29:13 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:49904 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751AbaAIU3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 15:29:07 -0500
Message-ID: <52CF0690.5030006@amacapital.net>
Date: Thu, 09 Jan 2014 12:29:04 -0800
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Jeff Layton <jlayton@redhat.com>, linux-fsdevel@vger.kernel.org
CC: nfs-ganesha-devel@lists.sourceforge.net, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 14/14] locks: add new fcntl cmd values for handling
 file private locks
References: <1389277187-18211-1-git-send-email-jlayton@redhat.com> <1389277187-18211-15-git-send-email-jlayton@redhat.com>
In-Reply-To: <1389277187-18211-15-git-send-email-jlayton@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2014 06:19 AM, Jeff Layton wrote:
> Due to some unfortunate history, POSIX locks have very strange and
> unhelpful semantics. The thing that usually catches people by surprise
> is that they are dropped whenever the process closes any file descriptor
> associated with the inode.
> 

[...]

> +#define F_GETLKP	36
> +#define F_SETLKP	37
> +#define F_SETLKPW	38
> +
> +#ifndef CONFIG_64BIT
> +#ifndef F_GETLK64
> +#define F_GETLKP64	39
> +#define F_SETLKP64	40
> +#define F_SETLKPW64	41
> +#endif
> +#endif
> +

Since there are no existing callers of these fcntls, can you get rid of
the non-64-bit variants?  The implementation might be a bit more of
departure from current code, but it should make everything a lot cleaner
and make it easier (aka automatic) for new architectures to support this
feature.

--Andy

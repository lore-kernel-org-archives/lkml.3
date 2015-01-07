Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755794AbbAGIdr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 03:33:47 -0500
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:55519 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043AbbAGIdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 03:33:45 -0500
Date: Wed, 7 Jan 2015 09:33:39 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH v2 38/40] s390: macro whitespace fixes
Message-ID: <20150107083339.GB4365@osiris>
References: <1420558883-10131-1-git-send-email-mst@redhat.com>
 <1420558883-10131-39-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420558883-10131-39-git-send-email-mst@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15010708-0025-0000-0000-0000033FA801
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2015 at 05:45:38PM +0200, Michael S. Tsirkin wrote:
> While working on arch/s390/include/asm/uaccess.h, I noticed
> that a couple of macros within this header are made harder to read
> because they violate a coding style rule: space is missing after comma.
> 
> Fix it up.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  arch/s390/include/asm/uaccess.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/s390/include/asm/uaccess.h b/arch/s390/include/asm/uaccess.h
> index cd4c68e..71b9c40 100644
> --- a/arch/s390/include/asm/uaccess.h
> +++ b/arch/s390/include/asm/uaccess.h
> @@ -46,7 +46,7 @@
>  	__ctl_load(__pto, 7, 7);					\
>  })
> 
> -#define segment_eq(a,b) ((a).ar4 == (b).ar4)
> +#define segment_eq(a, b) ((a).ar4 == (b).ar4)
> 
>  static inline int __range_ok(unsigned long addr, unsigned long size)
>  {
> @@ -147,7 +147,7 @@ unsigned long __must_check __copy_to_user(void __user *to, const void *from,
>  		"3:	lhi	%0,%5\n"			\
>  		"	jg	2b\n"				\
>  		".popsection\n"					\
> -		EX_TABLE(0b,3b) EX_TABLE(1b,3b)			\
> +		EX_TABLE(0b, 3b) EX_TABLE(1b, 3b)		\

Most EX_TABLE() usages within s390 are without space after comma.
No need to change that. Also I don't like the change of the seqment_eq()
macro.
I won't apply trivial whitespace patches, since this would make 'git blame'
useless and in addition invite more people to send whitespace patches.

Thanks,
Heiko


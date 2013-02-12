Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755669Ab3BLJvb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 04:51:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52543 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752602Ab3BLJv3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 04:51:29 -0500
Subject: Re: [patch for-3.8] fs, dlm: fix build error when EXPERIMENTAL is
 disabled
From: Steven Whitehouse <swhiteho@redhat.com>
To: David Rientjes <rientjes@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Christine Caulfield <ccaulfie@redhat.com>,
        David Teigland <teigland@redhat.com>, cluster-devel@redhat.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.02.1302111344140.14071@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1302111344140.14071@chino.kir.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Tue, 12 Feb 2013 09:50:05 +0000
Message-ID: <1360662605.2719.13.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 2013-02-11 at 13:48 -0800, David Rientjes wrote:
> CONFIG_IP_SCTP relies on being able to select things like CONFIG_CRC32C to 
> build.  Thus, nothing should be selecting CONFIG_IP_SCTP that does not 
> meet its requirements.
> 
> For example, if CONFIG_EXPERIMENTAL is disabled and CONFIG_DLM is enabled, 
> the build fails at link time:
> 
> 	net/built-in.o: In function `sctp_crc32c':
> 	include/net/sctp/checksum.h:51: undefined reference to `crc32c'
> 	include/net/sctp/checksum.h:51: undefined reference to `crc32c'
> 	include/net/sctp/checksum.h:51: undefined reference to `crc32c'
> 	include/net/sctp/checksum.h:51: undefined reference to `crc32c'
> 	include/net/sctp/checksum.h:51: undefined reference to `crc32c'
> 	net/built-in.o:include/net/sctp/checksum.h:51: more undefined references to `crc32c' follow
> 
> Fix this by making CONFIG_DLM depend on CONFIG_EXPERIMENTAL so that 
> CONFIG_IP_SCTP properly builds.
> 
That doesn't seem right to me... DLM has not been experimental for a
long time now. Why not just select CRC32 in addition to IP_SCTP ?

Steve.

> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
>  fs/dlm/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/dlm/Kconfig b/fs/dlm/Kconfig
> --- a/fs/dlm/Kconfig
> +++ b/fs/dlm/Kconfig
> @@ -2,6 +2,7 @@ menuconfig DLM
>  	tristate "Distributed Lock Manager (DLM)"
>  	depends on INET
>  	depends on SYSFS && CONFIGFS_FS && (IPV6 || IPV6=n)
> +	depends on EXPERIMENTAL
>  	select IP_SCTP
>  	help
>  	A general purpose distributed lock manager for kernel or userspace
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



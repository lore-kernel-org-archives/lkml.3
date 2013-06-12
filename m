Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756379Ab3FLKOA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 06:14:00 -0400
Received: from mail-bk0-f42.google.com ([209.85.214.42]:37448 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753959Ab3FLKN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 06:13:58 -0400
Date: Wed, 12 Jun 2013 12:13:47 +0200
From: Robert Richter <rric@kernel.org>
To: Michal Marek <mmarek@suse.cz>
Cc: "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Makefile: Fix install error with make -j option
Message-ID: <20130612101347.GP3886@rric.localhost>
References: <1367499037-8350-1-git-send-email-rric@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367499037-8350-1-git-send-email-rric@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal,

please apply this fix, ideally for v3.10 if possible.

Thanks,

-Robert


On 02.05.13 08:50:37, Robert Richter wrote:
> From: Robert Richter <robert.richter@calxeda.com>
> 
> Make modules_install fails with -j option:
> 
>    DEPMOD
>  Usage: .../.source/linux/scripts/depmod.sh /sbin/depmod <kernelrelease>
>  make[1]: *** [_modinst_post] Error 1
> 
> Adding kernelrelease dependency to fix this.
> 
> Signed-off-by: Robert Richter <robert.richter@calxeda.com>
> ---
>  Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Makefile b/Makefile
> index 46263d8..0205e79 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -979,7 +979,7 @@ _modinst_:
>  # boot a modules.dep even before / is mounted read-write.  However the
>  # boot script depmod is the master version.
>  PHONY += _modinst_post
> -_modinst_post: _modinst_
> +_modinst_post: include/config/kernel.release _modinst_
>  	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.fwinst obj=firmware __fw_modinst
>  	$(call cmd,depmod)
>  
> -- 
> 1.8.1.1
> 

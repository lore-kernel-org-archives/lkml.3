Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497AbaFLCHO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 22:07:14 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:39781 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755215AbaFLCHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 22:07:12 -0400
Message-ID: <53990B48.8010902@linux.vnet.ibm.com>
Date: Thu, 12 Jun 2014 10:07:04 +0800
From: Mike Qiu <qiudayu@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>
CC: linuxppc-dev@lists.ozlabs.org, Sam Ravnborg <sam@ravnborg.org>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] powerpc: Avoid circular dependency with zImage.%
References: <53984D4F.6040808@linux.vnet.ibm.com> <1402501243-28213-1-git-send-email-mmarek@suse.cz>
In-Reply-To: <1402501243-28213-1-git-send-email-mmarek@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061202-2674-0000-0000-0000005ECC3C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This v2 patch is good,

Tested-by: Mike Qiu <qiudayu@linux.vnet.ibm.com>

On 06/11/2014 11:40 PM, Michal Marek wrote:
> The rule to create the final images uses a zImage.% pattern.
> Unfortunately, this also matches the names of the zImage.*.lds linker
> scripts, which appear as a dependency of the final images. This somehow
> worked when $(srctree) used to be an absolute path, but now the pattern
> matches too much. List only the images from $(image-y) as the target of
> the rule, to avoid the circular dependency.
>
> Signed-off-by: Michal Marek <mmarek@suse.cz>
> ---
> v2:
>    - Filter out duplicates in the target list
>    - fix the platform argument to cmd_wrap
>
>   arch/powerpc/boot/Makefile | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/powerpc/boot/Makefile b/arch/powerpc/boot/Makefile
> index 426dce7..ccc25ed 100644
> --- a/arch/powerpc/boot/Makefile
> +++ b/arch/powerpc/boot/Makefile
> @@ -333,8 +333,8 @@ $(addprefix $(obj)/, $(initrd-y)): $(obj)/ramdisk.image.gz
>   $(obj)/zImage.initrd.%: vmlinux $(wrapperbits)
>   	$(call if_changed,wrap,$*,,,$(obj)/ramdisk.image.gz)
>
> -$(obj)/zImage.%: vmlinux $(wrapperbits)
> -	$(call if_changed,wrap,$*)
> +$(addprefix $(obj)/, $(sort $(filter zImage.%, $(image-y)))): vmlinux $(wrapperbits)
> +	$(call if_changed,wrap,$(subst $(obj)/zImage.,,$@))
>
>   # dtbImage% - a dtbImage is a zImage with an embedded device tree blob
>   $(obj)/dtbImage.initrd.%: vmlinux $(wrapperbits) $(obj)/%.dtb


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910AbaBOVfx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 16:35:53 -0500
Received: from asav12.altibox.net ([81.167.36.146]:57823 "EHLO
	asav12.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753891AbaBOVfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 16:35:50 -0500
X-Greylist: delayed 429 seconds by postgrey-1.27 at vger.kernel.org; Sat, 15 Feb 2014 16:35:50 EST
Date: Sat, 15 Feb 2014 22:35:45 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-kbuild@vger.kernel.org,
        mmarek@suse.cz, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 14/19] Kbuild, lto: Handle basic LTO in modpost
Message-ID: <20140215213545.GB27587@ravnborg.org>
References: <1392412903-25733-1-git-send-email-andi@firstfloor.org>
 <1392412903-25733-15-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392412903-25733-15-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 14, 2014 at 10:21:38PM +0100, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> - Don't warn about LTO marker symbols. modpost runs before
> the linker, so the module is not necessarily LTOed yet.
> - Don't complain about .gnu.lto* sections
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  scripts/mod/modpost.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
> index f91dd45..63804a1 100644
> --- a/scripts/mod/modpost.c
> +++ b/scripts/mod/modpost.c
> @@ -623,7 +623,10 @@ static void handle_modversions(struct module *mod, struct elf_info *info,
>  
>  	switch (sym->st_shndx) {
>  	case SHN_COMMON:
> -		warn("\"%s\" [%s] is COMMON symbol\n", symname, mod->name);
> +		if (!strncmp(symname, "__gnu_lto_", sizeof("__gnu_lto_")-1)) {

Please use space around "-".

	Sam

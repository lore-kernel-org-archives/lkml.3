Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943AbaBOVgp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 16:36:45 -0500
Received: from asavdk3.altibox.net ([109.247.116.14]:52895 "EHLO
	asavdk3.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753600AbaBOVgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 16:36:44 -0500
Date: Sat, 15 Feb 2014 22:36:40 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-kbuild@vger.kernel.org,
        mmarek@suse.cz, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 08/19] Kbuild, lto, workaround: Don't warn for
 initcall_reference in modpost
Message-ID: <20140215213640.GC27587@ravnborg.org>
References: <1392412903-25733-1-git-send-email-andi@firstfloor.org>
 <1392412903-25733-9-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392412903-25733-9-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 14, 2014 at 10:21:32PM +0100, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> This reference is discarded, but can cause warnings when it refers to
> exit. Ignore for now.
> 
> This is a workaround and can be removed once we get rid of
> -fno-toplevel-reorder
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  scripts/mod/modpost.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
> index 4061098..1f1b154 100644
> --- a/scripts/mod/modpost.c
> +++ b/scripts/mod/modpost.c
> @@ -1455,6 +1455,10 @@ static void check_section_mismatch(const char *modname, struct elf_info *elf,
>  		to = find_elf_symbol(elf, r->r_addend, sym);
>  		tosym = sym_name(elf, to);
>  
> +		if (!strncmp(fromsym, "reference___initcall",
> +				sizeof("reference___initcall")-1))

Please use spaces around "-"

	Sam

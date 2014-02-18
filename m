Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004AbaBROwP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 09:52:15 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:44793 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755580AbaBROwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 09:52:13 -0500
Date: Tue, 18 Feb 2014 09:51:46 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, sam@ravnborg.org, x86@kernel.org,
        linux-kbuild@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 17/20] Kbuild, bloat-o-meter: Ignore .lto_priv postfix
Message-ID: <20140218145146.GB5339@phenom.dumpdata.com>
References: <1392733738-8290-1-git-send-email-andi@firstfloor.org>
 <1392733738-8290-18-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392733738-8290-18-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 03:28:55PM +0100, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> gcc 4.9 may generate .lto_priv post fixes for LTO functions.
> Ignore those for bloat-o-meter comparisons.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  scripts/bloat-o-meter | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/scripts/bloat-o-meter b/scripts/bloat-o-meter
> index 549d0ab..2becdf6 100755
> --- a/scripts/bloat-o-meter
> +++ b/scripts/bloat-o-meter
> @@ -23,6 +23,7 @@ def getsizes(file):
>              if name == "linux_banner": continue
>              # statics and some other optimizations adds random .NUMBER
>              name = re.sub(r'\.[0-9]+', '', name)
> +	    name = name.replace(".lto_priv", "")

Is it my editor or are you using tabs instead of spaces there?

Not that it matters that much - but it makes the patch look
odd.

>              sym[name] = sym.get(name, 0) + int(size, 16)
>      return sym
>  
> -- 
> 1.8.5.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

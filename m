Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752356Ab3AWVmA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 16:42:00 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:62201 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388Ab3AWVly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 16:41:54 -0500
MIME-Version: 1.0
In-Reply-To: <1354988074-2165-1-git-send-email-peter.senna@gmail.com>
References: <1354988074-2165-1-git-send-email-peter.senna@gmail.com>
Date: Wed, 23 Jan 2013 19:41:54 -0200
Message-ID: <CA+MoWDo58OUJzDKD_Cq9R679MP7DeWY_4HqiPo1g=dT09+Y3yA@mail.gmail.com>
Subject: Re: [PATCH] scripts/coccinelle/misc/semicolon.cocci: Add unneeded
 semicolon test
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: mmarek@suse.cz
Cc: Julia Lawall <Julia.Lawall@lip6.fr>, Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>,
        Peter Senna Tschudin <peter.senna@gmail.com>, cocci@systeme.lip6.fr,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ping

On Sat, Dec 8, 2012 at 3:34 PM, Peter Senna Tschudin
<peter.senna@gmail.com> wrote:
> This semantic patch looks for semicolons that can be removed without
> changing the semantics of the code. The confidence is moderate
> because there are some false positives on cases like:
>
> b/drivers/mmc/host/cb710-mmc.c:589
>                 break;
>         case MMC_POWER_UP:
>         default:
> -               /* ignore */;
>         }
>
> There are 37 patches accepted reported by this semantic patch and
> more than 300 fixes to be applied.
>
> Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
> ---
> Resending unchanged. Last sent on November 13 2012. First sent on October 30 2012.
>
>  scripts/coccinelle/misc/semicolon.cocci | 83 +++++++++++++++++++++++++++++++++
>  1 file changed, 83 insertions(+)
>  create mode 100644 scripts/coccinelle/misc/semicolon.cocci
>
> diff --git a/scripts/coccinelle/misc/semicolon.cocci b/scripts/coccinelle/misc/semicolon.cocci
> new file mode 100644
> index 0000000..a47eba2
> --- /dev/null
> +++ b/scripts/coccinelle/misc/semicolon.cocci
> @@ -0,0 +1,83 @@
> +///
> +/// Removes unneeded semicolon.
> +///
> +// Confidence: Moderate
> +// Copyright: (C) 2012 Peter Senna Tschudin, INRIA/LIP6.  GPLv2.
> +// URL: http://coccinelle.lip6.fr/
> +// Comments: Some false positives on empty default cases in switch statements.
> +// Options: --no-includes --include-headers
> +
> +virtual patch
> +virtual report
> +virtual context
> +virtual org
> +
> +@r_default@
> +position p;
> +@@
> +switch (...)
> +{
> +default: ...;@p
> +}
> +
> +@r_case@
> +position p;
> +@@
> +(
> +switch (...)
> +{
> +case ...:;@p
> +}
> +|
> +switch (...)
> +{
> +case ...:...
> +case ...:;@p
> +}
> +|
> +switch (...)
> +{
> +case ...:...
> +case ...:
> +case ...:;@p
> +}
> +)
> +
> +@r1@
> +statement S;
> +position p1;
> +position p != {r_default.p, r_case.p};
> +identifier label;
> +@@
> +(
> +label:;
> +|
> +S@p1;@p
> +)
> +
> +@script:python@
> +p << r1.p;
> +p1 << r1.p1;
> +@@
> +if p[0].line != p1[0].line_end:
> +       cocci.include_match(False)
> +
> +@depends on patch@
> +position r1.p;
> +@@
> +-;@p
> +
> +@script:python depends on report@
> +p << r1.p;
> +@@
> +coccilib.report.print_report(p[0],"Unneeded semicolon")
> +
> +@depends on context@
> +position r1.p;
> +@@
> +*;@p
> +
> +@script:python depends on org@
> +p << r1.p;
> +@@
> +cocci.print_main("Unneeded semicolon",p)
> --
> 1.7.11.7
>



-- 
Peter

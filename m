Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932181AbaKPN3U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 08:29:20 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:20992 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750857AbaKPN3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 08:29:19 -0500
X-IronPort-AV: E=Sophos;i="5.07,397,1413237600"; 
   d="scan'208";a="107348452"
Date: Sun, 16 Nov 2014 14:29:02 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: SF Markus Elfring <elfring@users.sourceforge.net>
cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Coccinelle <cocci@systeme.lip6.fr>
Subject: Re: [Cocci] [PATCH 1/1] kprobes: Deletion of an unnecessary check
 before the function call "module_put"
In-Reply-To: <546899CF.8020808@users.sourceforge.net>
Message-ID: <alpine.DEB.2.10.1411161428190.2364@hadrien>
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net>
 <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net>
 <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
 <5317A59D.4@users.sourceforge.net> <546899CF.8020808@users.sourceforge.net>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Nov 2014, SF Markus Elfring wrote:

> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Sun, 16 Nov 2014 12:20:31 +0100
>
> The module_put() function tests whether its argument is NULL and then
> returns immediately. Thus the test around the call is not needed.
>
> This issue was detected by using the Coccinelle software.
>
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  kernel/kprobes.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/kernel/kprobes.c b/kernel/kprobes.c
> index 3995f54..f1e7d45 100644
> --- a/kernel/kprobes.c
> +++ b/kernel/kprobes.c
> @@ -1527,8 +1527,7 @@ int register_kprobe(struct kprobe *p)
>  out:
>  	mutex_unlock(&kprobe_mutex);
>
> -	if (probed_mod)
> -		module_put(probed_mod);
> +	module_put(probed_mod);

There is an out label, so please check whether the labels could not be
better positioned to avoid calling module_put when it is not needed.

julia

>
>  	return ret;
>  }
> --
> 2.1.3
>
>
> _______________________________________________
> Cocci mailing list
> Cocci@systeme.lip6.fr
> https://systeme.lip6.fr/mailman/listinfo/cocci
>

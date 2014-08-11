Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430AbaHKNFx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 09:05:53 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:61215
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751506AbaHKNFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 09:05:52 -0400
X-IronPort-AV: E=Sophos;i="5.01,841,1400018400"; 
   d="scan'208";a="74511402"
Date: Mon, 11 Aug 2014 15:05:21 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: SF Markus Elfring <elfring@users.sourceforge.net>
cc: Julia Lawall <Julia.Lawall@lip6.fr>, Coccinelle <cocci@systeme.lip6.fr>,
        kernel-janitors@vger.kernel.org, Nicolas Palix <nicolas.palix@imag.fr>,
        Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scripts/coccinelle/free/ifnullfree.cocci: simplify and
 extend to of_node_put
In-Reply-To: <53E8BE84.3080505@users.sourceforge.net>
Message-ID: <alpine.DEB.2.10.1408111503550.2518@hadrien>
References: <1407752653-16883-1-git-send-email-Julia.Lawall@lip6.fr> <53E8BE84.3080505@users.sourceforge.net>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 11 Aug 2014, SF Markus Elfring wrote:

> >  @r depends on context || report || org @
> > @@ -37,7 +35,8 @@ position p;
> >  @@
> >
> >  * if (E)
> > -*	\(kfree@p\|debugfs_remove@p\|debugfs_remove_recursive@p\|usb_free_urb\)(E);
> > +*  \(kfree@p\|debugfs_remove@p\|debugfs_remove_recursive@p\|usb_free_urb@p\|
> > +*    of_node_put@p\)(E);
>
> Why do you want to limit this semantic patch pattern to such a small list of
> function names?

Because these are the ones that kernel developers have cited as
interesting for this kind of transformation.

> Would you like to consider also the hundreds of other functions which perform
> input parameter validation?

Personally, no.  I think I have explained why several times already.

julia

> Are you interested to make the checked list more complete with further
> (eventually automatic?) extensions?
>
> Regards,
> Markus
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

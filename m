Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754973AbaKSJ6V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 04:58:21 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:3337 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751314AbaKSJ6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 04:58:18 -0500
X-IronPort-AV: E=Sophos;i="5.07,415,1413237600"; 
   d="scan'208";a="108139451"
Date: Wed, 19 Nov 2014 10:58:01 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: SF Markus Elfring <elfring@users.sourceforge.net>
cc: Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Subject: Re: net: xfrm: Deletion of an unnecessary check before the function
 call "ipcomp_free_tfms"
In-Reply-To: <546C6823.50900@users.sourceforge.net>
Message-ID: <alpine.DEB.2.10.1411191054410.2363@hadrien>
References: <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
 <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <546BAFF5.5020603@users.sourceforge.net> <20141119084542.GK4905@mwanda> <546C6823.50900@users.sourceforge.net>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 19 Nov 2014, SF Markus Elfring wrote:

> >> The ipcomp_free_tfms() function tests whether its argument is NULL and then
> >> returns immediately. Thus the test around the call is not needed.
> >
> > It doesn't though...
>
> You are right that this function implementation does a bit more before
> returning because of a detected null pointer.
> https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/tree/net/xfrm/xfrm_ipcomp.c?id=394efd19d5fcae936261bd48e5b33b21897aacf8#n247
>
> Can you agree that input parameter validation is also performed there?
> Do you want that I resend my patch with a corrected commit message?

This is completely crazy.  The function performs a side effect on a data
structure.  If the call site doesn't want that done in a certain case,
then it should not be done.

julia

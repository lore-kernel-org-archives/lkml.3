Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382AbaKCRCV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 12:02:21 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:50846 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752272AbaKCRCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 12:02:19 -0500
X-IronPort-AV: E=Sophos;i="5.07,308,1413237600"; 
   d="scan'208";a="104479706"
Date: Mon, 3 Nov 2014 18:02:14 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: SF Markus Elfring <elfring@users.sourceforge.net>
cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Ursula Braun <ursula.braun@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Frank Blaschka <blaschka@linux.vnet.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, trivial@kernel.org,
        Coccinelle <cocci@systeme.lip6.fr>
Subject: Re: s390/net: Deletion of unnecessary checks before two function
 calls
In-Reply-To: <5457B268.3020202@users.sourceforge.net>
Message-ID: <alpine.DEB.2.10.1411031753200.2386@hadrien>
References: <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net>
 <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <5453C98C.90105@users.sourceforge.net> <20141103095059.GL6879@mwanda> <5457A560.2020304@users.sourceforge.net> <20141103162528.GT6890@mwanda>
 <5457B268.3020202@users.sourceforge.net>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > After your patch then it will print warning messages.
> >  After:  You have to remember that rtw_free_netdev() accepts NULL
> > 	 pointers but free_netdev() does not accept NULL pointers.
>
> Are any improvements needed for the corresponding documentation to make it
> better accessible besides the source code?

When people are writing or reading code, they will not necessarily look at
the documentation for every function that they use.

> > The if statements are there for *human* readers to understand and you are
> > making it harder for humans to understand the code.
>
> Is there a target conflict between source code understandability
> and software efficiency?

Efficiency is not an issue.  This code is all in rare error handling paths
or in service removal functions.  None of it is in a critical path.  What
is important is to be able to easily check that what needs to be done is
actually done.  Removing null tests makes it more obscure what needs to be
done, because it means that the conditions under which a function needs to
be called (which may be different than the conditions under which it can
be called) are less apparent.

julia

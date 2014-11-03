Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179AbaKCRRF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 12:17:05 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:35659 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbaKCRRC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 12:17:02 -0500
Date: Mon, 3 Nov 2014 20:16:25 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: Ursula Braun <ursula.braun@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Frank Blaschka <blaschka@linux.vnet.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, trivial@kernel.org,
        Coccinelle <cocci@systeme.lip6.fr>
Subject: Re: s390/net: Deletion of unnecessary checks before two function
 calls
Message-ID: <20141103171625.GU6890@mwanda>
References: <530CF8FF.8080600@users.sourceforge.net>
 <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
 <530DD06F.4090703@users.sourceforge.net>
 <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
 <5317A59D.4@users.sourceforge.net>
 <5453C98C.90105@users.sourceforge.net>
 <20141103095059.GL6879@mwanda>
 <5457A560.2020304@users.sourceforge.net>
 <20141103162528.GT6890@mwanda>
 <5457B268.3020202@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5457B268.3020202@users.sourceforge.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2014 at 05:50:48PM +0100, SF Markus Elfring wrote:
> > After your patch then it will print warning messages.
> 
> To which messages do you refer to?
> 

Open your eyeballs up and read the code.

> 
> > The truth is I think that all these patches are bad and they make the
> > code harder to read.
> > 
> > Before:  The code is clear and there is no NULL dereference.
> 
> Where do you stumble on a null pointer access?
> 

I'm not talking about bugs, I'm talking about code clarity.  Before is
more clear than after.

> 
> >  After:  You have to remember that rtw_free_netdev() accepts NULL
> > 	 pointers but free_netdev() does not accept NULL pointers.
> 
> Are any improvements needed for the corresponding documentation to make it
> better accessible besides the source code?
> 

Documentation doesn't reduce the number of things to remember it just
documents it.  Meanwhile if we leave the code as-is there is no need for
documentation because the code is clear.

> 
> > The if statements are there for *human* readers to understand and you are
> > making it harder for humans to understand the code.
> 
> Is there a target conflict between source code understandability
> and software efficiency?

If you can benchmark the code and the new code is faster then, yes, this
patch is good and we will apply it.  If you have no benchmarks then do
not send the patch.

> 
> > Even for kfree(), just removing the if statement is not really the right
> > fix.  We do it because everyone knows kfree(), but what Julia Lawall
> > said is the real correct way change the code and make it simpler for
> > people to understand:
> > 
> > https://lkml.org/lkml/2014/10/31/452
> 
> You refer to another update suggestion for the software area
> "staging: rtl8188eu".
> Do you find adjustments for jump labels easier to accept than the simple
> deletion of specific null pointer checks?

Yes.

> 
> 
> > I know it's fun to send automated patches but these make the code worse
> > and they waste reviewer time.
> 
> I hope that small automated changes can also help to improve affected
> source files.

No.  The changes make the code less clear.

regards,
dan carpenter


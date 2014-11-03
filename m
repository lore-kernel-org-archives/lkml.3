Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578AbaKCQZx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 11:25:53 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:25900 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023AbaKCQZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 11:25:48 -0500
Date: Mon, 3 Nov 2014 19:25:28 +0300
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
Message-ID: <20141103162528.GT6890@mwanda>
References: <530CD2C4.4050903@users.sourceforge.net>
 <alpine.DEB.2.10.1402251840450.7035@hadrien>
 <530CF8FF.8080600@users.sourceforge.net>
 <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
 <530DD06F.4090703@users.sourceforge.net>
 <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
 <5317A59D.4@users.sourceforge.net>
 <5453C98C.90105@users.sourceforge.net>
 <20141103095059.GL6879@mwanda>
 <5457A560.2020304@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5457A560.2020304@users.sourceforge.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2014 at 04:55:12PM +0100, SF Markus Elfring wrote:
> > This one is buggy.
> 
> I am still interested to clarify this opinion a bit more.
> 

After your patch then it will print warning messages.

The truth is I think that all these patches are bad and they make the
code harder to read.

Before:  The code is clear and there is no NULL dereference.
 After:  You have to remember that rtw_free_netdev() accepts NULL
	 pointers but free_netdev() does not accept NULL pointers.

The if statements are there for *human* readers to understand and you are
making it harder for humans to understand the code.

Even for kfree(), just removing the if statement is not really the right
fix.  We do it because everyone knows kfree(), but what Julia Lawall
said is the real correct way change the code and make it simpler for
people to understand:

https://lkml.org/lkml/2014/10/31/452

I know it's fun to send automated patches but these make the code worse
and they waste reviewer time.

regards,
dan carpenter

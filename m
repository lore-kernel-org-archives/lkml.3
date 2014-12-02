Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685AbaLBSff (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 13:35:35 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:33854 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754484AbaLBSfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 13:35:32 -0500
Date: Tue, 2 Dec 2014 21:35:09 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Julia Lawall <julia.lawall@lip6.fr>,
        SF Markus Elfring <elfring@users.sourceforge.net>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Olof Johansson <olof@lixom.net>, netdev@vger.kernel.org,
        backports@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: Re: net-PA Semi: Deletion of unnecessary checks before the function
 call "pci_dev_put"
Message-ID: <20141202183509.GI4994@mwanda>
References: <alpine.DEB.2.10.1402251840450.7035@hadrien>
 <530CF8FF.8080600@users.sourceforge.net>
 <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
 <530DD06F.4090703@users.sourceforge.net>
 <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
 <5317A59D.4@users.sourceforge.net>
 <547BC5AD.6090500@users.sourceforge.net>
 <1417465745.28610.0.camel@sipsolutions.net>
 <alpine.DEB.2.02.1412012134290.2076@localhost6.localdomain6>
 <1417539208.1841.1.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417539208.1841.1.camel@sipsolutions.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2014 at 05:53:28PM +0100, Johannes Berg wrote:
> On Mon, 2014-12-01 at 21:34 +0100, Julia Lawall wrote:
> 
> > > So this kind of evolution is no problem for the (automated) backports
> > > using the backports project - although it can be difficult to detect
> > > such a thing is needed.
> > 
> > That is exactly the problem...
> 
> I'm not convinced though that it should stop such progress in mainline.

Is it progress?  These patches match the code look simpler by passing
hiding the NULL check inside a function call.  Calling pci_dev_put(NULL)
doesn't make sense.  Just because a sanity check exists doesn't mean we
should do insane things.

It's easy enough to store which functions have a sanity check in a
database, but to rememember all that as a human being trying to read the
code is impossible.

If we really wanted to make this code cleaner we would introduce more
error labels with better names.

regards,
dan carpenter


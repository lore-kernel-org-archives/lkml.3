Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757016AbaGNUZn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 16:25:43 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:28759 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754870AbaGNUZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 16:25:41 -0400
Date: Mon, 14 Jul 2014 16:25:31 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Sander Eikelenboom <linux@eikelenboom.it>
Cc: konrad@kernel.org, xen-devel@lists.xenproject.org,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com,
        linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH v4] PCI back fixes for 3.17.
Message-ID: <20140714202531.GA24877@laptop.dumpdata.com>
References: <20140714173753.GB12920@laptop.dumpdata.com>
 <9210423415.20140714194304@eikelenboom.it>
 <20140714174525.GD12920@laptop.dumpdata.com>
 <1332864311.20140714202433@eikelenboom.it>
 <20140714184547.GA18896@laptop.dumpdata.com>
 <1499016487.20140714210129@eikelenboom.it>
 <20140714195405.GA20567@laptop.dumpdata.com>
 <6110472183.20140714221618@eikelenboom.it>
 <20140714201817.GD23791@laptop.dumpdata.com>
 <1174271881.20140714222152@eikelenboom.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1174271881.20140714222152@eikelenboom.it>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> > Thank you for reporting it and helping me with the XenStore output to
> >> > narrow down the culprit!
> >> 
> >> The thing i don't understand then is:
> >> How is it different for the last (or all ) device(s) ?
> >> (since the last device (or removing all devices) before doing the 
> >> assignable-remove doesn't trigger the warning)
> >> 
> >> Or does the complete removal of the pci-part of the tree in xenstore trigger something ?
> 
> > Yup. It removes the whole 'pci' directory in XenStore which triggers
> > in Xen pciback the code to deal with that.
> So that essentially needs to be changed to watch the individual devices in the 
> xenstore tree instead of the whole pci stuff.

Correct. Thought instead of watching it will just compare with what it
had assigned to a guest and what it currently has exposed in XenStore. And
then whatever is not on the list (exposed in XenStore) is going to be reaped.

> Then it all makes sense :-)  

Until you find another bug :-)
> 
> >> You know if you got a patch cooked up, i'm more than happy to test !
> 
> > Hehe!
> >> 
> >> --
> >> Sander
> >> 
> 
> 

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838AbaCGOpO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 09:45:14 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:24345 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595AbaCGOpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 09:45:09 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+Wq8VOccWC7wOTzeSD4z7KIhPxpikjvVg=
X-DKIM: OpenDKIM Filter v2.0.1 titan A3B9953CF0F
Date: Fri, 7 Mar 2014 09:44:57 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree@vger.kernel.org, Tawfik Bayouk <tawfik@marvell.com>,
        linux-kernel@vger.kernel.org, Nadav Haklai <nadavh@marvell.com>,
        Lior Amsalem <alior@marvell.com>, linux-arm-kernel@lists.infradead.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH] ARM: mvebu: add Device Tree for the Armada 385 RD board
Message-ID: <20140307144457.GC18707@titan.lakedaemon.net>
References: <5318779C.8030901@free-electrons.com>
 <20140306142117.GL4780@lunn.ch>
 <531886B4.2070002@free-electrons.com>
 <20140306144600.GM4780@lunn.ch>
 <53188B73.4000109@free-electrons.com>
 <53189892.5090502@free-electrons.com>
 <20140306160213.GA4327@arch.cereza>
 <20140306172339.GP4780@lunn.ch>
 <20140306191747.GA32655@arch.cereza>
 <53199726.4080300@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53199726.4080300@free-electrons.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2014 at 10:53:42AM +0100, Gregory CLEMENT wrote:
> On 06/03/2014 20:17, Ezequiel Garcia wrote:
> > On Mar 06, Andrew Lunn wrote:
> >>> Can't we fix this so the probe order doesn't affect the name?
> >>>
> >>> Is that sane?
> >>
> >> You are not supposed to trust the device name, since probing can
> >> happen in parallel, on different buses. udev should have rules to name
> >> the interfaces based on the MAC address. On my Debian system i have:
> >>
> >> /etc/udev/rules.d/70-persistent-net.rules
> >>
> >> So what is important is that the MAC addresses are assigned correctly
> >> to the device. And DT does that based on MMIO address, so should be
> >> reliable, independent of probe order.

errr... I've always viewed the udev rules for persistent naming as a
hacky work-around.  If we have an opportunity to present consistent
names to userspace, then we should do that.  Otherwise, why would
devicetree have the ability to assign aliases?

> I was aware of this solution, and indeed for the end user it is the thing
> to do.

If we're broken, then yes.  Once we fix it, then the udev rules would
just confirm that the naming is the same from the previous boot.

thx,

Jason.

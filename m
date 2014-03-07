Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753683AbaCGVnO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 16:43:14 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:56008 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbaCGVnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 16:43:12 -0500
Date: Fri, 7 Mar 2014 21:42:32 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Andrew Lunn <andrew@lunn.ch>
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Tawfik Bayouk <tawfik@marvell.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Nadav Haklai <nadavh@marvell.com>,
        Lior Amsalem <alior@marvell.com>, linux-arm-kernel@lists.infradead.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH] ARM: mvebu: add Device Tree for the Armada 385 RD board
Message-ID: <20140307214232.795e76b8@alan.etchedpixels.co.uk>
In-Reply-To: <20140306172339.GP4780@lunn.ch>
References: <1394107868-26094-1-git-send-email-gregory.clement@free-electrons.com>
	<20140306131429.GJ4780@lunn.ch>
	<5318779C.8030901@free-electrons.com>
	<20140306142117.GL4780@lunn.ch>
	<531886B4.2070002@free-electrons.com>
	<20140306144600.GM4780@lunn.ch>
	<53188B73.4000109@free-electrons.com>
	<53189892.5090502@free-electrons.com>
	<20140306160213.GA4327@arch.cereza>
	<20140306172339.GP4780@lunn.ch>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Mar 2014 18:23:39 +0100
Andrew Lunn <andrew@lunn.ch> wrote:

> > Can't we fix this so the probe order doesn't affect the name?
> > 
> > Is that sane?
> 
> You are not supposed to trust the device name, since probing can
> happen in parallel, on different buses. udev should have rules to name
> the interfaces based on the MAC address. On my Debian system i have:
> 
> /etc/udev/rules.d/70-persistent-net.rules
> 
> So what is important is that the MAC addresses are assigned correctly
> to the device. And DT does that based on MMIO address, so should be
> reliable, independent of probe order.

Remembering of course thats its valid to have one MAC address per system
not per network controller, so this does blow up in certain cases. You
can still use udev rules for most of those cases to identify off some
other property.

Alan

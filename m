Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855AbaCFTSE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 14:18:04 -0500
Received: from top.free-electrons.com ([176.31.233.9]:58719 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752096AbaCFTSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 14:18:01 -0500
Date: Thu, 6 Mar 2014 16:17:47 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Andrew Lunn <andrew@lunn.ch>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>,
        Tawfik Bayouk <tawfik@marvell.com>, linux-kernel@vger.kernel.org,
        Nadav Haklai <nadavh@marvell.com>, Lior Amsalem <alior@marvell.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH] ARM: mvebu: add Device Tree for the Armada 385 RD board
Message-ID: <20140306191747.GA32655@arch.cereza>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140306172339.GP4780@lunn.ch>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mar 06, Andrew Lunn wrote:
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
> 

Right, makes perfect sense!

So we can just keep the nodes address-ordered, without caring about the name?

-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com

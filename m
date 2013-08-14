Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759797Ab3HNLxr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 07:53:47 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:20711 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751686Ab3HNLxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 07:53:43 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1991ZbNLof0L5od0VEsSkMyp3ZHHTEmoH4=
Date: Wed, 14 Aug 2013 07:53:28 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, Andrew Lunn <andrew@lunn.ch>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Stephen Warren <swarren@wwwdotorg.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH v2 4/5] PCI: mvebu: add support for reset on GPIO
Message-ID: <20130814115328.GA32395@titan.lakedaemon.net>
References: <1376396724-32048-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1376396724-32048-5-git-send-email-sebastian.hesselbarth@gmail.com>
 <20130814090715.GA2084@ulmo>
 <520B4CEE.2050508@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <520B4CEE.2050508@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 14, 2013 at 11:25:02AM +0200, Sebastian Hesselbarth wrote:
> On 08/14/2013 11:07 AM, Thierry Reding wrote:
> >On Tue, Aug 13, 2013 at 02:25:23PM +0200, Sebastian Hesselbarth wrote:
> >[...]
> >>diff --git a/drivers/pci/host/pci-mvebu.c b/drivers/pci/host/pci-mvebu.c
> >[...]
> >>@@ -897,6 +904,30 @@ static int mvebu_pcie_probe(struct platform_device *pdev)
> >[...]
> >>+			u32 reset_udelay = 20000;
> >[...]
> >>+			udelay(reset_udelay);
> >
> >udelay(20000) is probably not a good idea. You should probably use
> >something like usleep_range() or msleep() here. Also see:
> >
> >	Documentation/timers/timers-howto.txt
> 
> Thierry,
> 
> thanks for mentioning this. I clearly got distracted from ms to us
> switch due to the different reset API convention. As the delay will
> be most likely 10ms+, we should change the above to
> msleep(reset_udelay/1000) instead.

I'll just go ahead and fix this up locally.  No need to resend.

thx,

Jason.

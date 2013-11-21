Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755042Ab3KUUrM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 15:47:12 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:26069 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752020Ab3KUUrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 15:47:09 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/J+Birh5sOZ30W6JiCAhKi
Date: Thu, 21 Nov 2013 12:46:55 -0800
From: Tony Lindgren <tony@atomide.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        Carlos Chinea <cch.devel@gmail.com>, Paul Walmsley <paul@pwsan.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>,
        "=?utf-8?Q?'Beno=C3=AEt?= Cousson'" <bcousson@baylibre.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org
Subject: Re: [RFCv2 3/3] ARM: dts: N900: Add SSI information
Message-ID: <20131121204654.GB10023@atomide.com>
References: <1379277856-24571-1-git-send-email-sre@debian.org>
 <1379277856-24571-4-git-send-email-sre@debian.org>
 <20131121013858.GK10317@atomide.com>
 <20131121022125.GA2445@earth.universe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131121022125.GA2445@earth.universe>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sebastian Reichel <sre@debian.org> [131120 18:22]:
> On Wed, Nov 20, 2013 at 05:38:59PM -0800, Tony Lindgren wrote:
> 
> In the public documentation of the omaps all SSI related stuff is
> missing and memory areas are marked as reserved. I could not find
> out how to receive the NDA version, so the following is purely
> speculation based on the code.
> 
> If I understand it right the HW looks like this:
> 
> +-----------------+
> |    GDD (DMA)    | <- this one is currently called ssi-controller
> +--------+--------+
> | Port 1 | Port 2 | <- these are currently called ssi-port
> +--------+--------+
> 
> I think the GDD part must be enabled while Port 1 or Port 2 is
> enabled. The last RFC driver from Carlos did not even split up the
> irq/memory areas into different platform devices, but just requested
> all of them in one ssi platform device.

Might be worth checking. If these blocks have the revision and SYSC
register in the beginning of their address space like all omap modules,
then they are completely separate blocks and can idle independently.

The fact that they have separate interrutps makes me think that's the
case, otherwise there would be just interrupt(s) at the ssi-controllel
level.

> > The other binding pieces can be added later on as they get are ready.
> 
> Sure. They are almost finished btw. I was able to get a gsm network
> scan.

That's great :)

Regards,

Tony

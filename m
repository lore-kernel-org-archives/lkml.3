Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755903Ab3KVSt5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 13:49:57 -0500
Received: from mo2.mail-out.ovh.net ([178.32.228.2]:58037 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755413Ab3KVStz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 13:49:55 -0500
Date: Fri, 22 Nov 2013 19:42:47 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: "ivan.khoronzhuk" <ivan.khoronzhuk@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        grygorii.strashko@ti.com, Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>, gregkh@linuxfoundation.org,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@kernel.crashing.org>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] memory: ti-aemif: add bindings for AEMIF driver
Message-ID: <20131122184247.GO14627@ns203013.ovh.net>
References: <1384962416-14862-1-git-send-email-ivan.khoronzhuk@ti.com>
 <1384962416-14862-3-git-send-email-ivan.khoronzhuk@ti.com>
 <20131120182102.GK14627@ns203013.ovh.net>
 <528D076A.8070806@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <528D076A.8070806@ti.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Ovh-Tracer-Id: 11895976940886010682
X-Ovh-Remote: 91.121.171.124 (ns203013.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrjeegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.500002/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrjeegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21:03 Wed 20 Nov     , ivan.khoronzhuk wrote:
> On 11/20/2013 08:21 PM, Jean-Christophe PLAGNIOL-VILLARD wrote:
> >> +				the chip select signal.
> >> +				Minimum value is 1 (0 treated as 1).
> >> +
> >> +- ti,cs-wsetup:		write setup width, ns
> >> +				Time between the beginning of a memory cycle
> >> +				and the activation of write strobe.
> >> +				Minimum value is 1 (0 treated as 1).
> >> +
> >> +- ti,cs-wstrobe:	write strobe width, ns
> >> +				Time between the activation and deactivation of
> >> +				the write strobe.
> >> +				Minimum value is 1 (0 treated as 1).
> >> +
> >> +- ti,cs-whold:		write hold width, ns
> >> +				Time between the deactivation of the write
> >> +				strobe and the end of the cycle (which may be
> >> +				either an address change or the deactivation of
> >> +				the chip select signal.
> >> +				Minimum value is 1 (0 treated as 1).
> >> +
> >> +If any of the above parameters are absent, current parameter value will be taken
> >> +from the corresponding HW reg.
> >> +
> >> +The name for cs node must be in format csN, where N is the cs number.
> > 
> > this is wired we should use reg instead to represent the cs as done for SPI
> > or a an other property
> > 
> > Best Regards,
> > J.
> > 
> 
> Ok, I will add new property cs-chipselect like following :
> 
> ti,cs-chipselect:	number of chipselect. Indicates on the
> 			aemif driver which chipselect is used
> 			for accessing the memory.
> 			For compatibles "ti,davinci-aemif" and 
> 			"ti,keystone-aemif" it can be in range [0-3].
> 			For compatible "ti,omap-L138-aemif" range is [2-5].
> 
> Is it OK?

yes

I just have one issue the whole memory concept

for me we should do as done on pinctrl have a phandle on the device that
require it and handle it at device core level

as the memory controller is not necessarely on the same bus as the memory
device them selves

Best Regards,
J.
> 
> -- 
> Regards,
> Ivan Khoronzhuk

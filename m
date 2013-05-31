Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444Ab3EaOkQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 10:40:16 -0400
Received: from 12.mo1.mail-out.ovh.net ([87.98.162.229]:38697 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754500Ab3EaOkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 10:40:11 -0400
X-Greylist: delayed 12915 seconds by postgrey-1.27 at vger.kernel.org; Fri, 31 May 2013 10:40:11 EDT
Date: Fri, 31 May 2013 13:00:45 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Michal Simek <monstr@monstr.eu>
Cc: Michal Simek <michal.simek@xilinx.com>,
        Grant Likely <grant.likely@linaro.org>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: Re: [PATCH] of: Export of_irq_count for using in modules
Message-ID: <20130531110045.GF19834@game.jcrosoft.org>
References: <6aa29b1d109a46278a7f37b598defe07d6edfe60.1369921774.git.michal.simek@xilinx.com>
 <20130530201714.GE19834@game.jcrosoft.org>
 <51A85BEE.4000009@monstr.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51A85BEE.4000009@monstr.eu>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 9469099691871873999
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrvddvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrvddvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10:14 Fri 31 May     , Michal Simek wrote:
> Hi Jean-Christophe,
> 
> On 05/30/2013 10:17 PM, Jean-Christophe PLAGNIOL-VILLARD wrote:
> > On 15:49 Thu 30 May     , Michal Simek wrote:
> >> Export of_irq_count for modules.
> > 
> > can you explain why do you need to call of_irq_count
> 
> I need to count number of irq written in the DTS node.
> It is not fixed size that's why I need to proper way how to
> find it out.
> 
> I am using this loop.
> 	count = of_irq_count(pdev->dev.of_node);
> 	/* Alloc IRQ based on DTS to be sure that no other driver will use it */
> 	while (count--) {
> 		tmp->irq = irq_of_parse_and_map(pdev->dev.of_node, count);
> 		dev_info(&pdev->dev, "%d: Alloc irq: %d\n", count, tmp->irq);
> 		ret = request_irq(tmp->irq, zynq_remoteproc_interrupt, 0,
> 					dev_name(&pdev->dev), &pdev->dev);
> 		if (ret) {
> 			...
> 		}
> 	}
> 
> But of course if you think that this is incorrect to export it
> I can use what it is in of_irq_count body
> 368 int of_irq_count(struct device_node *dev)
> 369 {
> 370         int nr = 0;
> 371
> 372         while (of_irq_to_resource(dev, nr, NULL))
> 373                 nr++;
> 374
> 375         return nr;
> 376 }
> 
> Because of_irq_to_resource is exported for modules.
> Or is there any better way how to loop over all interrupts in DT node?

can just explain me why you need to call irq_of_parse_and_map in your driver?

as the irq will be provided in the resources normally

Best Regards,
J.
> 
> Thanks,
> Michal
> 
> -- 
> Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
> w: www.monstr.eu p: +42-0-721842854
> Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
> Maintainer of Linux kernel - Xilinx Zynq ARM architecture
> Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform
> 
> 



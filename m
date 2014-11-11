Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075AbaKKLHU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:07:20 -0500
Received: from lists.s-osg.org ([54.187.51.154]:44304 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751422AbaKKLHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:07:18 -0500
Date: Tue, 11 Nov 2014 09:07:10 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Sebastian Reichel <sre@kernel.org>
Cc: Hans Verkuil <hans.verkuil@cisco.com>, linux-media@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [RFCv2 1/8] [media] si4713: switch to devm regulator API
Message-ID: <20141111090710.7a60a846@recife.lan>
In-Reply-To: <1413904027-16767-2-git-send-email-sre@kernel.org>
References: <1413904027-16767-1-git-send-email-sre@kernel.org>
	<1413904027-16767-2-git-send-email-sre@kernel.org>
Organization: Samsung
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, 21 Oct 2014 17:07:00 +0200
Sebastian Reichel <sre@kernel.org> escreveu:

> This switches back to the normal regulator API (but use
> managed variant) in preparation for device tree support.

This patch broke compilation. Please be sure that none of the patches in
the series would break it, as otherwise git bisect would be broken.

Thanks,
Mauro

drivers/media/radio/si4713/si4713.c: In function 'si4713_powerup':
drivers/media/radio/si4713/si4713.c:369:10: error: 'struct si4713_device' has no member named 'supplies'
 
          ^
drivers/media/radio/si4713/si4713.c:370:35: error: 'struct si4713_device' has no member named 'supplies'
  if (sdev->vdd) {
                                   ^
drivers/media/radio/si4713/si4713.c:370:51: error: 'struct si4713_device' has no member named 'supply_data'
  if (sdev->vdd) {
                                                   ^
drivers/media/radio/si4713/si4713.c:402:10: error: 'struct si4713_device' has no member named 'supplies'
   v4l2_dbg(1, debug, &sdev->sd, "Device in power up mode\n");
          ^
drivers/media/radio/si4713/si4713.c:403:36: error: 'struct si4713_device' has no member named 'supplies'
   sdev->power_state = POWER_ON;
                                    ^
drivers/media/radio/si4713/si4713.c:403:52: error: 'struct si4713_device' has no member named 'supply_data'
   sdev->power_state = POWER_ON;
                                                    ^
drivers/media/radio/si4713/si4713.c: In function 'si4713_powerdown':
drivers/media/radio/si4713/si4713.c:435:11: error: 'struct si4713_device' has no member named 'supplies'
  int err;
           ^
drivers/media/radio/si4713/si4713.c:436:37: error: 'struct si4713_device' has no member named 'supplies'
  u8 resp[SI4713_PWDN_NRESP];
                                     ^
drivers/media/radio/si4713/si4713.c:437:16: error: 'struct si4713_device' has no member named 'supply_data'
 
                ^
drivers/media/radio/si4713/si4713.c: In function 'si4713_probe':
drivers/media/radio/si4713/si4713.c:1444:7: error: 'struct si4713_device' has no member named 'supplies'
 /* si4713_probe - probe for the device */
       ^
drivers/media/radio/si4713/si4713.c:1447:22: error: 'struct si4713_device' has no member named 'supplies'
 {
                      ^
drivers/media/radio/si4713/si4713.c:1448:7: error: 'struct si4713_device' has no member named 'supply_data'
  struct si4713_device *sdev;
       ^
drivers/media/radio/si4713/si4713.c:1450:46: error: 'struct si4713_device' has no member named 'supplies'
  struct v4l2_ctrl_handler *hdl;
                                              ^
drivers/media/radio/si4713/si4713.c:1451:11: error: 'struct si4713_device' has no member named 'supply_data'
  int rval, i;
           ^
drivers/media/radio/si4713/si4713.c:1583:26: error: 'struct si4713_device' has no member named 'supplies'
 
                          ^
drivers/media/radio/si4713/si4713.c:1583:42: error: 'struct si4713_device' has no member named 'supply_data'
 
                                          ^
drivers/media/radio/si4713/si4713.c: In function 'si4713_remove':
drivers/media/radio/si4713/si4713.c:1607:26: error: 'struct si4713_device' has no member named 'supplies'
   goto free_irq;
                          ^
drivers/media/radio/si4713/si4713.c:1607:42: error: 'struct si4713_device' has no member named 'supply_data'
   goto free_irq;

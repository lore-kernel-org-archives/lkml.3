Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932Ab3HUMtJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 08:49:09 -0400
Received: from va3ehsobe010.messaging.microsoft.com ([216.32.180.30]:3315 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751865Ab3HUMtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 08:49:05 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VS-1(zzbb2dI98dI9371I1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6h1082kz8dhz1de098h17326ah1de096h8275dh1de097hz2dh2a8h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h1155h)
Date: Wed, 21 Aug 2013 20:47:23 +0800
From: Dong Aisheng <b29396@freescale.com>
To: Rob Herring <robherring2@gmail.com>
CC: <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <grant.likely@linaro.org>, <rob@landley.net>,
        <rob.herring@calxeda.com>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 0/3] of: add update device node status via cmdline feature
Message-ID: <20130821124722.GB17748@b29396-Latitude-E6410>
References: <1376564133-11286-1-git-send-email-b29396@freescale.com>
 <520CCB70.8090908@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <520CCB70.8090908@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 15, 2013 at 07:37:04AM -0500, Rob Herring wrote:
> On 08/15/2013 05:55 AM, Dong Aisheng wrote:
> > We meet some boards having a lot of pin conflicts between different devices,
> > only one of them can be enabled to run at one time.
> > 
> > e.g. imx6q sabreauto board, i2c, spi, weim, flexcan, uart and etc involved
> > with pin conflict.
> > 
> > Instead of changing dts manually or adding a lot dts files according to
> > different device availability, we provide feature to dynamically update the
> > device node status via command line, then those devices involved with
> > pin conflict can be enabled or disabled dynamically.
> > 
> > It's conveniently to use and can save a lot dts board files, also can
> > permenantly fix the pin conflicts issue.
> 
> This doesn't scale either with updating of lots devices or when the next
> person comes along and wants to edit another property.
> 

I'm not sure about other property.
But we update it did cause by the real requirement, not arbitrary.
Or we can try to find another better way to avoid it.

> This is something u-boot is perfectly capable of handling and updating
> status is something lots of boards already do.
> 

How does uboot handle this according to our needs?
Also dynamically update the device node status with uboot command?
Can you help point out an example for me to check?

Regards
Dong Aisheng

> Rob
> 
> > 
> > The patch series is based on v3.11-rc5.
> > 
> > Dong Aisheng (3):
> >   of: add device node status update APIs
> >   of: add update device node status via cmdline feature
> >   of: add node status update via name format with cmdline
> > 
> >  Documentation/kernel-parameters.txt |   10 +++
> >  drivers/of/base.c                   |  107 +++++++++++++++++++++++++++++++++
> >  drivers/of/fdt.c                    |  111 +++++++++++++++++++++++++++++++++++
> >  include/linux/of.h                  |   13 ++++
> >  4 files changed, 241 insertions(+), 0 deletions(-)
> > 
> > 
> > 
> > _______________________________________________
> > linux-arm-kernel mailing list
> > linux-arm-kernel@lists.infradead.org
> > http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> > 
> 
> 


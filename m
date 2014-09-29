Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625AbaI2KZM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 06:25:12 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:13036 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601AbaI2KZK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 06:25:10 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 29 Sep 2014 03:24:26 -0700
From: Vidya Sagar <vidyas@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Krishna Thota <kthota@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v1] ARM: tegra: Fix sd4 regulator in Jetson TK1 device
 tree
Thread-Topic: [PATCH v1] ARM: tegra: Fix sd4 regulator in Jetson TK1 device
 tree
Thread-Index: AQHP1o7ln/2GHwUnqkWm/7z0JBMChZwNg2cAgApja8A=
Date: Mon, 29 Sep 2014 10:25:03 +0000
Message-ID: <1862760b05184b95948b5e4952db010d@bgmail103.nvidia.com>
References: <1411408675-32315-1-git-send-email-vidyas@nvidia.com>
 <5420731E.6040104@wwwdotorg.org>
In-Reply-To: <5420731E.6040104@wwwdotorg.org>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.24.46.46]
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> -----Original Message-----
> From: Stephen Warren [mailto:swarren@wwwdotorg.org]
> Sent: Tuesday, September 23, 2014 12:36 AM
> To: Vidya Sagar
> Cc: thierry.reding@gmail.com; Laxman Dewangan; Krishna Thota; linux-
> tegra@vger.kernel.org; linux@arm.linux.org.uk; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH v1] ARM: tegra: Fix sd4 regulator in Jetson TK1 device
> tree
> 
> On 09/22/2014 11:57 AM, Vidya Sagar wrote:
> > sd4 is an always on regulator which is turned on at boot time.
> > It is externally controller through gpio. This change reflects the
> > same in Jetson TK1 device tree
> 
> In the schematics, the "Power Sequencing" timing diagram says "S/W
> controlled" for SD4/+1.05V_RUN. I also don't see an "ENABLE1" pin on the
> AS3722, which would be required for ...
> 
> > +					ams,ext-control = <1>;
> 
> ... to be valid.
> 
> What's the source of information behind this change?
> 
> What symptoms does this patch correct?

I'm seeing one issue when I add support for PCIe suspend/resume functionality.
The issue is that, when regulator_bulk_diable() is called, disabling one of the power rails (which is deriving its voltage from SD4) of PCIe is failing.
The reason being, I2C controller is getting power gated before power rail disable is called.
Hence SD4 is made dependent on ENABLE1, which is nothing but the deep sleep signal coming from Tegra,
So eventually, SD4 will be powered off when system enters into deep-sleep state.
Source of information is from downstream kernel 



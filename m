Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732AbaIQBdH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 21:33:07 -0400
Received: from mail-bl2on0140.outbound.protection.outlook.com ([65.55.169.140]:53184
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754618AbaIQBdF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 21:33:05 -0400
X-Greylist: delayed 125057 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Sep 2014 21:33:05 EDT
Date: Wed, 17 Sep 2014 09:32:52 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Nicolin Chen <nicoleotsuka@gmail.com>
CC: Shengjiu Wang <shengjiu.wang@freescale.com>, <timur@tabi.org>,
        <Li.Xiubo@freescale.com>, <lgirdwood@gmail.com>, <broonie@kernel.org>,
        <perex@perex.cz>, <tiwai@suse.de>, <alsa-devel@alsa-project.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ASoC: fsl_spdif: don't change the root clock rate of
 spdif in driver
Message-ID: <20140917013251.GA4796@dragon>
References: <1410867994-32138-1-git-send-email-shengjiu.wang@freescale.com>
 <20140916180028.GA6784@Asurada>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140916180028.GA6784@Asurada>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(24454002)(189002)(51704005)(86362001)(6806004)(21056001)(20776003)(23726002)(85306004)(33656002)(1411001)(92566001)(110136001)(99396002)(4396001)(50986999)(46406003)(105606002)(83072002)(106466001)(76176999)(97756001)(97736003)(107046002)(64706001)(54356999)(83322001)(33716001)(102836001)(31966008)(84676001)(44976005)(95666004)(87936001)(92726001)(26826002)(85852003)(104016003)(68736004)(81342003)(46102003)(77982003)(83506001)(50466002)(47776003)(76482002)(57986006)(81542003)(79102003)(80022003)(74662003)(74502003)(90102001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0615;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0337AFFE9A
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Shawn.Guo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2014 at 11:19:28AM -0700, Nicolin Chen wrote:
> On Tue, Sep 16, 2014 at 07:46:34PM +0800, Shengjiu Wang wrote:
> > The spdif root clock may be used by other module or defined with
> > CLK_SET_RATE_GATE, so we can't change the clock rate in driver.
> > In this patch remove the clk_set_rate and clk_round_rate to protect the
> > clock.
> 
> It's a quite convenient and conservative way to remove the clock
> dealing code in the driver, however, it may result less flexible
> functionalities.
> 
> The reason why I left the clk_set_rate() in the driver is to hope
> we may find a better way to tackle those tough situations. For IP
> itself, it doesn't matter if the clock the SoC provides to it is
> being shared by other modules or not.
> 
> So I think, if it's a shared clock, we should not define it as a
> rate-changeable one in the SoC level, as we might still have some
> SoCs provide a dedicated clock to S/PDIF so as to get the maximum
> range of clock support for users.
> 
> @Shawn
> Sorry to involve you in this topic. I'm not so sure if we can do
> this in the clock driver so that the clock rate would be fixed
> even if the driver is trying to change it. If we can, I think we
> may use a better solution here instead.

No, we do not have anything like that today.

Shawn

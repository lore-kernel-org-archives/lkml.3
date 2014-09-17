Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277AbaIQCbn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 22:31:43 -0400
Received: from mail-bn1bon0116.outbound.protection.outlook.com ([157.56.111.116]:21894
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753283AbaIQCbm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 22:31:42 -0400
X-Greylist: delayed 88814 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Sep 2014 22:31:41 EDT
Date: Wed, 17 Sep 2014 10:31:28 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Nicolin Chen <nicoleotsuka@gmail.com>
CC: Shengjiu Wang <shengjiu.wang@freescale.com>, <timur@tabi.org>,
        <Li.Xiubo@freescale.com>, <lgirdwood@gmail.com>, <broonie@kernel.org>,
        <perex@perex.cz>, <tiwai@suse.de>, <alsa-devel@alsa-project.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ASoC: fsl_spdif: don't change the root clock rate of
 spdif in driver
Message-ID: <20140917023127.GA16456@dragon>
References: <1410867994-32138-1-git-send-email-shengjiu.wang@freescale.com>
 <20140916180028.GA6784@Asurada> <20140917013251.GA4796@dragon>
 <20140917022440.GA3216@Asurada>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140917022440.GA3216@Asurada>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(24454002)(189002)(199003)(57986006)(50986999)(76176999)(95666004)(54356999)(99396002)(46406003)(107046002)(92726001)(92566001)(86362001)(110136001)(90102001)(33716001)(97736003)(84676001)(74502003)(74662003)(81542003)(81342003)(106466001)(4396001)(79102003)(31966008)(77982003)(85852003)(83072002)(105606002)(97756001)(83506001)(47776003)(20776003)(68736004)(46102003)(64706001)(87936001)(6806004)(83322001)(50466002)(44976005)(102836001)(104016003)(33656002)(1411001)(80022003)(21056001)(23726002)(85306004)(76482002)(93886004)(26826002);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2PR03MB321;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0337AFFE9A
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Shawn.Guo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2014 at 07:24:40PM -0700, Nicolin Chen wrote:
> It's not supported in the clock API or just not implemented in our
> code? Can we just register a clock without CLK_SET_RATE_PARENT to
> achieve the purpose? (We are just trying to fix those PRED and PODF
> dividers when the driver calls set_rate to their GATE clock.)

It seems I misunderstood your question.  Yes, if we drop flag
CLK_SET_RATE_PARENT for the gate clock in question, the rate change
request will not be propagated to upstream dividers.

Shawn

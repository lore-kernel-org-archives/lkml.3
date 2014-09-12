Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751904AbaILFMD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 01:12:03 -0400
Received: from mail-bl2on0143.outbound.protection.outlook.com ([65.55.169.143]:49615
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751066AbaILFMB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 01:12:01 -0400
Date: Fri, 12 Sep 2014 13:11:42 +0800
From: Shengjiu Wang <shengjiu.wang@freescale.com>
To: Timur Tabi <timur@tabi.org>
CC: <nicoleotsuka@gmail.com>, <Li.Xiubo@freescale.com>, <lgirdwood@gmail.com>,
        <broonie@kernel.org>, <perex@perex.cz>, <tiwai@suse.de>,
        <alsa-devel@alsa-project.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2] ASoC: fsl_ssi: refine ipg clock usage in this module
Message-ID: <20140912051140.GA3644@audiosh1>
References: <27584da8e3ab291ab8dbcbb411579613f8384a59.1410413734.git.shengjiu.wang@freescale.com>
 <54125DEF.4090101@tabi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <54125DEF.4090101@tabi.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(51704005)(199003)(189002)(24454002)(81542001)(6806004)(50986999)(76176999)(74502001)(106466001)(47776003)(4396001)(81342001)(64706001)(81156004)(110136001)(74662001)(83322001)(85306004)(54356999)(90102001)(104016003)(97736003)(20776003)(97756001)(68736004)(69596002)(83506001)(105606002)(84676001)(107046002)(44976005)(46102001)(33716001)(76482001)(92566001)(86362001)(83072002)(85852003)(21056001)(77982001)(23726002)(92726001)(79102001)(99396002)(50466002)(33656002)(26826002)(102836001)(31966008)(95666004)(46406003)(80022001)(87936001);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0301MB0620;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0332AACBC3
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=shengjiu.wang@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 09:43:59PM -0500, Timur Tabi wrote:
> Shengjiu Wang wrote:
> >+	ret = clk_prepare_enable(ssi_private->clk);
> >+	if (ret)
> >+		return ret;
> 
> Will this work on PowerPC, where ssi_private->clk is always NULL?

When ssi_private->clk is NULL, then ret = 0, so here will not return,
the code in below will be continuously executed.
I think it work on PowerPC.

wang shengjiu

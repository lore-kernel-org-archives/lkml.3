Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117AbaG2KWA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 06:22:00 -0400
Received: from dns-bn1lp0143.outbound.protection.outlook.com ([207.46.163.143]:25390
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751619AbaG2KV7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 06:21:59 -0400
Date: Tue, 29 Jul 2014 18:19:51 +0800
From: Nicolin Chen <Guangyu.Chen@freescale.com>
To: Mark Brown <broonie@kernel.org>
CC: Fabio Estevam <festevam@gmail.com>, Nicolin Chen <nicoleotsuka@gmail.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        <patches@opensource.wolfsonmicro.com>, <b02247@freescale.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Nicolin Chen <b42378@freescale.com>
Subject: Re: [alsa-devel] [PATCH v2] ASoC: wm8962: Let CODEC driver enable
 and disable its own MCLK
Message-ID: <20140729101950.GB5495@MrMyself>
References: <1406547718-21498-1-git-send-email-nicoleotsuka@gmail.com>
 <20140728122211.GS17528@sirena.org.uk>
 <CAOMZO5DgE9RjC9MG7FbGPKwsgxunntw70W6Sj8WQKFYG+j8BsA@mail.gmail.com>
 <20140729025518.GB3350@MrMyself> <20140729095203.GK17528@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140729095203.GK17528@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199002)(24454002)(51704005)(33656002)(92566001)(33716001)(102836001)(97756001)(92726001)(86362001)(21056001)(4396001)(74662001)(74502001)(93886003)(97736001)(44976005)(85852003)(107046002)(76176999)(54356999)(99396002)(26826002)(84676001)(50466002)(50986999)(79102001)(68736004)(83072002)(104016003)(83506001)(110136001)(64706001)(46406003)(47776003)(76482001)(20776003)(95666004)(106466001)(83322001)(87936001)(81342001)(31966008)(80022001)(105606002)(81542001)(23726002)(46102001)(77982001)(85306003)(6806004);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR03MB440;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0287BBA78D
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=guangyu.chen@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2014 at 10:52:03AM +0100, Mark Brown wrote:
> On Tue, Jul 29, 2014 at 10:55:19AM +0800, Nicolin Chen wrote:
> > On Mon, Jul 28, 2014 at 03:19:43PM -0300, Fabio Estevam wrote:
> 
> > > >> +     pdata->mclk = devm_clk_get(&i2c->dev, NULL);
> 
> > > > This is broken for deferred probe.
> 
> > Sorry. I don't get why deferred probe would be broken by this.
> > And I just took a test by adding this:
> 
> I don't see the code that actually pays attention to the return value
> from devm_clk_get() - in the main probe function the code just treats
> all errors as a missing MCLK.

Just checked the clk_get() code and got the point.

I will add a check to it and return for EPROBE_DEFER.

Thank you,
Nicolin

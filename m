Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222AbaHFBLP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 21:11:15 -0400
Received: from mail-bl2lp0212.outbound.protection.outlook.com ([207.46.163.212]:13947
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753729AbaHFBLN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 21:11:13 -0400
Date: Wed, 6 Aug 2014 09:10:46 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Eduardo Valentin <edubezval@gmail.com>
CC: Anson Huang <b20788@freescale.com>, <rui.zhang@intel.com>,
        <eduardo.valentin@ti.com>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH] Thermal: imx: add i.mx6sx thermal support
Message-ID: <20140806011045.GC27051@dragon>
References: <1407229963-32662-1-git-send-email-b20788@freescale.com>
 <20140805132553.GA20291@developer>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140805132553.GA20291@developer>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Matching-Connectors: 130517610521780466;(91ab9b29-cfa4-454e-5278-08d120cd25b8);()
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009003)(6009001)(448002)(189002)(199002)(24454002)(51704005)(92726001)(92566001)(50466002)(99396002)(76176999)(50986999)(54356999)(81156004)(106466001)(85306004)(21056001)(57986006)(95666004)(74502001)(74662001)(102836001)(77982001)(1411001)(31966008)(26826002)(76482001)(33716001)(68736004)(84676001)(83506001)(33656002)(79102001)(69596002)(85326001)(107046002)(85852003)(83072002)(110136001)(87936001)(104016003)(6806004)(44976005)(86362001)(83322001)(97736001)(97756001)(4396001)(46102001)(23726002)(46406003)(80022001)(64706001)(20776003)(81342001)(47776003)(81542001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR03MB366;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02951C14DC
Authentication-Results: spf=permerror (sender IP is 192.88.158.2)
 smtp.mailfrom=shawn.guo@linaro.org; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2014 at 09:25:53AM -0400, Eduardo Valentin wrote:
> > @@ -31,6 +32,10 @@
> >  
> >  #define MISC0				0x0150
> >  #define MISC0_REFTOP_SELBIASOFF		(1 << 3)
> > +#define MISC1				0x0160
> > +#define MISC1_IRQ_TEMPHIGH		(1 << 29)
> > +#define MISC1_IRQ_TEMPLOW		(1 << 28)
> > +#define MISC1_IRQ_TEMPPANIC		(1 << 27)
> 
> how about using 
> +#define MISC1_IRQ_TEMPHIGH		BIT(29)
> +#define MISC1_IRQ_TEMPLOW		BIT(28)
> +#define MISC1_IRQ_TEMPPANIC		BIT(27)

While I agree this is good, I think it's more important to keep the
style consistent for the file.  We already have a number of (1 << x)
in the file.

...

> > @@ -66,6 +76,21 @@ enum imx_thermal_trip {
> >  #define FACTOR1				15976
> >  #define FACTOR2				4297157
> >  
> > +#define TEMPMON_V1			1
> > +#define TEMPMON_V2			2
> > +
> 
> where does the V1/V2 nomenclature come from? how about:
> 
> +#define TEMPMON_IMX6Q			1
> +#define TEMPMON_IMX6SX			2

+1

If the V1/V2 nomenclature is not coming from hardware manual, we don't
want to use it, neither code nor binding doc.

Shawn

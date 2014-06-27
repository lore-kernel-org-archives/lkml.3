Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752663AbaF0FMk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 01:12:40 -0400
Received: from mail-by2lp0240.outbound.protection.outlook.com ([207.46.163.240]:32288
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752570AbaF0FMh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 01:12:37 -0400
Date: Fri, 27 Jun 2014 11:41:52 +0800
From: Peter Chen <peter.chen@freescale.com>
To: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
CC: <sebastian.hesselbarth@gmail.com>, <alexandre.belloni@free-electrons.com>,
        <thomas.petazzoni@free-electrons.com>, <zmxu@marvell.com>,
        <jszhang@marvell.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 07/12] usb: chipidea: add a generic driver
Message-ID: <20140627034151.GC18039@shlinux1.ap.freescale.net>
References: <1403606121-6368-1-git-send-email-antoine.tenart@free-electrons.com>
 <1403606121-6368-8-git-send-email-antoine.tenart@free-electrons.com>
 <20140627032506.GA18039@shlinux1.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140627032506.GA18039@shlinux1.ap.freescale.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(24454002)(199002)(189002)(51704005)(81156004)(26826002)(95666004)(104016002)(105606002)(107046002)(106466001)(97736001)(33656002)(85306003)(83506001)(44976005)(102836001)(92726001)(84676001)(19580395003)(81542001)(47776003)(64706001)(79102001)(83072002)(4396001)(21056001)(99396002)(6806004)(86362001)(68736004)(76176999)(50986999)(69596002)(85852003)(92566001)(54356999)(76482001)(80022001)(87936001)(20776003)(83322001)(19580405001)(81342001)(50466002)(74662001)(23756003)(77982001)(46102001)(74502001)(31966008)(41533002);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR03MB086;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
X-Forefront-PRVS: 0255DF69B9
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Peter.Chen@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2014 at 11:25:07AM +0800, Peter Chen wrote:
> On Tue, Jun 24, 2014 at 12:35:16PM +0200, Antoine Ténart wrote:
> > Add a generic ChipIdea driver, with optional PHY and clock, to support
> > ChipIdea controllers that doesn't need specific functions.
> > 
> > +	return 0;
> > +}
> > +
> > +static const struct of_device_id ci_hdrc_generic_of_match[] = {
> > +	{ .compatible = "chipidea-usb" },
> > +	{ }
> > +};
> 
> Even as a generic driver, you can also use your own compatible string.
> 
> > +MODULE_DEVICE_TABLE(of, ci_hdrc_generic_of_match);
> > +
> > +static struct platform_driver ci_hdrc_generic_driver = {
> > +	.probe	= ci_hdrc_generic_probe,
> > +	.remove	= ci_hdrc_generic_remove,
> > +	.driver	= {
> > +		.name		= "chipidea-usb",
> > +		.owner		= THIS_MODULE,
> > +		.of_match_table	= ci_hdrc_generic_of_match,
> > +	},
> > +};
> > +module_platform_driver(ci_hdrc_generic_driver);
> > +
> > +MODULE_DESCRIPTION("Generic ChipIdea HDRC USB binding");
> > +MODULE_AUTHOR("Antoine Ténart <antoine.tenart@free-electrons.com>");
> > +MODULE_LICENSE("GPL");
> > -- 
> > 1.9.1
> > 
> 
> -- 
> 

Besides, I haven't seen dma_coerce_mask_and_coherent API calling,
where you set your dma mask?

-- 

Best Regards,
Peter Chen

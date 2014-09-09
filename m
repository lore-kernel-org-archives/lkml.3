Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751330AbaIIEHq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 00:07:46 -0400
Received: from mail-bn1bon0140.outbound.protection.outlook.com ([157.56.111.140]:57645
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750770AbaIIEHo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 00:07:44 -0400
X-Greylist: delayed 3618 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Sep 2014 00:07:44 EDT
Date: Tue, 9 Sep 2014 10:41:02 +0800
From: Robin Gong <b38343@freescale.com>
To: Mark Brown <broonie@kernel.org>
CC: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, <lgirdwood@gmail.com>,
        <devicetree@vger.kernel.org>, <robh+dt@kernel.org>,
        <grant.likely@linaro.org>
Subject: Re: PFUZE100 regulator not going off when PWRON is 0
Message-ID: <20140909024100.GA19119@Robin-OptiPlex-780>
References: <CAL8zT=hNnRU3gbprVXOMt6FC9veRvQKRmS9gSeCm5-DNfGv-xg@mail.gmail.com>
 <20140903125248.GK29327@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140903125248.GK29327@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019018)(6009001)(199003)(189002)(51704005)(24454002)(80022001)(20776003)(83072002)(92726001)(87936001)(74662001)(92566001)(85852003)(74502001)(23726002)(46406003)(97756001)(79102001)(46102001)(4396001)(47776003)(77982001)(64706001)(76482001)(50986999)(6806004)(83322001)(44976005)(33656002)(102836001)(95666004)(104016003)(106466001)(54356999)(99396002)(105606002)(33716001)(81342001)(81542001)(85306004)(31966008)(84676001)(76176999)(83506001)(26826002)(21056001)(50466002)(110136001)(107046002)(90102001)(97736003)(68736004)(42262002);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR03MB568;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0329B15C8A
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=yibin.gong@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for Mark's forward.

Hi Jean-Michel,
  Yes, SWxOMODE can be set as 1 to active sleep mode if PWRON turn-off event
occurs. And the voltage of sleep mode can be set in other register SWxOFF. But
by default, SWxOMODE is 0 which means all SW will be turned off while PWRON go
form 1 to 0. For your issue, I hope you check the hardware design, and measure
PWRON pin to see whether it has been pulled low once your push reset key.

On Wed, Sep 03, 2014 at 01:52:48PM +0100, Mark Brown wrote:
> On Wed, Sep 03, 2014 at 11:44:22AM +0200, Jean-Michel Hautbois wrote:
> 
> > I have a custom i.MX6 based board, but PMIC part is exactly the same
> > as the Freescale SabreSD board.
> > I have a reset button, which makes the PWRON signal on PFUZE100 go from 1 to 0.
> > I thought this would reset the chip, and thus all voltages would go to
> > 0, but this is not the case. It seems that SWxOMODE registers are
> > involved in this process, accorgind to the datasheet, but I don't
> > think this is implemented right now.
> > 
> > I also removed regulator-always-on for my SW2 pin in order to get it
> > off, but this has no effect.
> 
> You should really contact someone who worked on the driver or Freescale
> about this - I don't think anyone on the CC list knows anything about
> the part.  In general if you're asking about a specific driver this is a
> good approach.  I've CCed Robin Gong who was the original author.



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280AbaIIDCq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 23:02:46 -0400
Received: from mail-bn1on0141.outbound.protection.outlook.com ([157.56.110.141]:9680
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753802AbaIIDCo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 23:02:44 -0400
X-Greylist: delayed 937 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Sep 2014 23:02:44 EDT
From: "Hong-Xing.Zhu@freescale.com" <Hong-Xing.Zhu@freescale.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Shawn Guo <Shawn.Guo@freescale.com>
CC: Raymond van der Rots <raymond@electrocompaniet.no>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lucas Stach <l.stach@pengutronix.de>,
        Tim Harvey <tharvey@gateworks.com>
Subject: RE: [PATCH] imx6 PCI Host initialisation order
Thread-Topic: [PATCH] imx6 PCI Host initialisation order
Thread-Index: AQHPy0TIlq5CYJg2AkKj34Cl9RDVGJv3GWeAgABaOQCAAKX+sA==
Date: Tue, 9 Sep 2014 02:47:03 +0000
Message-ID: <9d6437c810424c6fb558179dac09cb2e@DM2PR0301MB0862.namprd03.prod.outlook.com>
References: <BD2B99C7-743D-429F-801E-FCFAFAE4A7DB@electrocompaniet.no>
 <20140908112810.GA2799@dragon>
 <CAErSpo4scddSydpoVqb73pBvJshOq=YJcV17ePGe0uyQ+xymhw@mail.gmail.com>
In-Reply-To: <CAErSpo4scddSydpoVqb73pBvJshOq=YJcV17ePGe0uyQ+xymhw@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [123.151.195.50]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;
x-forefront-prvs: 0329B15C8A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019018)(6009001)(13464003)(24454002)(189002)(51704005)(199003)(377454003)(85306004)(86362001)(76576001)(108616004)(66066001)(74316001)(106116001)(15202345003)(107046002)(15975445006)(106356001)(2656002)(85852003)(92566001)(90102001)(87936001)(77096002)(31966008)(20776003)(74502001)(74662001)(64706001)(80022001)(81542001)(4396001)(99286002)(101416001)(54356999)(99396002)(19580405001)(95666004)(83072002)(77982001)(33646002)(76176999)(105586002)(81342001)(79102001)(21056001)(46102001)(19580395003)(50986999)(76482001)(97736003)(83322001)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR03MB351;H:DM2PR0301MB0862.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s8932pJE003061


> -----Original Message-----
> From: Bjorn Helgaas [mailto:bhelgaas@google.com]
> Sent: Tuesday, September 09, 2014 12:51 AM
> To: Guo Shawn-R65073
> Cc: Raymond van der Rots; Zhu Richard-R65037; linux-kernel@vger.kernel.org;
> Lucas Stach; Tim Harvey
> Subject: Re: [PATCH] imx6 PCI Host initialisation order
> 
> On Mon, Sep 8, 2014 at 5:28 AM, Shawn Guo <shawn.guo@freescale.com> wrote:
> > Hi Raymond,
> >
> > It seems that there is already a similar patch [1] from Tim floating
> > on the list.
> >
> > Shawn
> >
> > [1] http://www.spinics.net/lists/linux-pci/msg33520.html
> 
> Yes.  MAINTAINERS lists Richard Zhu <r65037@freescale.com> and Shawn Guo
> <shawn.guo@freescale.com> (hi Shawn :)) as the caretakers for pci-imx6.c.
> Neither has acked it yet, and Richard asked for a comment update, which I
> haven't seen yet.  So I haven't applied it yet.
> 
[Richard] Yes it is. I recommended to add one comment used to describe why
the modification is required.

> > On Mon, Sep 08, 2014 at 11:10:37AM +0200, Raymond van der Rots wrote:
> >> Hi,
> >>
> >> The imx6dl on our hardware board frequently had problems bringing up the
> PCI link, with or without peripherals connected. I found these issues to be
> due to the initialisation order of the PCI Host.
> >>
> >> The host driver first enables the phy, and then enables its clocks. However,
> according to the reference manual (IMX6SDLRM, page 2033):
> >> > The phy_ref_ssp_en signal must remain deasserted until the reference
> clock is running at the appropriate frequency, at which point phy_ref_ssp_en
> can be asserted.
> >>
> >>
> >> Which implies that the clocks should be brought up first, after which the
> peripheral should be enabled.
> >> This patch changes that initialisation order.
> >>
> >> I do not have other hardware with an imx6dl, so this patch has only been
> tested on our board. Could someone confirm that this is more technically
> correct or improves behaviour?
> >>
> >> Signed-off-by: Raymond van der Rots <raymond@electrocompaniet.no>
> >> ---
> >> diff --git a/drivers/pci/host/pci-imx6.c
> >> b/drivers/pci/host/pci-imx6.c index a568efa..17c35b4 100644
> >> --- a/drivers/pci/host/pci-imx6.c
> >> +++ b/drivers/pci/host/pci-imx6.c
> >> @@ -228,11 +228,6 @@ static int imx6_pcie_deassert_core_reset(struct
> pcie_port *pp)
> >>       struct imx6_pcie *imx6_pcie = to_imx6_pcie(pp);
> >>       int ret;
> >>
> >> -     regmap_update_bits(imx6_pcie->iomuxc_gpr, IOMUXC_GPR1,
> >> -                     IMX6Q_GPR1_PCIE_TEST_PD, 0 << 18);
> >> -     regmap_update_bits(imx6_pcie->iomuxc_gpr, IOMUXC_GPR1,
> >> -                     IMX6Q_GPR1_PCIE_REF_CLK_EN, 1 << 16);
> >> -
> >>       ret = clk_prepare_enable(imx6_pcie->pcie_phy);
> >>       if (ret) {
> >>               dev_err(pp->dev, "unable to enable pcie_phy clock\n");
> >> @@ -254,6 +249,11 @@ static int imx6_pcie_deassert_core_reset(struct
> pcie_port *pp)
> >>       /* allow the clocks to stabilize */
> >>       usleep_range(200, 500);
> >>
> >> +     regmap_update_bits(imx6_pcie->iomuxc_gpr, IOMUXC_GPR1,
> >> +                     IMX6Q_GPR1_PCIE_TEST_PD, 0 << 18);
> >> +     regmap_update_bits(imx6_pcie->iomuxc_gpr, IOMUXC_GPR1,
> >> +                     IMX6Q_GPR1_PCIE_REF_CLK_EN, 1 << 16);
> >> +
> >>       /* Some boards don't have PCIe reset GPIO. */
> >>       if (gpio_is_valid(imx6_pcie->reset_gpio)) {
> >>               gpio_set_value(imx6_pcie->reset_gpio, 0);
> >>
> >>

Best Regards
Richard Zhu

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

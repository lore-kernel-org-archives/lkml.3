Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752367AbaJFI4v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 04:56:51 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:56931 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbaJFI4s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 04:56:48 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.49 with qID s968udS2013096, This message is accepted by code: ctloc85258
From: Hau <hau@realtek.com>
To: Francois Romieu <romieu@fr.zoreil.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 net-next] r8169:add support for RTL8168EP
Thread-Topic: [PATCH v2 net-next] r8169:add support for RTL8168EP
Thread-Index: AQHP3utXPbfOR7DfDU2GBQvdbyj53pweTmwAgAR3zKA=
Date: Mon, 6 Oct 2014 08:56:39 +0000
Message-ID: <80377ECBC5453840BA8C7155328B537765786D@RTITMBSV03.realtek.com.tw>
References: <1412328052-8480-1-git-send-email-hau@realtek.com>
 <20141003203244.GA19965@electric-eye.fr.zoreil.com>
In-Reply-To: <20141003203244.GA19965@electric-eye.fr.zoreil.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.71.179]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> -----Original Message-----
> From: Francois Romieu [mailto:romieu@fr.zoreil.com]
> Sent: Saturday, October 04, 2014 4:33 AM
> To: Hau
> Cc: netdev@vger.kernel.org; nic_swsd; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v2 net-next] r8169:add support for RTL8168EP
> 
> Chun-Hao Lin <hau@realtek.com> :
> [...]
> > diff --git a/drivers/net/ethernet/realtek/r8169.c
> > b/drivers/net/ethernet/realtek/r8169.c
> > index 54476ba..3efdf4d 100644
> > --- a/drivers/net/ethernet/realtek/r8169.c
> > +++ b/drivers/net/ethernet/realtek/r8169.c
> [...]
> > @@ -1276,6 +1273,52 @@ static void rtl_w0w1_eri(struct rtl8169_private
> *tp, int addr, u32 mask, u32 p,
> >  	rtl_eri_write(tp, addr, mask, (val & ~m) | p, type);  }
> >
> > +static u32 ocp_read(struct rtl8169_private *tp, u8 mask, u16 reg) {
> > +	void __iomem *ioaddr = tp->mmio_addr;
> > +
> > +	switch (tp->mac_version) {
> > +	case RTL_GIGA_MAC_VER_27:
> > +	case RTL_GIGA_MAC_VER_28:
> > +	case RTL_GIGA_MAC_VER_31:
> > +		RTL_W32(OCPAR, ((u32)mask & 0x0f) << 12 | (reg & 0x0fff));
> > +		return rtl_udelay_loop_wait_high(tp, &rtl_ocpar_cond, 100,
> 20)
> > +			? RTL_R32(OCPDR) : ~0;
> 
> '?' should be on the previous line. There isn't more room than needed but it's
> still ok.
> 
> [...]
> > +static void rtl8168ep_2_hw_phy_config(struct rtl8169_private *tp) {
> [...]
> > +	rtl_w0w1_phy(tp, 0x14, 0x7C00, ~0x7Cff);
> 
> Nit:	rtl_w0w1_phy(tp, 0x14, 0x7c00, ~0x7cff);
> 
> [...]
> +	rtl_writephy(tp, 0x1f, 0x0bC8);
> 
> Nit:	rtl_writephy(tp, 0x1f, 0x0bc8);
> 
> Tangent: please find feature wise identical code below without moves.
> I have avoided introducing more helpers that may have kept the code more
> balanced for 8168dp vs 8168ep as it wasn't the point and it is still possible to
> change the code from there.
> 
> It provides a different review experience. Feel free to give it a thought.

Do you mean I should collect similar hardware parameters setting into one function?
or
I should set hardware parameters according to hardware feature support version?
For example,
If mac_version == RTL8168DP
	dash_ver = 1
else If mac_version == RTL8168DP
	dash_ver = 2

if dashver == 1
	...
else if dashver == 2
	...


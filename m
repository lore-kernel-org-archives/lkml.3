Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422Ab3HVVYz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 17:24:55 -0400
Received: from vaxjo.synopsys.com ([198.182.60.75]:43976 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753841Ab3HVVYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 17:24:52 -0400
From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>, Kumar Gala <galak@codeaurora.org>
CC: "balbi@ti.com" <balbi@ti.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "rob@landley.net" <rob@landley.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "idos@codeaurora.org" <idos@codeaurora.org>,
        "mgautam@codeaurora.org" <mgautam@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "Paul Zimmerman" <paul.zimmerman@synopsys.com>
Subject: RE: [PATCH v4 2/3] usb: phy: Add Qualcomm SS-USB and HS-USB drivers
 for DWC3 core
Thread-Topic: [PATCH v4 2/3] usb: phy: Add Qualcomm SS-USB and HS-USB
 drivers for DWC3 core
Thread-Index: AQHOnYwe3t9ZTCrcSUyFxu1tlLyxA5mee/qAgAARrYCAAAFZAIAACPCAgAAGvoCAAAXdAIAAAesAgAAHCYCAAxFkUA==
Date: Thu, 22 Aug 2013 21:24:49 +0000
Message-ID: <A2CA0424C0A6F04399FB9E1CD98E030458DECB7C@US01WEMBX2.internal.synopsys.com>
References: <1376992565-22292-1-git-send-email-iivanov@mm-sol.com>
	 <1376992565-22292-3-git-send-email-iivanov@mm-sol.com>
	 <20130820122907.GU26587@radagast>
	 <1377005543.26268.22.camel@iivanov-dev.int.mm-sol.com>
	 <20130820133712.GC26587@radagast>
	 <1377007751.26268.27.camel@iivanov-dev.int.mm-sol.com>
	 <20130820143319.GG26587@radagast>
	 <1377010458.26268.30.camel@iivanov-dev.int.mm-sol.com>
	 <8691FDFE-326E-4198-838A-202D9EC988E1@codeaurora.org>
 <1377012381.26268.42.camel@iivanov-dev.int.mm-sol.com>
In-Reply-To: <1377012381.26268.42.camel@iivanov-dev.int.mm-sol.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.9.64.240]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r7MLP0Nd001649

> From: Ivan T. Ivanov [mailto:iivanov@mm-sol.com]
> Sent: Tuesday, August 20, 2013 8:26 AM
> 
> On Tue, 2013-08-20 at 10:01 -0500, Kumar Gala wrote:
> > On Aug 20, 2013, at 9:54 AM, Ivan T. Ivanov wrote:
> >
> > >
> > > Hi,
> > >
> > > On Tue, 2013-08-20 at 09:33 -0500, Felipe Balbi wrote:
> > >> On Tue, Aug 20, 2013 at 05:09:11PM +0300, Ivan T. Ivanov wrote:
> > >>>
> > >>> On Tue, 2013-08-20 at 08:37 -0500, Felipe Balbi wrote:
> > >>>>
> > >>>> On Tue, Aug 20, 2013 at 04:32:23PM +0300, Ivan T. Ivanov wrote:
> > >>>>>
> > >>>>> I think they are SNPS DesignWare PHY's, additionally
> > >>>>> wrapped with Qualcomm logic. I could substitute "dwc3"
> > >>>>> with just "dw", which will be more correct.
> > >>>>
> > >>>> alright, thank you. Let's add Paul to the loop since he might have very
> > >>>> good insight in the synopsys PHYs.
> > >>>>
> > >>>> mental note: if any other platform shows up with Synopsys PHY, ask them
> > >>>> to use this driver instead :-)
> > >>>
> > >>> I really doubt that this will bi possible. Control of the PHY's is
> > >>> not directly trough ULPI, UTMI or PIPE3 interfaces, but trough
> > >>> QSCRATCH registers, which of course is highly Qualcomm specific.
> > >>
> > >> isn't it a memory mapped IP ? doesn't synopsys provide their own set of
> > >> registers ?
> > >
> > > From what I see it is not directly mapped. How QSCRATCH write and
> > > reads transactions are translated to DW IP is unclear to me.
> >
> >
> > I think the question is how does SW access them?
> 
> "USB QSCRATCH Hardware registers" don't ask me what is this :-)
> or like Pawel says: "it depends on the SOC" .

To answer the question "doesn't synopsys provide their own set of
registers", we provide registers in our USB cores to access the PHYs
through I2C, ULPI/UTMI, or PIPE3 interfaces. But if someone wants to use
our PHY with some other controller that doesn't provide that, then they
may need to implement their own register set, as Qualcomm has apparently
done.

-- 
Paul

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

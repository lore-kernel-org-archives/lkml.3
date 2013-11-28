Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759164Ab3K1RCc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 12:02:32 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:53474 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754705Ab3K1RC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 12:02:27 -0500
X-AuditID: cbfec7f4-b7fea6d0000026ac-19-52977720f6ee
From: Kamil Debski <k.debski@samsung.com>
To: "'Matt Porter'" <matt.porter@linaro.org>,
        "'Kishon Vijay Abraham I'" <kishon@ti.com>
Cc: "'Felipe Balbi'" <balbi@ti.com>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        "'Rob Herring'" <rob.herring@calxeda.com>,
        "'Pawel Moll'" <pawel.moll@arm.com>,
        "'Mark Rutland'" <mark.rutland@arm.com>,
        "'Kumar Gala'" <galak@codeaurora.org>,
        "'Ian Campbell'" <ijc+devicetree@hellion.org.uk>,
        "'Christian Daudt'" <bcm@fixthebug.org>,
        "'Paul Zimmerman'" <paulz@synopsys.com>,
        Tomasz Figa <t.figa@samsung.com>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Linux USB List'" <linux-usb@vger.kernel.org>,
        "'Linux ARM Kernel List'" 
	<linux-arm-kernel@lists.infradead.org>,
        "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>,
        "'Devicetree List'" <devicetree@vger.kernel.org>,
        "'Linaro Patches'" <patches@linaro.org>
References: <1385403367-18144-1-git-send-email-matt.porter@linaro.org>
 <1385403367-18144-6-git-send-email-matt.porter@linaro.org>
 <529476A4.8080600@ti.com> <20131127171325.GD31091@beef>
 <20131127223650.GP31091@beef> <5296DA70.8010409@ti.com>
 <20131128164138.GS31091@beef>
In-reply-to: <20131128164138.GS31091@beef>
Subject: RE: [PATCH v3 5/9] usb: gadget: s3c-hsotg: use generic
 phy_init()/phy_exit() support
Date: Thu, 28 Nov 2013 18:02:22 +0100
Message-id: <033a01ceec5b$9bc1c6f0$d34554d0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7sWLp3KjHSnyW4QGmkX04m3aNNtwAAUY8w
Content-language: pl
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsVy+t/xy7oK5dODDD6+YLU4eL/e4lfjSiaL
	+UfOsVr0v1nIatG8eD2bxblXKxktLjztYbM42/SG3WLT42usFpd3zWGzWLSsldli6fWLTBYT
	m6axW0w5/IXFYvuU6UwWE6avZbE4vOIAk8X6Ga9ZHIQ81sxbw+ix4PMVdo/Lfb1MHmuXH2Hx
	WLn8C5vHnWt72Dz2z13D7rF5Sb1H35ZVjB5b9n9m9Dh+YzuTx+dNcgE8UVw2Kak5mWWpRfp2
	CVwZG/ZMYCn4LlFxcvtntgbG1cJdjJwcEgImEl+vX2eDsMUkLtxbD2RzcQgJLGWUuHFpGzuE
	08Ak8ff1EqAMBwebgKbEqnseIA0iAmES+zY1MoHUMAtcYJU4sfsrVMN0JonrS2cwgVRxCmhJ
	/G09zQzSLCwQLzH1oAhImEVAVeL1/itgJbwCDhJfzu1igbAFJX5MvgdmMwO1rt95nAnClpfY
	vOYt2BgJAXWJR391IW4wkpj+fw0zRImIxN2G56wTGIVmIZk0C8mkWUgmzULSsoCRZRWjaGpp
	ckFxUnquoV5xYm5xaV66XnJ+7iZGSHR/2cG4+JjVIUYBDkYlHt4DmtOChFgTy4orcw8xSnAw
	K4nw/iqaHiTEm5JYWZValB9fVJqTWnyIkYmDU6qBUeSGkCYr85q0tK3HviSU5ScdsfzpfU/g
	3jcGh9/zQjrFb61f23M16ZLK0h+fnyicTEqKYl5bpuXNIMm6/NZZ+y0f/CfFa08WzNhS8tL8
	neCpngWFO5SMumfszGzOv8Ze+cbUfFm7wMmkzEMOsuvD3v97ldq/KY6Tia3uROO3Nzv+517j
	EuWwVmIpzkg01GIuKk4EAC1tE77MAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matt,

> From: Matt Porter [mailto:matt.porter@linaro.org]
> Sent: Thursday, November 28, 2013 5:42 PM
> 
> On Thu, Nov 28, 2013 at 11:23:52AM +0530, Kishon Vijay Abraham I wrote:
> > On Thursday 28 November 2013 04:06 AM, Matt Porter wrote:
> > > On Wed, Nov 27, 2013 at 12:13:25PM -0500, Matt Porter wrote:
> > >> On Tue, Nov 26, 2013 at 03:53:32PM +0530, Kishon Vijay Abraham I
> wrote:
> > >>> Hi,
> > >>>
> > >>> On Monday 25 November 2013 11:46 PM, Matt Porter wrote:
> > >>>> If a generic phy is present, call phy_init()/phy_exit(). This
> > >>>> supports generic phys that must be soft reset before power on.
> > >>>>
> > >>>> Signed-off-by: Matt Porter <matt.porter@linaro.org>
> > >>>> ---
> > >>>>  drivers/usb/gadget/s3c-hsotg.c | 5 +++++
> > >>>>  1 file changed, 5 insertions(+)
> > >>>>
> > >>>> diff --git a/drivers/usb/gadget/s3c-hsotg.c
> > >>>> b/drivers/usb/gadget/s3c-hsotg.c index da3879b..8dfe33f 100644
> > >>>> --- a/drivers/usb/gadget/s3c-hsotg.c
> > >>>> +++ b/drivers/usb/gadget/s3c-hsotg.c
> > >>>> @@ -3622,6 +3622,9 @@ static int s3c_hsotg_probe(struct
> platform_device *pdev)
> > >>>>  		goto err_supplies;
> > >>>>  	}
> > >>>>
> > >>>> +	if (hsotg->phy)
> > >>>
> > >>> IS_ERR? If your phy_get fails *phy* will have a error value..
> > >>
> > >> Yes, thanks. I'll fix these and also note that the same issue
> > >> exists in Kamil's patch for these same hsotg->phy conditional uses.
> > >> I'll work with Kamil to either get those addressed there or in a
> follow on fix.
> > >
> > > I spoke too soon. If devm_phy_get fails, we don't set hsotg->phy
> and
> > > probe defer thus not reaching this point. Since hsotg->phy is
> either
> > > NULL or a valid struct phy *, this is correct as is throughout the
> driver.
> > >
> > >>>
> > >>>> +		phy_init(hsotg->phy);
> > >>>> +
> > >>>>  	/* usb phy enable */
> > >>>>  	s3c_hsotg_phy_enable(hsotg);
> > >>>>
> > >>>> @@ -3715,6 +3718,8 @@ static int s3c_hsotg_remove(struct
> platform_device *pdev)
> > >>>>  	}
> > >>>>
> > >>>>  	s3c_hsotg_phy_disable(hsotg);
> > >>>> +	if (hsotg->phy)
> > >>>
> > >>> same here.
> > >>
> > >> Ok.
> > >
> > > Same above, this will be NULL on failure (but is only applicable at
> > > this point on the platform data path.
> >
> > Ah ok.. Btw where is phy_get being called? Is it not part of this
> series?
> 
> It's in the Kamil's Exynos USB Phy -> generic phy series [1] which I
> depend on here. I mentioned it in the cover letter toward the end so
> it's a bit buried.
> 
> I have some outstanding, but trivial, comments on that series but I
> hear Kamil will be posting an update in the coming days. I'll wait a
> few days to post v4 addressing your comments so I can hopefully rebase
> against his updated s3c-hsotg patch.
> 

I am sorry to keep you waiting. I was doing some urgent non USB work 
lately and that is the reason for the delay. Thank you for the review of
the last version, by the way. I should post the new version on Wednesday
(or Tuesday afternoon, time permitting). Also, I will have no access to
my Samsung email until Tuesday.

Best wishes,
Kamil Debski



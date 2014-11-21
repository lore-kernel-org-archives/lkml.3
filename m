Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752669AbaKUW1F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 17:27:05 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:38150 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545AbaKUW1B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 17:27:01 -0500
From: "Griffis, Brad" <bgriffis@ti.com>
To: Richard Cochran <richardcochran@gmail.com>,
        Johannes Pointner <johannes.pointner@gmail.com>
CC: "Nori, Sekhar" <nsekhar@ti.com>, "R, Vignesh" <vigneshr@ti.com>,
        "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
        Lee Jones <lee.jones@linaro.org>, "Rob Herring" <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "Kumar Gala" <galak@codeaurora.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        "Tony Lindgren" <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        "Jonathan Cameron" <jic23@kernel.org>,
        Hartmut Knaack <knaack.h@gmx.de>,
        "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Samuel Ortiz <sameo@linux.intel.com>, "Balbi, Felipe" <balbi@ti.com>,
        Sanjeev Sharma <sanjeev_sharma@mentor.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jan Kardell <jan.kardell@telliq.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-iio <linux-iio@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        Robert Nelson <robertcnelson@gmail.com>
Subject: RE: [PATCH v4 3/6] mfd: ti_am335x_tscadc: Remove unwanted
 reg_se_cache save
Thread-Topic: [PATCH v4 3/6] mfd: ti_am335x_tscadc: Remove unwanted
 reg_se_cache save
Thread-Index: AQHP/814MDA7S36n+UqTsn1qrVW9DZxm3USAgAAtbQCAAu23AIAADGwAgAFoWQCAABDgAIAAIacAgAAHToCAACy8AIAAOKmA//+gldA=
Date: Fri, 21 Nov 2014 22:25:50 +0000
Message-ID: <912A29987EAE174BA6CF187D7CDFA9CE26F6D664@DLEE08.ent.ti.com>
References: <1415941651-28962-4-git-send-email-vigneshr@ti.com>
 <20141118143005.GF24004@x1> <20141118171240.GB3003@dtor-ws>
 <546DF2F0.9080405@ti.com> <20141120144028.GB5809@localhost.localdomain>
 <546F2BA4.4000808@ti.com> <20141121131036.GA18931@localhost.localdomain>
 <CAJKbBDDVTA+=priRu7sCD=vHrC8AUg4DM3kycuGrqbpF-5FGAA@mail.gmail.com>
 <546F5C27.7040004@ti.com>
 <CAJKbBDD=eYmU=LuViwLPNV=kYCziDQgKjL07bT7og4vsj0Ee7A@mail.gmail.com>
 <20141121214005.GA4020@localhost.localdomain>
In-Reply-To: <20141121214005.GA4020@localhost.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.170.170.90]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> -----Original Message-----
> From: Richard Cochran [mailto:richardcochran@gmail.com]
> 
> On Fri, Nov 21, 2014 at 07:17:18PM +0100, Johannes Pointner wrote:
> > Before the patches were also jumps but I thought it is something
> > Vignesh should know. Maybe there is some fix for that too?

I believe I've seen the "jumping" behavior pop up at a couple random times in my testing.  I think it relates to the hardware not properly registering a pen-up interrupt.  When that's happening can you try running ts_calibrate?  If you're not registering a pen-up event then you won't be able to advance through those touch points.  Is this behavior related to capturing ADC samples, or do you see this behavior even without capturing ADC samples?

> > As Richard also noted, it would be nice if ti could let us know how to
> > get the delay values right. By trial and error is IMHO not the best
> > way.
> 
> That is not only an opinion, it is a matter of fact. TI really dropped the ball on
> this one. I thought the patch series was a sign they finally were going to
> properly address this issue. Wrong again.

These patches originate from work I did on TI's SDK 7.00 (3.12 kernel).  The touchscreen is working beautifully in that environment and we are putting forth significant effort to bring those improvements to the community. 

Things do not seem to be working as well with the current mainline kernel.  I've been reviewing various patches between 3.12 and the mainline to understand why it's different.  I believe I have figured this out, and I have discussions going separately with individuals that contributed those patches in order to come up with the best possible solution, i.e. we likely need a few additional changes to this patch set.

The CHARGECONFIG delay serves precisely the same purpose as the udelay in the original code base.  How did you determine the udelay value in the first place?  I went through the effort of figuring out a way to make the delay into a HARDWARE delay instead of a software delay so that it could be removed from the ISR.  That delay time relates to "settling time" and so it's going to be dependent on your PCB.  You could hook up an oscilloscope and attempt to capture this parameter from the signals themselves.  Personally I think that's a lot more difficult than just doing a few iterations of testing.

> The data sheet for the TI part used to have a reference to an app-note for
> the touch controller.
> 
>       spruh73f page 1154
> 
>       The Pen IRQ can only occur if the correct Pen Ctrl bits are high
>       (AFE Pen Ctrl bits 6:5 in the TSC_ADC control register) and if
>       the correct ground transistor biasing is set in the StepConfig
>       [N] Register. Refer to the application notes for the correct
>       settings.
> 
> I searched high and low for this application note. Then, the data sheet got
> revised.

Such an application note does not exist, which explains why you didn't find it and why we have removed that reference from the TRM.  Sorry for your trouble.  We always strive for accurate documentation.

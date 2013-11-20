Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752997Ab3KTO6D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 09:58:03 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:38586 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458Ab3KTO6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 09:58:00 -0500
X-AuditID: cbfec7f4-b7fee6d000004b2d-15-528ccdf6ab46
From: Tomasz Figa <t.figa@samsung.com>
To: Doug Anderson <dianders@chromium.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        devicetree@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH] pinctrl: samsung: Allow pin value to be initialized using
 pinfunc.
Date: Wed, 20 Nov 2013 15:57:45 +0100
Message-id: <2071510.uxGIu18IfS@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.11.2 (Linux/3.11.5-gentoo; KDE/4.11.2; x86_64; ; )
In-reply-to: <CAD=FV=XS0dbE7zfgDGVdp84h4fHH6tfO8aN_HNh1LbOjYy51aQ@mail.gmail.com>
References: <1384881351-10782-1-git-send-email-t.figa@samsung.com>
 <528BB1F2.4080107@wwwdotorg.org>
 <CAD=FV=XS0dbE7zfgDGVdp84h4fHH6tfO8aN_HNh1LbOjYy51aQ@mail.gmail.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLLMWRmVeSWpSXmKPExsVy+t/xy7rfzvYEGRz6a2Yx/8g5Vouzyw6y
	Wfx/9JrVonfBVTaLs01v2C2m/FnOZLHp8TVWi8u75rBZzDi/j8li7ZG77BavDraxWBybsYTR
	gcdjdsNFFo871/aweWxeUu/Rt2UVo8f2a/OYPT5vkvPYODc0gD2KyyYlNSezLLVI3y6BK6Oz
	cxdbwQm+imdvX7I1MK7j7mLk5JAQMJG4eXIHM4QtJnHh3nq2LkYuDiGBpYwSK1t3MUE4XUwS
	pyZNYQSpYhNQk/jc8IgNxBYR0JR41vCSGaSIWWApi8SyzTNZQBLCApESr3a0soLYLAKqEtP/
	vmMHsXmBGua2PQcbxC+gLvFu21MmEFtUwE1i+o+DYGdwCgRLvJ96BuqMNYwSt6feZIFoFpT4
	MfkemM0sIC+xb/9UVghbS2L9zuNMExgFZyEpm4WkbBaSsgWMzKsYRVNLkwuKk9JzDfWKE3OL
	S/PS9ZLzczcxQqLoyw7GxcesDjEKcDAq8fBKLOgOEmJNLCuuzD3EKMHBrCTC27W3J0iINyWx
	siq1KD++qDQntfgQIxMHp1QD46Q5s/8t/hY17e2u9sSpiyYoMU6Mv7fS6fX5+qv1EtzB69KO
	3DHuMGq4ps7Yc7neMI2tQ4j9uUDMTvd7rZoimdqtbOVZjc9PBAj0FGVUFbBJPY59d4FFVmHe
	vI1p/w0KFRqjO1dt3zyD89KmeQzPTgf7e9t28xzYbPXOpCrbWebYFImrN+c+U2Ipzkg01GIu
	Kk4EAD2zhAWAAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 of November 2013 10:59:39 Doug Anderson wrote:
> On Tue, Nov 19, 2013 at 10:46 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> > On 11/19/2013 10:15 AM, Tomasz Figa wrote:
> >> This patch extends the range of settings configurable via pinfunc API
> >> to cover pin value as well. This allows configuration of default values
> >> of pins.
> >
> > Shouldn't there be a driver that acquires the GPIO that's output to the
> > pin, and configures the output value? IIRC there have been previous
> > discussions re: having a list of e.g. initial GPIO output values in DT,
> > and that was rejected, and this patch seems to be doing almost the exact
> > same thing, just at the pinctrl level rather than GPIO level.
> >
> > That all said, I admit this could be a useful feature...
> 
> I haven't followed all of the previous discussions, but I know I've
> run into scenarios where something like this would be useful.  The one
> that comes to mind is:
> 
> * We've got GPIOs that default at bootup to a pulled up input since
> the default state of the pin should be "high".
> 
> * These pins are really intended to be outputs, like an "enable",
> "reset", or "power down" line for a peripheral.  The pullup is strong
> enough to give us a good default state but we really want outputs.
> 
> * We'd like to provide this GPIO to a peripheral through device tree.
> ...and we'd like all the pinmux to be setup automatically so we use
> pinctrl-names = "default".
> 
> * If we set the pinmux up as "output" then there's a chance that the
> line will glitch at bootup since the pinmux happens (changing the pin
> to output) before the driver has a chance to run.
> 
> 
> Does that sound like the same scenario you're trying to solve Tomasz?

Yes. That's one of the use cases I had in my mind.

Best regards,
Tomasz


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730AbaJUJb2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 05:31:28 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:53074 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232AbaJUJb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 05:31:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Bjorn Andersson <bjorn@kryo.se>,
        Marc Zyngier <marc.zyngier@arm.com>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Abhijeet Dharmapurikar <adharmap@codeaurora.org>, Y Vo <yvo@apm.com>,
        Tin Huynh <tnhuynh@apm.com>, patches@apm.com, Toan Le <toanle@apm.com>,
        Phong Vo <pvo@apm.com>
Subject: Re: [PATCH] genirq: Introduce irq_read_line()
Date: Tue, 21 Oct 2014 11:30:35 +0200
Message-ID: <1894914.TrPC3AEWES@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <alpine.DEB.2.11.1410211120430.5308@nanos>
References: <1408479811-26088-1-git-send-email-bjorn.andersson@sonymobile.com> <CAJAp7OgGPZZuCgC8iUiW2jrEVubK=KCATxd6eazdT1x1sSrffg@mail.gmail.com> <alpine.DEB.2.11.1410211120430.5308@nanos>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:vZ16q0qNdMK/CU1yHNClBPJD8/ulkgdROwQ2AAyHoBK
 tH0tMy/zVW+YGTioaP6zSTgX+I60ys93FMcC2yVqn5Sv/WjeQ0
 hSk2di8X29horJ07pY5iOZuAYYOGPg0lxQmXp199516rB0xfGe
 ysRX1pcS8kxyQDQL4lixhtrZNx2gAv83/z6NNo9jN2+QYtpL/x
 9xSY+QdV31VuDxv8e4QPaoX7U5gr4Z2SZL6210oY6KUCvNCfTh
 vNNuGvKOEjNrGZBobFJ5vZ9Vg4WMxopV52hQz9LMR4TUG208Jq
 rKkD7v+XnIVsPftsHKUHVG9wfxwmQ0Zq2XxDIUQ8yBOK2u3/nI
 UdNx0dIJS5VgTA2ZOli8=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 21 October 2014 11:22:40 Thomas Gleixner wrote:
> On Thu, 4 Sep 2014, Bjorn Andersson wrote:
> 
> > On Tue, Aug 19, 2014 at 1:23 PM, Bjorn Andersson
> > <bjorn.andersson@sonymobile.com> wrote:
> > > Introduce the irq_read_line() function to allow device drivers to read
> > > the current logical state of an input when the hardware only exposes
> > > this through status bits in the interrupt controller.
> > >
> > > The new function is backed by a new callback function in the irq_chip -
> > > irq_read_line() - that can be implemented by irq_chips that owns such
> > > status bits.
> > >
> > > Based on rfc patch from April 2011 by Abhijeet.
> > >
> > > Cc: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
> > > Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
> > 
> > ping?
> 
> Sorry, slipped through the cracks. I was talking about this to Marc
> last week and he needs it for yet another reason. He had some thoughts
> about the state representation, so I wait for him to comment.

I looked up my older email as well and found which gpio driver had the
requirement to get the irq status from the upstream controller. It was
"gpio: Add APM X-Gene standby GPIO controller driver". I'm adding the
APM developers on Cc here so they can participate in the discussion.

As a brief summary: APM have a GPIO driver that needs to read the status
from the ARM GIC in order to implement gpio_get_value. The KVM hypervisor
needs multiple bits from the GIC in order to implement suspend/resume,
and Qualcomm MSM (as Bjorn wrote above) also needs to expose the status
of the IRQ line like APM does.

These should all use the same interface for the interrupt controller,
but the interface still needs to be added.

	Arnd

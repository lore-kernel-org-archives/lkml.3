Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972Ab3KTNjQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 08:39:16 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:34059 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967Ab3KTNjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 08:39:12 -0500
X-AuditID: cbfec7f4-b7fee6d000004b2d-dc-528cbb7e5ae4
From: Tomasz Figa <t.figa@samsung.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Doug Anderson <dianders@chromium.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH] pinctrl: samsung: Allow pin value to be initialized using
 pinfunc.
Date: Wed, 20 Nov 2013 14:38:57 +0100
Message-id: <1751377.1AvsyJs1NG@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.11.2 (Linux/3.11.5-gentoo; KDE/4.11.2; x86_64; ; )
In-reply-to: <528BB1F2.4080107@wwwdotorg.org>
References: <1384881351-10782-1-git-send-email-t.figa@samsung.com>
 <528BB1F2.4080107@wwwdotorg.org>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDLMWRmVeSWpSXmKPExsVy+t/xa7p1u3uCDLa2SFvMP3KO1eLssoNs
	Fv8fvWa16F1wlc3ibNMbdospf5YzWWx6fI3V4vKuOWwWM87vY7JYe+Quu8Wrg20sFsdmLGF0
	4PGY3XCRxePOtT1sHpuX1Hv0bVnF6LH92jxmj8+b5Dw2zg0NYI/isklJzcksSy3St0vgypiy
	+A5zwTeBil9XVrI1MC7j7WLk5JAQMJFovLSZCcIWk7hwbz1bFyMXh5DAUkaJn8c/M0I4XUwS
	iz5eBqtiE1CT+NzwiA3EFhHQkpj07B9YEbPAIWaJ1heXwRLCApESr3a0soLYLAKqEpM2zmUG
	sXkFNCX+nTnCCGLzC6hLvNv2FGyoqICbxPQfB8FqOAV0Je5eOw02R0ggVWLB3f0sEL2CEj8m
	3wOzmQXkJfbtn8oKYWtJrN95nGkCo+AsJGWzkJTNQlK2gJF5FaNoamlyQXFSeq6hXnFibnFp
	Xrpecn7uJkZIDH3Zwbj4mNUhRgEORiUeXokF3UFCrIllxZW5hxglOJiVRHi5l/UECfGmJFZW
	pRblxxeV5qQWH2Jk4uCUamBcw8b5YbXRqW2aHDNm806u37N3X3foe+2C3naD43vyM15o8SmE
	7hf2ceryu3D+xoS3AjsOhrWZnZ5T6XBeaJH1te0WE3wkDszefejClumfpV8omx5hPio8P9xs
	X8ju2MbbRZelvMr4/xe/yNCxynqhZuGZeah8Fuuj6w9erRR/cr6EN7Pqapm+EktxRqKhFnNR
	cSIAHeMqMn8CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Tuesday 19 of November 2013 11:46:10 Stephen Warren wrote:
> On 11/19/2013 10:15 AM, Tomasz Figa wrote:
> > This patch extends the range of settings configurable via pinfunc API
> > to cover pin value as well. This allows configuration of default values
> > of pins.
> 
> Shouldn't there be a driver that acquires the GPIO that's output to the
> pin, and configures the output value? IIRC there have been previous
> discussions re: having a list of e.g. initial GPIO output values in DT,
> and that was rejected, and this patch seems to be doing almost the exact
> same thing, just at the pinctrl level rather than GPIO level.

Well, on the contrary, I remember a discussion about specifying initial
clock tree configuration in DT (on Linaro Connect in Dublin, but AFAIR
also on the ML before. Through analogy, I would extend this to initial
pin settins. However maybe the use cases behind this will make things
clearer.

> 
> That all said, I admit this could be a useful feature...

Two specific things I had in mind with this have been:

 - pins of the SoC unused on particular boards, which often need different
   configuration depending on pin bank, SoC revision and so on. I know
   that _ideally_ this should be done by "firmware", but I believe we
   have enough historic experience to know that we shouldn't expect from
   the bootloader more than that it just loads us, as the name would
   suggest (and I have even had experience with bootloaders that couldn't
   properly do this basic task, screwing up, for example, by leaving MMU
   turned on before jumping to the kernel).

 - initializing safe default state of all pins on the board, to cope with
   configurations when not all drivers are enabled. As an example, take an
   embedded board with a little of flash storage, where the kernel has to
   be really small, so not all SoC drivers can be compiled into it. Moving
   the responsibility of setting initial pin states to drivers would leave
   pins of inexistent drivers unconfigured.

I don't think I need to explain why misconfigured pins are a bad thing.

Best regards,
Tomasz


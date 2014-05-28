Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752350AbaE1RGl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 13:06:41 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:44786 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503AbaE1RGj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 13:06:39 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Subject: Re: [PATCH 0/3] Qualcomm Resource Power Manager driver
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <CAJAp7Ojb7PvuNYJkPyKx+iehi0bF6rdYvYmfrDz21mebxMN1qg@mail.gmail.com>
Date: Wed, 28 May 2014 12:06:32 -0500
Cc: Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Josh Cartwright <joshc@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <8CA95B37-E5EE-46BE-ABFD-64AA3BBF4E96@codeaurora.org>
References: <1401211721-19712-1-git-send-email-bjorn.andersson@sonymobile.com> <F773CDFB-2957-49C0-99D3-E9CDCE33C378@codeaurora.org> <CAJAp7Ojb7PvuNYJkPyKx+iehi0bF6rdYvYmfrDz21mebxMN1qg@mail.gmail.com>
To: Bjorn Andersson <bjorn@kryo.se>
X-Mailer: Apple Mail (2.1874)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On May 28, 2014, at 11:59 AM, Bjorn Andersson <bjorn@kryo.se> wrote:

> On Wed, May 28, 2014 at 9:23 AM, Kumar Gala <galak@codeaurora.org> wrote:
>> 
>> On May 27, 2014, at 12:28 PM, Bjorn Andersson <bjorn.andersson@sonymobile.com> wrote:
>> 
>>> This series adds a regulator driver for the Resource Power Manager found in
>>> Qualcomm 8660, 8960 and 8064 based devices.
>>> 
>>> The RPM driver exposes resources to its child devices, that can be accessed to
>>> implement drivers for the regulators, clocks and bus frequency control that's
>>> owned by the RPM in these devices.
>> 
>> Rather than adding yet another mfd driver, how about we put this in drivers/soc/qcom as a much better location for the low level rpm code.  Some code already merged in arm-soc for creation of drivers/soc/qcom/
> 
> Hi Kumar,
> 
> I do see rpm as somewhat equivalent to a pmic and that was why I
> followed suite and put it in mfd, but I can of course move it if you
> prefer.
> 
> 
> Lately I've been working on rpm, rpm-smd, smem, smd, smsm, smp2p
> patches for mainline.
> It could be argued that smd is a bus and should go in drivers/bus, but
> for the rest I fear that we just created drivers/soc/qcom as another
> dumping ground for things; a "Qualcomm specific drivers/mfd".
> 
> But maybe that is the purpose of it ;)

It is the purpose so that as we see common patterns between either drivers/soc/<VENDOR> we can refactor in the future.  However, we need to all a little time for those patterns to emerge rather than shoe horning in drivers into places that don’t make sense.

> 
> If I move the rpm driver, are there any conclusion to where I should
> move the dt binding documentation?

devicetree/bindings/soc/qcom
include/dt-bindings/soc

> 
> Regards,
> Bjorn

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation


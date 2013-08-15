Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752427Ab3HOV2m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 17:28:42 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:51297 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302Ab3HOV2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 17:28:39 -0400
Message-ID: <520D4805.8070007@codeaurora.org>
Date: Thu, 15 Aug 2013 14:28:37 -0700
From: Hanumant Singh <hanumant@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Bjorn Andersson <bjorn@kryo.se>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] pinctrl: msm: Add support for MSM TLMM pinmux
References: <1374702089-2832-1-git-send-email-hanumant@codeaurora.org> <CAJAp7OjbJwaH8SFdSwDU4VLwTAY1PfDWy1S+yF05=oPuUApvNA@mail.gmail.com> <CACRpkdbNpVUV9B1p1Cp5q2vJtQ78zhqsDBss2k28=cxF9Mn7pg@mail.gmail.com> <520D1363.3090708@codeaurora.org> <CACRpkdYVQ-Yk_b0cW0-sB6eGkpkgfFsnd3NXQmCYCuiLmm5qww@mail.gmail.com>
In-Reply-To: <CACRpkdYVQ-Yk_b0cW0-sB6eGkpkgfFsnd3NXQmCYCuiLmm5qww@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/15/2013 1:47 PM, Linus Walleij wrote:
> On Thu, Aug 15, 2013 at 7:44 PM, Hanumant Singh <hanumant@codeaurora.org> wrote:
>
>> Ok i can switch to using pin groups defined in per soc files.
>> But in our case we have one soc going into different types of boards.
>> (atleast 3). In each of the boards the same external devices end up using
>> different pins. For ex camera on board 1 uses different pin group
>> then the same camera on board 2. Both having the same SOC.
>> So in this case the design would be to have all possible pin groups
>> for different boards enumerated in the same soc-pinctrl.c file?
>
> Sorry I don't get this at all.
>
> What pin groups and functions that exist on a SoC is what you put into
> a SoC driver. Because this is a hardware characteristic.
>
> How these are combined on a board into different states is what you put
> into the device tree. (Or platform data.)
>

For example lets say for a given SOC A it goes into boards 1, 2, and 3.
Each of the boards has a display panel. The display panel uses two pins
1) a reset pin 2) an interrupt pin.

In the combination of SOC A + board 1
  - Display panel reset = pin no 5.
  - Display panel interrupt = pin no 9.

In combination of SOC A + board 2
  - Display panel reset = pin no 4.
  - Display panel interrupt = pin no 9.

In combination of SOC A + board 3
  - Display panel reset = pin no 7.
  - Display panel interrupt = pin no 2.

The pin groupings to be used by the display panel can be {5,9}, {4,9}, 
or {7,2}
These different pin groups and their function setting will be present in 
soc-pinctrl.c. The function setting is the same on all 3 cases.

The DT entry will correspond to the different states of these pins for 
the different boards.

Is this understanding correct?


>> Also in this implementation I will have.
>> 1) pinctrl-msm.c => DT parsing and interface to framework.
>> 2) pinctrl-msm-tlmm<version>.c => Register programming and pin types
>> supported by a particular TLMM pinmux version.
>> 3) pinctrl-<soc>.c => All the pins/pin groups supported by a given SOC.
>
> Seems OK.
>
>> As I
>> mentioned we will have a bloat of these, since we have entire families of
>> SOC using a given TLMM version but with unique pin groupings.
>
> Bring 'em on. But is that really different groups you are talking about,
> and not just combinations of groups with functions for a certain board
> as I describe above?
>
> If you have many SoC subdrivers, consider creating a subdir as some
> drivers already have.

Actually the SOC files, as I see it, will only contain the different pin 
groupings and the function setting for a given soc. The real driver 
implementation will be in 1) and 2) (the device being the TLMM pinmux 
version 3). I will currently refrain from creating a special msm 
directory. Maybe that can be a step 2) once we start adding more SOC's?
I will be starting the patch with msm8974 SOC only.

Thanks
Hanumant


-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
-- 

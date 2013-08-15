Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578Ab3HOXOI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 19:14:08 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:57063 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377Ab3HOXOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 19:14:06 -0400
Message-ID: <520D60BC.5000001@codeaurora.org>
Date: Thu, 15 Aug 2013 16:14:04 -0700
From: Hanumant Singh <hanumant@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Josh Cartwright <joshc@codeaurora.org>
CC: Linus Walleij <linus.walleij@linaro.org>, Bjorn Andersson <bjorn@kryo.se>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] pinctrl: msm: Add support for MSM TLMM pinmux
References: <1374702089-2832-1-git-send-email-hanumant@codeaurora.org> <CAJAp7OjbJwaH8SFdSwDU4VLwTAY1PfDWy1S+yF05=oPuUApvNA@mail.gmail.com> <CACRpkdbNpVUV9B1p1Cp5q2vJtQ78zhqsDBss2k28=cxF9Mn7pg@mail.gmail.com> <520D1363.3090708@codeaurora.org> <20130815215004.GC4035@joshc.qualcomm.com> <520D4F07.8000609@codeaurora.org> <20130815231014.GE4035@joshc.qualcomm.com>
In-Reply-To: <20130815231014.GE4035@joshc.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/15/2013 4:10 PM, Josh Cartwright wrote:
> On Thu, Aug 15, 2013 at 02:58:31PM -0700, Hanumant Singh wrote:
>> On 8/15/2013 2:50 PM, Josh Cartwright wrote:
>>> On Thu, Aug 15, 2013 at 10:44:03AM -0700, Hanumant Singh wrote:
>>>> On 8/14/2013 12:29 PM, Linus Walleij wrote:
>>>>> On Tue, Jul 30, 2013 at 1:39 AM, Bjorn Andersson <bjorn@kryo.se> wrote:
>>>>>> On Wed, Jul 24, 2013 at 1:41 PM, Hanumant Singh <hanumant@codeaurora.org> wrote:
> [..]
>>>>
>>>> Ok i can switch to using pin groups defined in per soc files.
>>>> But in our case we have one soc going into different types of boards.
>>>> (atleast 3). In each of the boards the same external devices end up using
>>>> different pins. For ex camera on board 1 uses different pin group
>>>> then the same camera on board 2. Both having the same SOC.
>>>> So in this case the design would be to have all possible pin groups
>>>> for different boards enumerated in the same soc-pinctrl.c file?
>>>>
>>>> Also in this implementation I will have.
>>>> 1) pinctrl-msm.c => DT parsing and interface to framework.
>>>> 2) pinctrl-msm-tlmm<version>.c => Register programming and pin types
>>>> supported by a particular TLMM pinmux version.
>>>
>>> It isn't clear to me what you are trying to separate out between 1) and
>>> 2).  Seems like there should only be pinctrl-msm-tlmm<version>.c.
>>>
>> The idea is that we should be able to plug in the next TLMM version 4, with
>> the pintypes that it supports and its register programming semantics without
>> any changes to the DT parsing or interface to the framework. The DT
>> information describes the states of the pingroups.
>> How we handle them with respect to the pinctrl framework, does not change
>> with different versions of the TLMM.
>
> Okay, although I think that might be a bit too much indirection too
> soon.
>
> I'd rather the strategy be to have a straightforward driver supporting
> TLMMv3 only (with MSM8974 support), and only worry about introducing a
> generic TLMM parsing layer when we actually have a need for it.
>
> If nothing else, I'd at least suggest that you rename pinctrl-msm.c to
> pinctrl-msm-tlmm.c, if it's going to be housing the TLMM-generic DT
> parsing code.
>

Actually we already have a request from Bjorn to support TLMMv2 which 
has different pin types and register semantics.

Thanks
Hanumant

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
-- 

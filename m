Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623Ab3ILSEz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 14:04:55 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:35599 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756562Ab3ILSEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 14:04:47 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:f1aa]
In-Reply-To: <3E38F48E-EE41-4564-84A1-36CF07B08811@codeaurora.org>
References: <1379003839-16068-1-git-send-email-galak@codeaurora.org>
	<CAOesGMisWLwYKotGDFPW6PyHJs=_+fohTdC08SGjsv2FXaa7Fg@mail.gmail.com>
	<25E0B143-658E-4CCC-A88A-0AF70FFF33CE@codeaurora.org>
	<CAOesGMhfdvyJ_2AA2e8iO_2e=q7KgpyNbcriPKFw-RLormG6bA@mail.gmail.com>
	<3E38F48E-EE41-4564-84A1-36CF07B08811@codeaurora.org>
Date: Thu, 12 Sep 2013 11:04:46 -0700
Message-ID: <CAOesGMhN0jEx065cpf989P-JbuxPiOaPRsP4BD3VoW-n5ebP+w@mail.gmail.com>
Subject: Re: [PATCH] ARM: msm: Move msm devicetrees under a Qualcomm dir
From: Olof Johansson <olof@lixom.net>
To: Kumar Gala <galak@codeaurora.org>
Cc: David Brown <davidb@codeaurora.org>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org list" <linux-kernel@vger.kernel.org>,
        Rohit Vaswani <rvaswani@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 10:55 AM, Kumar Gala <galak@codeaurora.org> wrote:
>
> On Sep 12, 2013, at 12:06 PM, Olof Johansson wrote:
>
>> On Thu, Sep 12, 2013 at 9:53 AM, Kumar Gala <galak@codeaurora.org> wrote:
>>>
>>> On Sep 12, 2013, at 11:46 AM, Olof Johansson wrote:
>>>
>>>> On Thu, Sep 12, 2013 at 9:37 AM, Kumar Gala <galak@codeaurora.org> wrote:
>>>>> Use the Qualcomm vendor prefix (qcom) as the directory name for
>>>>> Qualcomm MSM devicetrees going forward.
>>>>>
>>>>> Signed-off-by: Kumar Gala <galak@codeaurora.org>
>>>>
>>>> Let's not move just one platform like this. If we are to do this, we
>>>> should move everything, and that will be really painful and needs to
>>>> be done in a controlled manner, probably scripted and right before a
>>>> -rc1 or such.
>>>
>>>
>>> Than I suggest we deal with it when we pull the device trees out of the kernel tree.
>>>
>>> As such, I'd tell Rohit to go forward with the file being named apq8074-dragonboard.dtb for the time being.
>>
>> My original request to please use a common prefix for your product
>> families stands. Please prefix with msm-*, or if you have to, qcom-*
>> instead, since you guys can't seem to make your mind up on standard
>> prefixes (msm, apq, etc).
>
> This is silly, I dont see the reason to go with qcom-apq<SOC>-<BOARD>.dts and than in the future drop qcom- when we mostly likely shift to a dir structure.
>
> As engineers we are all too aware of the lack of sanity in marketing names, but its what we have so we have to live with it.

And we all have a choice whether we let the marketing people's
insanity spread into our engineering projects, or if we keep it as
sane as possible in spite of them.

I wouldn't have an objection here if there was some sort of rationale
between what "apq" and "msm" means. But it seems like qualcomm rolls a
dice and decides if a platform will have one name or the other.
Dragonboard dmesg says msm<foo>. DTS file for the same board says apq.
DTSI file says one thing, overridden by the dts to something else.
Total chaos.

I would be fine with adding two instead of one (after all, platforms
like TI has this for AM* vs OMAP*, etc), but there _has_ to be some
sort of consistency or you might just as well assign a random string
as name.

So, if you can't come up with a reasonable, rational and consistent
naming scheme (which, apparantly, you can't since your marketing guys
are in control of this and they don't get it right), then at least
prefix with a common string for the platform. That's all I'm asking.


-Olof

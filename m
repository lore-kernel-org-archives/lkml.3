Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567AbaFRQo0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 12:44:26 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:59811 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753494AbaFRQoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 12:44:24 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Kumar Gala <galak@codeaurora.org>
Cc: Bjorn Andersson <bjorn@kryo.se>, Lee Jones <lee.jones@linaro.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Josh Cartwright <joshc@codeaurora.org>,
        "devicetree\@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Paul Walmsley <paul@pwsan.com>, jaswinder.singh@linaro.org
Subject: Re: [PATCH v3 0/3] Qualcomm Resource Power Manager driver
References: <1402944372-31901-1-git-send-email-bjorn.andersson@sonymobile.com>
	<7hvbrzbh1u.fsf@paris.lan>
	<CAJAp7OhHr4Cgcp9pvQ3=MAie_zSnFJxG28Vf37qJ98BK7P1jaQ@mail.gmail.com>
	<7hzjha8b97.fsf@paris.lan>
	<842A7147-A2CC-42BD-9947-CBADF738DC92@codeaurora.org>
Date: Wed, 18 Jun 2014 09:44:21 -0700
In-Reply-To: <842A7147-A2CC-42BD-9947-CBADF738DC92@codeaurora.org> (Kumar
	Gala's message of "Wed, 18 Jun 2014 11:03:44 -0500")
Message-ID: <7hegym6uca.fsf@paris.lan>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kumar Gala <galak@codeaurora.org> writes:

> On Jun 18, 2014, at 10:53 AM, Kevin Hilman <khilman@linaro.org> wrote:
>
>> Bjorn Andersson <bjorn@kryo.se> writes:
>> 
>>> On Tue, Jun 17, 2014 at 10:07 AM, Kevin Hilman <khilman@linaro.org> wrote:
>>>> +Paul Walmsley
>>>> 
>>>> Bjorn Andersson <bjorn.andersson@sonymobile.com> writes:
>>>> 
>>>>> This series adds a regulator driver for the Resource Power Manager found in
>>>>> Qualcomm 8660, 8960 and 8064 based devices.
>>>>> 
>>>>> The RPM driver exposes resources to its child devices, that can be accessed to
>>>>> implement drivers for the regulators, clocks and bus frequency control that's
>>>>> owned by the RPM in these devices.
>>>>> 
>>>>> Changes since v2:
>>>>>  - Fix copy-paste error in dt binding
>>>>>  - Correct incomplete move from mfd to soc
>>>>>  - Correct const mistake in regulator driver
>>>>> 
>>>>> Changes since v1:
>>>>>  - Moved rpm driver to drivers/soc
>>>> 
>>>> I'm not sure I follow the motivation for having this under drivers/soc?
>>>> 
>>> Hi Kevin,
>>> 
>>> I've made the argument that to me this is conceptually a black box
>>> handling regulators, clocks and other stuff; hence similar to a PMIC,
>>> which would fit nicely into drivers/mfd.
>>> 
>>> I still think this is the case and now that I look back I didn't get
>>> any pushback from Lee Jones so maybe the move was premature?
>> 
>> Yes, IMO, the move was premature, but hopefully the drivers/soc folks
>> can chime in an clarify the criteria for inclusion there.
>> 
>> Kevin
>
> I dont agree, I think having this in drivers/soc means that we can
> clearly go through drivers/soc in the future and look for patterns
> across SoCs that should be re-factored.  

I don't believe that was the goal in creating drivers/soc.

> Where MFD seems like its become the new drivers misc.

Well, I don't think that drivers/soc wants to be the new drivers/misc
either. ;)

Thinking more about what this RPM driver actually does, and since you
mentioned patterns across SoCs, it seems to me the RPM driver bascially
just doing the IPC.

So, rather than MFD or drivers/soc, it seems to me that it should be
implmented as a controller in the new common mailbox framwork[1] being
worked on by Jassi Brar (added to Cc.)

IIUC, RPM is actually only doing one-way IPC (it only exposes a write()
interface to clients) so it seems like a rather simple implementation of
a mailbox controller.

I believe Bjorn is already on the list of folks Cc'd on the common
mailbox framework, so it would be good to hear from him why RPM wouldn't
fit under that framework.

Thanks,

Kevin

[1] https://lkml.org/lkml/2014/6/12/470

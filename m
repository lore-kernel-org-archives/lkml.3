Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316AbaLVKEp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 05:04:45 -0500
Received: from mail-qc0-f169.google.com ([209.85.216.169]:39502 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754241AbaLVKEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 05:04:43 -0500
MIME-Version: 1.0
In-Reply-To: <CAJAp7OhSZ7CZedXAsWPf0XYv8RESQxXe4L1LZjOmVW4nGpFiHw@mail.gmail.com>
References: <1418412516-10682-1-git-send-email-bjorn.andersson@sonymobile.com>
	<CAPDyKFrPC_MphsLHHZ=uFjcF8SsdkVmzez9R=gas7_ihn63Q5A@mail.gmail.com>
	<CAJAp7OhSZ7CZedXAsWPf0XYv8RESQxXe4L1LZjOmVW4nGpFiHw@mail.gmail.com>
Date: Mon, 22 Dec 2014 11:04:42 +0100
Message-ID: <CAPDyKFoGN49usQg5Ezv_AaWcKf3mRmZ=VJ8Rc4HDYh62ukiwXQ@mail.gmail.com>
Subject: Re: [PATCH] mmc: dt: Add property for broken hs200 quirk
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Bjorn Andersson <bjorn@kryo.se>
Cc: Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Anton Vorontsov <anton@enomsg.org>, Chris Ball <chris@printf.net>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:SECURE DIGITAL HO..." <linux-mmc@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 December 2014 at 21:01, Bjorn Andersson <bjorn@kryo.se> wrote:
> On Fri, Dec 19, 2014 at 3:38 AM, Ulf Hansson <ulf.hansson@linaro.org> wrote:
>> On 12 December 2014 at 20:28, Bjorn Andersson
>> <bjorn.andersson@sonymobile.com> wrote:
>>
>> Some more explanation to why this needed would be good.
>>
>
> Because (according to the git log) some of the memories that we
> mounted in Xperia Z1 does not support HS200 even though they advertise
> they are.

I see. How about using an mmc card quirk instead of a DT binding then?

Kind regards
Uffe

>
> I thought we needed for the device I'm testing with, but a couple of
> regulator_set_optimum_mode() solved that - so I have to provide a
> patch for that as well...
>
>>> Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
>>> ---
>>>  Documentation/devicetree/bindings/mmc/mmc.txt | 2 ++
>>
>> This file lists the generic mmc DT bindings, but you want to add a
>> specific binding for sdhci?
>>
>
> Looking in sdhci_get_of_property() it's a mash of device specific
> properties, sdhci specific properties documented in mmc.txt and
> generic sdhci properties documented in device specific bindings.
>
> Would you like me to move it to a generic sdhci.txt binding and update
> the individual sdhci-* to reference that instead of mmc.txt? Or should
> I just add the property in the device specific bindings? Or maybe we
> could keep it as a optional property in mmc.txt?
>
> Regards,
> Bjorn

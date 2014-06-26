Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757715AbaFZQyE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 12:54:04 -0400
Received: from mail-qa0-f47.google.com ([209.85.216.47]:48231 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756110AbaFZQyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 12:54:01 -0400
MIME-Version: 1.0
In-Reply-To: <CAD=FV=W=e-5LJRacxA-sSUUn8cBB5oCHJkwz=Py7iU2fdERVRA@mail.gmail.com>
References: <1403785148-20792-1-git-send-email-ch.naveen@samsung.com>
 <1403785148-20792-3-git-send-email-ch.naveen@samsung.com> <CAD=FV=W=e-5LJRacxA-sSUUn8cBB5oCHJkwz=Py7iU2fdERVRA@mail.gmail.com>
From: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
Date: Thu, 26 Jun 2014 22:23:40 +0530
Message-ID: <CAHfPSqBYbUsmmwRv5E1xvLs1eW+wnqtLn7-nx-q4Fvt29k3mEA@mail.gmail.com>
Subject: Re: [PATCH 2/3] ARM: DTS: Add NTC thermistor nodes to Exynos5250
 based Snow
To: Doug Anderson <dianders@chromium.org>, Kukjin Kim <kgene.kim@samsung.com>
Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-iio <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "cpgs ." <cpgs@samsung.com>, Tushar Behera <tushar.b@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Doug and Kukjin,

On 26 June 2014 21:16, Doug Anderson <dianders@chromium.org> wrote:
> Naveen,
>
> On Thu, Jun 26, 2014 at 5:19 AM, Naveen Krishna Chatradhi
> <ch.naveen@samsung.com> wrote:
>> Exynos5250 based Snow board has 4 NTC thermistors to measure
>> temperatures at various points on the board.
>>
>> IIO based ADC becomes the parent and NTC thermistors are the childs,
>> via the HWMON interface.
>>
>> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
>> ---
>> Posted earlier by Doug Anderson @ https://lkml.org/lkml/2013/3/27/453
>>
>> This patch depends on (1/4 and 2/4 patches of) patchset posted
>> http://www.spinics.net/lists/linux-iio/msg13486.html
>> Which were applied on to Guenter Roeck's tree.
>>
>> cat sysfs entries exported by hwmon for 4 thermistors
>> and verified the values on Snow.
>>
>>  arch/arm/boot/dts/exynos5250-snow.dts |   34 +++++++++++++++++++++++++++++++++
>>  1 file changed, 34 insertions(+)
>
> NAK.
>
> The first chunk of exynos5250-snow devices have the thermistors
> populated, but a huge chunk of devices also _don't_ have them
> populated.

I've realized only the rev4 and before boards have thermistors
while going through the git logs of snow related dts files
in an older chrome kernel.


>
> If I remember my history properly, rev3 and earlier all had
> thermistors.  Some of rev4 might have thermistors (I never got a clear
> answer).  ...and rev5 definitely doesn't have resistors.  Aside from
> thermistors there's no good reason to differentiate rev3 and rev4
> (they just have different memory).  The upstream kernel may eventually
> need to differentiate rev4 and rev5 since they have a different audio
> codec.

I've found one patch which says, "No thermistors on Rev5 and above boards"
I still thought, we should support few boards out there.

But, i din't knew they were removed completely.

>
> See <https://chromium-review.googlesource.com/#/c/170841/> for some
> descriptions of the different revisions of snow and how they were
> handled in the Chrome OS tree.

Got it now, Thanks

>
> See <https://chromium-review.googlesource.com/#/c/186357/> for
> thermistors talk.  Patch set #1 actually split out rev3, but we then
> decided that we really didn't need to use the thermistors on any of
> the revisions so the later patchsets just totally take them out.

So, no need of thermistor nodes on Snow.
I thought https://lkml.org/lkml/2013/3/27/453 patch is missed out.

>
> -Doug

Kukjin, Sorry for the confusion. Please drop this one.

-- 
Thanks,
(: Nav :)

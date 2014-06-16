Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932760AbaFPSfZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 14:35:25 -0400
Received: from mail-ve0-f173.google.com ([209.85.128.173]:36078 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbaFPSfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 14:35:22 -0400
MIME-Version: 1.0
In-Reply-To: <5398758F.4080306@samsung.com>
References: <1402090985-8061-1-git-send-email-dianders@chromium.org>
	<20140607181221.GB25068@e102568-lin.cambridge.arm.com>
	<CAD=FV=X17PeJ6JPE9Qyc1QT07AvA2PTE69Q87gz9a6MdUHgi4A@mail.gmail.com>
	<20140609223831.GB16889@e102568-lin.cambridge.arm.com>
	<CANuQgHHxAhTNYX-JAEdRkO=PMYT4A5GwXcuQfiqwE0CEkQyR+w@mail.gmail.com>
	<CAD=FV=V5_RRNkgA7Rk7XbQw9m1qh6-RJA8arW7ZRU=QbWAPa+w@mail.gmail.com>
	<alpine.LFD.2.11.1406101146140.25775@knanqh.ubzr>
	<CADWw7OjqK3MAuqCHuv-WS3Bb2+2Q-FXth+7hqtwFoyAP6pyYhA@mail.gmail.com>
	<CAD=FV=ULFx0GPp_mnEfouZF+m4h_RYE6WQu48N0WbFWrFv8-BA@mail.gmail.com>
	<5398758F.4080306@samsung.com>
Date: Mon, 16 Jun 2014 11:35:21 -0700
X-Google-Sender-Auth: 97BVIgnW4puTnSRrQv6tTc3ILNc
Message-ID: <CAD=FV=U49dNrsNRe7d0PAyq_g_fUiaZYoqTAFoj+gJ=3K5c_2A@mail.gmail.com>
Subject: Re: [PATCH] ARM: EXYNOS: mcpm: Don't rely on firmware's secondary_cpu_start
From: Doug Anderson <dianders@chromium.org>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Chander Kashyap <k.chander@samsung.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Kevin Hilman <khilman@linaro.org>,
        Andrew Bresticker <abrestic@chromium.org>,
        Inderpal Singh <inderpal.s@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chander Kashyap <chander.kashyap@linaro.org>,
        "olof@lixom.net" <olof@lixom.net>, Tushar Behera <trblinux@gmail.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Thomas Abraham <thomas.ab@samsung.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kukjin,

On Wed, Jun 11, 2014 at 8:28 AM, Kukjin Kim <kgene.kim@samsung.com> wrote:
> On 06/12/14 00:19, Doug Anderson wrote:
>>
>> Chander,
>>
>> On Tue, Jun 10, 2014 at 9:52 PM, Chander Kashyap<k.chander@samsung.com>
>> wrote:
>>>
>>> Hi Doug,
>>>
>>> On Tue, Jun 10, 2014 at 9:19 PM, Nicolas Pitre<nicolas.pitre@linaro.org>
>>> wrote:
>>>>
>>>> On Tue, 10 Jun 2014, Doug Anderson wrote:
>>>>
>>>>> My S-state knowledge is not strong, but I believe that Lorenzo's
>>>>> questions matter if we're using S2 for CPUidle (where we actually turn
>>>>> off power and hot unplug CPUs) but not when we're using S1 for CPUidle
>>>>> (where we just enter WFI/WFE).
>>>>>
>>>
>>> No Its not plain WFI.
>>>
>>> All cores in Exynos5420 can be powered off independently.
>>> This functionality has been tested.
>>>
>>> Below is the link for the posted patches.
>>>
>>> https://lkml.org/lkml/2014/6/10/194
>>>
>>> And as Nicolas wrote, these patches need MCPM for that.
>>
>>
>> Most excellent!  I should have been more clear that I only knew about
>> how CPUidle worked in our local production kernel.  There I'm pretty
>> sure CPUidle is just WFI/WFE.  If you've got patches to do better then
>> that's great!
>>
>> ...can you confirm that my patch doesn't interfere with your improved
>> CPUidle?  It's been Acked by Nicolas (thanks!) so I'd imagine it will
>> land shortly.  Kukjin: I assume you'll be taking this?
>>
> Sure, I will ;-)

I see that you put some branches up about 3 hours ago and I don't see
this patch.  Are you planning on applying it?  It would be nice if it
was in 3.16 (since it causes problems booting), but if there's some
reason it needs to be for-next that's OK too.

-Doug

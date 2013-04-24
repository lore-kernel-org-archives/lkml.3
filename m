Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756954Ab3DXQeE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 12:34:04 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:43974 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756435Ab3DXQeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 12:34:01 -0400
Message-ID: <51780976.8020608@linaro.org>
Date: Wed, 24 Apr 2013 09:33:58 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Kay Sievers <kay@vrfy.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: CONFIG_RTC_HCTOSYS lost on x86 with ALWAYS_USE_PERSISTENT_CLOCK
 changes?
References: <CAPXgP13kizK95JyLxKxgWrGnV9b11ZTyi3vuc5YFDmROzckg4w@mail.gmail.com> <517746E4.908@linaro.org> <CAPXgP128yAq1jju-gsZcaS-mZPt+7tq0tt-uVk3Yqr77abd26Q@mail.gmail.com> <51774F44.2060704@linaro.org> <CAPXgP12D-H_E3WbWYgrbtvA_6wq=DhpiaLU_hGRgD6ga=_1x-A@mail.gmail.com> <CAPXgP10R0HSqOmq6LEW-Wqki1c7TyiemGwtUBEOopgZjWBNoOA@mail.gmail.com>
In-Reply-To: <CAPXgP10R0HSqOmq6LEW-Wqki1c7TyiemGwtUBEOopgZjWBNoOA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2013 08:51 PM, Kay Sievers wrote:
> On Wed, Apr 24, 2013 at 5:33 AM, Kay Sievers <kay@vrfy.org> wrote:
>
>> Also:
>>    $ cat /sys/class/rtc/rtc0/hctosys
>>    0
>> always carried "1", and this now breaks setups which expect an
>> automatically created symlink /dev/rtc to the actual "system rtc".
> We used to do this in upstream standard udev rules:
>    SUBSYSTEM=="rtc", ATTR{hctosys}=="1", MODE="0644"
>    http://cgit.freedesktop.org/systemd/systemd/tree/rules/50-udev-default.rules#n18
>
> If that information is expected to be gone now, we need to update some
> tools. Whats' the proper way now to find the "system rtc" to use?

No we'll revert. Can't break userland.

But as to your question, if there's only one rtc, I'd consider it the 
"system rtc", only adjusting the link if a second RTC appears and has 
the hctosys flag set.

thanks
-john




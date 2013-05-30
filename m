Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967893Ab3E3IS7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 04:18:59 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:20759 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967813Ab3E3ISy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 04:18:54 -0400
Message-ID: <51A70B6A.8060306@atmel.com>
Date: Thu, 30 May 2013 10:18:50 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: <dgilbert@interlog.com>
CC: Robert Nelson <robertcnelson@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johan Hovold <jhovold@gmail.com>,
        Robert Nelson <Robert.Nelson@digikey.com>,
        <linux-kernel@vger.kernel.org>,
        "Ludovic Desroches" <ludovic.desroches@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 0/5] rtc-at91rm9200: add shadow interrupt mask
References: <1364983415-20298-1-git-send-email-jhovold@gmail.com> <1369298335-24597-1-git-send-email-jhovold@gmail.com> <20130529133354.dd181c845ee4e96527483345@linux-foundation.org> <CAOCHtYiK8Y6iTnb4dWAE+cKHqEta-64gj+PorSFVGBF5wmg1+Q@mail.gmail.com> <51A68DC8.3090703@interlog.com>
In-Reply-To: <51A68DC8.3090703@interlog.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/05/2013 01:22, Douglas Gilbert :
> On 13-05-29 04:41 PM, Robert Nelson wrote:
>> On Wed, May 29, 2013 at 3:33 PM, Andrew Morton
>> <akpm@linux-foundation.org> wrote:
>>> On Thu, 23 May 2013 10:38:50 +0200 Johan Hovold <jhovold@gmail.com>
>>> wrote:
>>>
>>>> This is an update of the shadow-interrupt-mask series against
>>>> v3.10-rc2.
>>>>
>>>> I guess we need Atmel to confirm that all sam9x5 SoCs are indeed
>>>> affected. If not, then some probing mechanism as the one Doug suggested
>>>> could be implemented on top of (a subset of) these patches. What do you
>>>> say, Nicolas?
>>>>
>>>> Note that the first patch (adding a missing OF compile guard) could be
>>>> applied straight away.
>>>
>>> At this stage it is unclear to me how to proceed with patches 2-5.
>>
>> fyi:
>>
>> A version of these patches had been applied once before:
>> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=0ef1594c017521ea89278e80fe3f80dafb17abde
>>
>>
>> But due to a few issues it was later reverted:
>> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=e24b0bfa2f0446ffaad2661040be23668133aef8
>>
>
> Strange life of a patch. Mine was the original, Johan Hovold
> objected and had it reverted. Johan then presented his first
> patch then v2. They got lost in the weeds.

No, they were not lost. No patch is ever lost and this thread is the proof.

> My hardware was still broken and this bug caused collateral
> damage. My original patch no longer applied to lk 3.10.0-rc1
> so I rewrote it, borrowing some of Johan's ideas and doing a
> probe time check for the broken RTC_IMR. That patch was
> presented about a week ago:
>    http://marc.info/?l=linux-arm-kernel&m=136917492531478&w=2
> The top of that post gives some more background.
>
> That prompted Johan to produce v3 of his patch which is the
> subject of this thread. I was hoping that Nicolas Ferre would
> comment or ack one of these patches. Still waiting.

Sure that all this did not progressed at the speed you expected. I 
understand that. But even if I did not answered in a timely manner, that 
does not mean that I didn't considered it and marked it as "things to be 
done before next merge window"...

So, today, too late, I gave my "Acked-by". Sorry for the delay. Let's 
still monitor the progress of this series upstream.

> I have a copy of the original, publicly released manual for
> the at91sam9g25 (a member of the at91sam9x5 family) marked
> "11032A–ATARM–27-Jul-11". It contains the following:
>    Errata
>    49.3.1
>      RTC: Interrupt Mask Register cannot be used
>           Interrupt Mask Register reading always returns 0.
>
> Both Rev B and Rev C of that manual drop that particular
> erratum. My g25 SoC-based subsystems come from an Atmel
> partner and still have the RTC IMR bug.

We already talked about this Douglas. Why are you saying this again. So, 
to summarize:

1/ each and every at91sam9x5 family SoC have and will probably always 
have this IMR bug (including 9g25 which is part of the family).

2/ you kindly reported the errata disappearing in the documentation. It 
is an error with document appearance which you probably noted. I have 
made the necessary actions to correct this. But here again, you have to 
be patient waiting for the datasheet's next revision.

Best regards,
-- 
Nicolas Ferre

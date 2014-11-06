Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751339AbaKFEeG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 23:34:06 -0500
Received: from mail-qa0-f44.google.com ([209.85.216.44]:62007 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbaKFEeD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 23:34:03 -0500
MIME-Version: 1.0
In-Reply-To: <20141105194047.GQ6548@saruman>
References: <1415095254-24683-1-git-send-email-kiran.kumar@linaro.org>
	<20141105194047.GQ6548@saruman>
Date: Thu, 6 Nov 2014 10:04:01 +0530
Message-ID: <CA+RfmHZbsR0Q2X-4Pj1dwi1Qzpkf2K+e-JkfSqutaY=PhJckaA@mail.gmail.com>
Subject: Re: [RFC v5] usb: phy: Hold wakeupsource when USB is enumerated in
 peripheral mode
From: Kiran Raparthy <kiran.kumar@linaro.org>
To: Felipe Balbi <balbi@ti.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Todd Poynor <toddpoynor@google.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        =?UTF-8?B?QXJ2ZSBIau+/vW5uZXbvv71n?= <arve@android.com>,
        Benoit Goby <benoit@android.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

On 6 November 2014 01:10, Felipe Balbi <balbi@ti.com> wrote:
> On Tue, Nov 04, 2014 at 03:30:54PM +0530, Kiran Kumar Raparthy wrote:
>> From: Todd Poynor <toddpoynor@google.com>
>>
>> usb: phy: Hold wakeupsource when USB is enumerated in peripheral mode
>>
>> Some systems require a mechanism to prevent system to enter into suspend
>> state when USB is connected and enumerated in peripheral mode.
>>
>> This patch provides an interface to hold a wakeupsource to prevent suspend.
>> PHY drivers can use this interface when USB is connected and enumerated in
>> peripheral mode.
>>
>> A timed wakeupsource is temporarily held on USB disconnect events, to allow
>> the rest of the system to react to the USB disconnection (dropping host
>> sessions, updating charger status, etc.) prior to re-allowing suspend.
>>
>> Cc: Kishon Vijay Abraham I <kishon@ti.com>
>> Cc: Felipe Balbi <balbi@ti.com>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Cc: linux-kernel@vger.kernel.org
>> Cc: linux-usb@vger.kernel.org
>> Cc: Android Kernel Team <kernel-team@android.com>
>> Cc: John Stultz <john.stultz@linaro.org>
>> Cc: Sumit Semwal <sumit.semwal@linaro.org>
>> Cc: Arve Hjønnevåg <arve@android.com>
>> Cc: Benoit Goby <benoit@android.com>
>> Signed-off-by: Todd Poynor <toddpoynor@google.com>
>> [kiran: Added context to commit message, squished build fixes
>> from Benoit Goby and Arve Hjønnevåg, changed wakelocks usage
>> to wakeupsource, merged Todd's refactoring logic and simplified
>> the structures and code and addressed community feedback]
>> Signed-off-by: Kiran Raparthy <kiran.kumar@linaro.org>
>
> you still didn't get this right. I asked that you introduce
> usb_phy_set_event() as a separate patch, then make PHY drivers use it
> and only on a third patch should you hold a wakeupsource.
Thanks for your time.
Sure,I'll resend the patches as per your suggestion,could you please
let me know whether you are okay with this new approach?.
This will help me to consolidate all your inputs in new patch set.
Regards,
Kiran
>
> --
> balbi

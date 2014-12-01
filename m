Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504AbaLAFju (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 00:39:50 -0500
Received: from mail-qa0-f50.google.com ([209.85.216.50]:59367 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336AbaLAFjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 00:39:49 -0500
MIME-Version: 1.0
In-Reply-To: <20141125144544.GC6360@saruman>
References: <1416849900-29959-1-git-send-email-kiran.kumar@linaro.org>
	<1416849900-29959-3-git-send-email-kiran.kumar@linaro.org>
	<15cad5ef7627483cbba96e05fe180813@BN1PR0301MB0772.namprd03.prod.outlook.com>
	<20141125144544.GC6360@saruman>
Date: Mon, 1 Dec 2014 11:09:48 +0530
Message-ID: <CA+RfmHZRqMwiSAZ7kpn+0_8a+25O+hRKxGJuK6im6fX0dzB8Nw@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] usb: phy: hold wakeupsource when USB is enumerated
 in peripheral mode
From: Kiran Raparthy <kiran.kumar@linaro.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Peter Chen <Peter.Chen@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
        Benoit Goby <benoit@android.com>, Todd Poynor <toddpoynor@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

On 25 November 2014 at 20:15, Felipe Balbi <balbi@ti.com> wrote:
> On Tue, Nov 25, 2014 at 07:06:18AM +0000, Peter Chen wrote:
>>
>> >
>> > usb: phy: hold wakeupsource when USB is enumerated in peripheral mode
>> >
>> > Some systems require a mechanism to prevent system to enter into suspend
>> > state when USB is connected and enumerated in peripheral mode.
>> >
>> > This patch provides an interface to hold a wakeupsource to prevent suspend.
>> > PHY drivers can use this interface when USB is connected and enumerated in
>> > peripheral mode.
>> >
>> > A timed wakeupsource is temporarily held on USB disconnect events, to allow
>> > the rest of the system to react to the USB disconnection (dropping host
>> > sessions, updating charger status, etc.) prior to re-allowing suspend.
>> >
>>
>> Hi Kiran & Felipe,
>>
>> Just two questions for this series
>>
>> - Will it be the default behavior for all peripheral drivers?
>> - If the peripheral driver's PHY driver does not vbus event, how to
>> support it?
>> For example, chipidea udc driver has its vbus interface at its
>> controller register.
>
> hmm, good point. Since it's so late, I'll just go ahead and drop
> $subject from v3.20. Let's delay only $subject to v3.20 merge window so
> we have some more time to discuss these details.

I am just curious to know/understand why this feature needs to be
default behavior for all peripheral drivers?
If this needs to be default behavior, could you please suggest any
alternate plan/design for this feature so that i can incorporate them
in new patch.
Regards,
Kiran

>
> cheers
>
> --
> balbi

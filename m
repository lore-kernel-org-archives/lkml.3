Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932157AbaJUDY1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 23:24:27 -0400
Received: from mail-qg0-f52.google.com ([209.85.192.52]:54779 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754206AbaJUDY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 23:24:26 -0400
MIME-Version: 1.0
In-Reply-To: <CD2CABCB2C0A0D4682C5F8AD840141540D27B9@HKXPRD3002MB006.064d.mgd.msft.net>
References: <1413362372-16236-1-git-send-email-huishao@microsoft.com>
	<alpine.DEB.2.11.1410202027220.5308@nanos>
	<alpine.DEB.2.11.1410202034150.5308@nanos>
	<CD2CABCB2C0A0D4682C5F8AD840141540D27B9@HKXPRD3002MB006.064d.mgd.msft.net>
Date: Mon, 20 Oct 2014 20:24:25 -0700
Message-ID: <CALAqxLVKZKQn628ZUa1D9ev37DUz+h4y5AXhMqCg_8dJ7JkEDw@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] timekeeping: add EXPORT_SYMBOL_GPL for do_adjtimex()
From: John Stultz <john.stultz@linaro.org>
To: Thomas Shao <huishao@microsoft.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        KY Srinivasan <kys@microsoft.com>,
        Richard Cochran <rcochran@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2014 at 8:18 PM, Thomas Shao <huishao@microsoft.com> wrote:
>
>> -----Original Message-----
>> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
>> owner@vger.kernel.org] On Behalf Of Thomas Gleixner
>> Sent: Tuesday, October 21, 2014 2:41 AM
>> To: Thomas Shao
>> Cc: gregkh@linuxfoundation.org; LKML; devel@linuxdriverproject.org;
>> olaf@aepfle.de; apw@canonical.com; jasowang@redhat.com; KY Srinivasan;
>> John Stultz; Richard Cochran
>> Subject: Re: [PATCH v2 1/2] timekeeping: add EXPORT_SYMBOL_GPL for
>> do_adjtimex()
>>
>> On Mon, 20 Oct 2014, Thomas Gleixner wrote:
>>
>> > On Wed, 15 Oct 2014, Thomas Shao wrote:
>> >
>> > And again you forgot to cc John Stultz on this....
>> >
>> > > Export do_adjtimex function for hyper-v Time Synchronization
>> > > component
>>
>> Aside of that, we really want to see the use case for this and how you
>> addressed the problems which were pointed out by various folks.
>>
>
> In some situation, the user is not able to enable guest VM to sync with external
> time source, like NTP. But the host is still synced with a trusted time source.
> In this case, host-guest time synchronization is useful. Hyper-v host will send time
> sample to guest VM every 5 seconds. We will use these time samples to adjust guest
> VM time.
>
> I've got some feedbacks from Richard and Mike, including reference NTP implementation
> and do the adjustment in the host side. I've already referenced some NTP design in
> my patch. I would consider my patch as a simplified implementation. I've also considered
> the host side implementation. But in host, we can only set time but not gradually slew/adjust
> time, which is not acceptable for the time sync solution.We still recommend user to configure
> NTP on the guest, which provides better accuracy. But if NTP is not applicable, this could be
> another option.
>
>> I still do not have a consistent argument from you WHY you need to abuse
>> do_adjtimex() to do that host - guest synchronization in the first place.
>>
>
> I need a function to gradually slew guest time. do_adjtimex() provides all the
> functionality. Also I could not find any other exposed func to do this. I'd like to
> hear any feedback from you for this.

Do you have any protections from both your kernel module trying to
slew time if the guest is also running NTPd? That seems like it could
cause some strange behavior.

thanks
-john

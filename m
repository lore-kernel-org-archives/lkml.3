Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234AbaKXQP7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 11:15:59 -0500
Received: from mail-oi0-f50.google.com ([209.85.218.50]:36120 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477AbaKXQP4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 11:15:56 -0500
MIME-Version: 1.0
In-Reply-To: <20141124155422.GH20705@saruman>
References: <cover.1416547297.git.kiran.kumar@linaro.org> <7a23b5f0af4463aea85384b6a67678b9c41b9d2d.1416547297.git.kiran.kumar@linaro.org>
 <20141121151105.GC7508@saruman> <CA+RfmHZo4FuH6-Z8+VFY7Ao5QVD-VmfdCm17ZrB6f7J8Xpo-Aw@mail.gmail.com>
 <20141124143819.GB20705@saruman> <CAO_48GFj2moODXtB1W9t6tbuvcyF2WgnakSDrbQRzPi+u=mc=g@mail.gmail.com>
 <20141124155422.GH20705@saruman>
From: Sumit Semwal <sumit.semwal@linaro.org>
Date: Mon, 24 Nov 2014 21:45:35 +0530
Message-ID: <CAO_48GFK_a=d+jUMR8-eqRVy1V_hSt8hKs2uOA00zzxstgV7pA@mail.gmail.com>
Subject: Re: [PATCH v1 2/3] usb: phy: Handle per-PHY event for connect and
 disconnect events
To: balbi <balbi@ti.com>
Cc: Kiran Raparthy <kiran.kumar@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb <linux-usb@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        =?UTF-8?B?QXJ2ZSBIau+/vW5uZXbvv71n?= <arve@android.com>,
        Benoit Goby <benoit@android.com>, Todd Poynor <toddpoynor@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 November 2014 at 21:24, Felipe Balbi <balbi@ti.com> wrote:
> On Mon, Nov 24, 2014 at 09:19:09PM +0530, Sumit Semwal wrote:
>> Hi Felipe,
>>
>> On 24 November 2014 at 20:08, Felipe Balbi <balbi@ti.com> wrote:
>> > Hi,
>> >
>> > On Fri, Nov 21, 2014 at 09:13:00PM +0530, Kiran Raparthy wrote:
>> >> On 21 November 2014 20:41, Felipe Balbi <balbi@ti.com> wrote:
>> >> > On Fri, Nov 21, 2014 at 11:31:21AM +0530, Kiran Raparthy wrote:
>> >> >> usb: phy: Handle per-PHY event for connnect and disconnect events
>> >> >>
>> >> >> When usb is connected and enumerated in device mode or when usb is
>> >> >> disconnected,call usb_phy_set_event from phy drivers to handle per-PHY event.
>> >> >>
>> >> >> Cc: Felipe Balbi <balbi@ti.com>
>> >> >> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> >> >> Cc: linux-kernel@vger.kernel.org
>> >> >> Cc: linux-usb@vger.kernel.org
>> >> >> Cc: Android Kernel Team <kernel-team@android.com>
>> >> >> Cc: John Stultz <john.stultz@linaro.org>
>> >> >> Cc: Sumit Semwal <sumit.semwal@linaro.org>
>> >> >> Cc: Arve Hj�nnev�g <arve@android.com>
>> >> >> Cc: Benoit Goby <benoit@android.com>
>> >> >> [Original patch in Android from Todd]
>> >> >> Cc: Todd Poynor <toddpoynor@google.com>
>> >> >> Signed-off-by: Kiran Raparthy <kiran.kumar@linaro.org>
>> >> >
>> >> > this patch doesn't apply, please rebase entire series on my testing/next.
>> >
>> > your rebased version didn't apply either. Can you make sure you're
>> > rebasing on top of my today's testing/next branch ?
>> >
>> I just verified that I am able to apply both this patch (and the next
>> one - so 2/3 and 3/3) on your testing/next branch - just to make sure,
>> this is the git/branch right?
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git
>> branch:testing/next
>
> that's the correct branch, but here's what I get:

That's very odd - I pulled your branch for the first time about 5
minutes before I sent the mail? perhaps local branch updates?
>
> checking file drivers/usb/phy/phy-ab8500-usb.c
> Hunk #1 FAILED at 447.
> Hunk #2 succeeded at 459 (offset -2 lines).
> Hunk #3 succeeded at 502 (offset -2 lines).
> Hunk #4 succeeded at 527 (offset -2 lines).
> Hunk #5 FAILED at 589.
> Hunk #6 succeeded at 600 (offset -2 lines).
> Hunk #7 succeeded at 629 (offset -2 lines).
> Hunk #8 succeeded at 652 (offset -2 lines).
> Hunk #9 FAILED at 701.
> Hunk #10 succeeded at 712 (offset -2 lines).
> Hunk #11 succeeded at 740 (offset -2 lines).
> Hunk #12 FAILED at 786.
> Hunk #13 succeeded at 801 (offset -2 lines).
> Hunk #14 succeeded at 828 (offset -2 lines).
> 4 out of 14 hunks FAILED
> checking file drivers/usb/phy/phy-gpio-vbus-usb.c
> checking file drivers/usb/phy/phy-mv-usb.c
> checking file drivers/usb/phy/phy-tahvo.c
> Hunk #1 FAILED at 87.
> Hunk #2 FAILED at 105.
> 2 out of 2 hunks FAILED
>
> cheers
>
> --
> balbi


Best,
Sumit.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932419Ab3DYXXT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 19:23:19 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:44607 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932096Ab3DYXXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 19:23:18 -0400
MIME-Version: 1.0
In-Reply-To: <51782A9D.20303@linaro.org>
References: <1366828376-18124-1-git-send-email-john.stultz@linaro.org>
 <CAPXgP123q9K8-NibkpmbvwpRTM1cdODWycq3o-HdWEYBwoGCFQ@mail.gmail.com> <51782A9D.20303@linaro.org>
From: Kay Sievers <kay@vrfy.org>
Date: Fri, 26 Apr 2013 01:22:56 +0200
Message-ID: <CAPXgP13rAfedO1ssEKszqkzozMngALN1LgtfHHGw+LbyrSgeZw@mail.gmail.com>
Subject: Re: [PATCH] time: Revert ALWAYS_USE_PERSISTENT_CLOCK compile time optimizaitons
To: John Stultz <john.stultz@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>,
        Feng Tang <feng.tang@intel.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 24, 2013 at 8:55 PM, John Stultz <john.stultz@linaro.org> wrote:

>> FWIW, in the light of the original change, I've just removed the
>> /dev/rtc creation from the default udev rules now, so that thing will
>> be phased out in the future.
>
> Is that actually wanted? What happens to applications that use /dev/rtc?
>
> I think setting up the /dev/rtc link is important. Its just that setting it
> up exclusively by the hctosys flag is maybe more fragile then we'd like.
> Instead the hctosys flag maybe should only be used as a hint if there is
> more then one RTC available.

Ok, convinced.

I've changed the udev rules now to first "search" for the rtc with
"hctosys" flag set, and if none is found, just fall back to /dev/rtc0.

It should work reliably on most boxes, and still do the right thing in
most cases if none of the rtcs has that flag.

Thanks,
Kay

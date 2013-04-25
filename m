Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758820Ab3DYQCD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 12:02:03 -0400
Received: from mail-wg0-f54.google.com ([74.125.82.54]:52591 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757164Ab3DYQCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 12:02:01 -0400
MIME-Version: 1.0
In-Reply-To: <5178D719.2060405@ahsoftware.de>
References: <CAPXgP13kizK95JyLxKxgWrGnV9b11ZTyi3vuc5YFDmROzckg4w@mail.gmail.com>
 <517746E4.908@linaro.org> <CAPXgP128yAq1jju-gsZcaS-mZPt+7tq0tt-uVk3Yqr77abd26Q@mail.gmail.com>
 <51774F44.2060704@linaro.org> <517769A9.5060308@ahsoftware.de>
 <51780348.6090202@linaro.org> <5178D719.2060405@ahsoftware.de>
From: Kay Sievers <kay@vrfy.org>
Date: Thu, 25 Apr 2013 18:01:39 +0200
Message-ID: <CAPXgP122ZwRc5B7DcYaiV=N3KDTxh-ejZKCzsk5nKrLwG3S=dA@mail.gmail.com>
Subject: Re: CONFIG_RTC_HCTOSYS lost on x86 with ALWAYS_USE_PERSISTENT_CLOCK changes?
To: Alexander Holler <holler@ahsoftware.de>
Cc: John Stultz <john.stultz@linaro.org>, LKML <linux-kernel@vger.kernel.org>,
        Feng Tang <feng.tang@intel.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 25, 2013 at 9:11 AM, Alexander Holler <holler@ahsoftware.de> wrote:

> Hmm, I thought RTC_SYSTOHC was there to update the used RTC clock with the
> time from NTP (and liked that).

That seems to have the nice self-explaining name CONFIG_GENERIC_CMOS_UPDATE. :)

> Therefor I don't understand why it is
> redundant and unnecessary on x86.

Because the x86 native RTC/cmos is updated with platform code, not
generic rtc code:
  arch/x86/kernel/rtc.c

> Of course, most systems do have something
> in userspace to set the RTC on shutdown, so it isn't really needed.

That is gone on most systems today. Systems without NTP or something
else running have no clue about the time, and should not touch the
hardware clock with a boot cycle. Only if a reliable time source like
NTP is available, it should update the hardware clock accordingly.

> Anyway, thanks a lot for the great overview.

Yeah, thanks John, from my side too.

Kay

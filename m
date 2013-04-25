Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932851Ab3DYTp3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 15:45:29 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:36581 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932250Ab3DYTp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 15:45:27 -0400
MIME-Version: 1.0
In-Reply-To: <20130425183301.GA31863@obsidianresearch.com>
References: <CAPXgP13kizK95JyLxKxgWrGnV9b11ZTyi3vuc5YFDmROzckg4w@mail.gmail.com>
 <517746E4.908@linaro.org> <CAPXgP128yAq1jju-gsZcaS-mZPt+7tq0tt-uVk3Yqr77abd26Q@mail.gmail.com>
 <51774F44.2060704@linaro.org> <517769A9.5060308@ahsoftware.de>
 <51780348.6090202@linaro.org> <5178D719.2060405@ahsoftware.de>
 <5179562C.3000903@linaro.org> <20130425183301.GA31863@obsidianresearch.com>
From: Kay Sievers <kay@vrfy.org>
Date: Thu, 25 Apr 2013 21:45:04 +0200
Message-ID: <CAPXgP13PaBqtU+MQnz6fT+B18WJP3_tqSCv+OYA5W_z6F=VWdg@mail.gmail.com>
Subject: Re: CONFIG_RTC_HCTOSYS lost on x86 with ALWAYS_USE_PERSISTENT_CLOCK changes?
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: John Stultz <john.stultz@linaro.org>,
        Alexander Holler <holler@ahsoftware.de>,
        LKML <linux-kernel@vger.kernel.org>, Feng Tang <feng.tang@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 25, 2013 at 8:33 PM, Jason Gunthorpe
<jgunthorpe@obsidianresearch.com> wrote:
> So, my conclusion is nobody with a RTC looking for space savings, will
> disable CONFIG_RTC, which means we can safely rely on
> CONFIG_RTC_SYSTOHC to do this work. To that end, I would encourage
> everyone who sets CONFIG_GENERIC_CMOS_UPDATE to also set
> CONFIG_RTC_SYSTOHC - that will let update_persistent_clock to be
> ripped out over time without impacting users.

John's original patch forcefully disabled CONFIG_RTC_SYSTOHC on x86,
which is quite the opposite of what you recommend here. :)

Could you guys both sort that out and give an idea what the
recommended setup should look like today, ignoring all space saving
and possible hctosys API changes caused by this. Should
CONFIG_RTC_SYSTOHC be enabled or not?

Kay

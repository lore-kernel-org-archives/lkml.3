Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724AbaCUXqp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 19:46:45 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:61294 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbaCUXql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 19:46:41 -0400
MIME-Version: 1.0
In-Reply-To: <CAPDwgkNuiMmVXSznGAT2-cZ1rApHbSPyBewxGzLvSWt1mUdnAA@mail.gmail.com>
References: <1395430798-25606-1-git-send-email-miletus@chromium.org>
	<CAN+gG=EKFCjT+Px+HuyrsPxQ5sivWMNL=SXeGGXEdN8qg2e6iw@mail.gmail.com>
	<CAPDwgkNuiMmVXSznGAT2-cZ1rApHbSPyBewxGzLvSWt1mUdnAA@mail.gmail.com>
Date: Fri, 21 Mar 2014 19:46:39 -0400
Message-ID: <CAN+gG=EqJF8wBQd3jJLPcObffZUEkgv=7=hh-sDCnn0t+JL4jg@mail.gmail.com>
Subject: Re: [PATCH] Add quirk HID_QUIRK_NO_INIT_REPORTS for RNDPLUS touchscreen
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Yufeng Shen <miletus@google.com>
Cc: linux-input <linux-input@vger.kernel.org>, Jiri Kosina <jkosina@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-usb@vger.kernel.org, Andrew de los Reyes <adlr@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21, 2014 at 6:08 PM, Yufeng Shen <miletus@google.com> wrote:
>
>
> On Fri, Mar 21, 2014 at 4:58 PM, Benjamin Tissoires
> <benjamin.tissoires@gmail.com> wrote:
>>
>> On Fri, Mar 21, 2014 at 3:39 PM, Yufeng Shen <miletus@chromium.org> wrote:
>> > There is timeout error during initialization:
>> > kernel: [   14.167086] hid-multitouch 0003:2512:5003.0001:
>> > usb_submit_urb(ctrl) failed: -1
>> > kernel: [   14.167135] hid-multitouch 0003:2512:5003.0001: timeout
>> > initializing reports
>> > kernel: [   14.167407] input: RNDPLUS Co., LTD   PULSEIR TSR4601 as
>> > /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.3/2-1.3:1.0/input/input14
>> > kernel: [   14.167975] cpufreq_interactive: monitoring input on RNDPLUS
>> > Co., LTD   PULSEIR TSR4601
>> > kernel: [   14.168266] hid-multitouch 0003:2512:5003.0001:
>> > input,hiddev0,hidraw1: USB HID v1.10 Mouse [RNDPLUS Co., LTD   PULSEIR
>> > TSR4601] on usb-0000:00:1d.0-1.3/input0
>> >
>> > Adding quirk HID_QUIRK_NO_INIT_REPORTS can solve the problem.
>>
>> I already asked you to test if HID_QUIRK_NO_INIT_INPUT_REPORTS was
>> working for the same same kind of timeout
>> (https://patchwork.kernel.org/patch/3544281/).
>
>
> The reason I didn't test HID_QUIRK_NO_INIT_INPUT_REPORTS was that I am
> mainly
> working with kernel 3.8/3.10. And HID_QUIRK_NO_INIT_INPUT_REPORTS was not
> present

You should consider working with an upstream kernel when sending patches.

> in the kernel source. Do you have the patch set that I can port to 3.8/3.10
> kernel for testing ?

git blames gives 595e9276ce68791317484ec7f0f9f2e0457c3b34, which is
Linus' tree since 3.12.

Cheers,
Benjamin

>
>
>>
>>
>> So I am asking again: please test HID_QUIRK_NO_INIT_INPUT_REPORTS and
>> if it works, use this quirk instead the one in this patch.
>> This *really* matters because the quirk HID_QUIRK_NO_INIT_REPORTS does
>> not initialize feature reports which contains important information
>> regarding hid-multitouch.
>>
>> Cheers,
>> Benjamin
>>
>> >

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942AbaBGMDx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 07:03:53 -0500
Received: from mail-ob0-f171.google.com ([209.85.214.171]:41746 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804AbaBGMDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 07:03:48 -0500
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1402021108470.19760-100000@netrider.rowland.org>
References: <1391311006-4138-1-git-send-email-zoran.markovic@linaro.org>
	<Pine.LNX.4.44L0.1402021108470.19760-100000@netrider.rowland.org>
Date: Fri, 7 Feb 2014 04:03:46 -0800
Message-ID: <CAME+o4nK+hOs+TygwzVzDBTUMfF7dWs9WVg2FTMSt6neYckVtA@mail.gmail.com>
Subject: Re: [RFC PATCHv2] usb: move hub init and LED blink work to power
 efficient workqueue
From: Zoran Markovic <zoran.markovic@linaro.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org,
        Shaibal Dutta <shaibal.dutta@broadcom.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Xenia Ragiadakou <burzalodowa@gmail.com>,
        Julius Werner <jwerner@chromium.org>,
        Krzysztof Mazur <krzysiek@podlesie.net>,
        Matthias Beyer <mail@beyermatthias.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Thomas Pugliese <thomas.pugliese@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I believe there may still be use cases where you want to wake up the
same CPU that scheduled the work.

Thanks for the Ack. Can you please queue this for 3.14?

Regards, Zoran

On 2 February 2014 08:10, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Sat, 1 Feb 2014, Zoran Markovic wrote:
>
>> From: Shaibal Dutta <shaibal.dutta@broadcom.com>
>>
>> Allow the scheduler to select the best CPU to handle hub initalization
>> and LED blinking work. This extends idle residency times on idle CPUs
>> and conserves power.
>>
>> This functionality is enabled when CONFIG_WQ_POWER_EFFICIENT is selected.
>>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Cc: Alan Stern <stern@rowland.harvard.edu>
>> Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>
>> Cc: Xenia Ragiadakou <burzalodowa@gmail.com>
>> Cc: Julius Werner <jwerner@chromium.org>
>> Cc: Krzysztof Mazur <krzysiek@podlesie.net>
>> Cc: Matthias Beyer <mail@beyermatthias.de>
>> Cc: Dan Williams <dan.j.williams@intel.com>
>> Cc: Mathias Nyman <mathias.nyman@linux.intel.com>
>> Cc: Thomas Pugliese <thomas.pugliese@gmail.com>
>> Signed-off-by: Shaibal Dutta <shaibal.dutta@broadcom.com>
>> [zoran.markovic@linaro.org: Rebased to latest kernel. Added commit message.
>> Changed reference from system to power efficient workqueue for LEDs in
>> check_highspeed() and hub_port_connect_change().]
>> Signed-off-by: Zoran Markovic <zoran.markovic@linaro.org>
>
> Acked-off-by: Alan Stern <stern@rowland.harvard.edu>
>
> Is there some reason why schedule_delayed_work() doesn't use the
> power-efficient work queue by default?
>
> Alan Stern
>

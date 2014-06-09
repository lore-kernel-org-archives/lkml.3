Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934988AbaFIXOB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 19:14:01 -0400
Received: from mga02.intel.com ([134.134.136.20]:23194 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934855AbaFIXNp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 19:13:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,1005,1392192000"; 
   d="scan'208";a="525892530"
Message-ID: <5396409D.5000501@linux.intel.com>
Date: Mon, 09 Jun 2014 16:17:49 -0700
From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Alexander Holler <holler@ahsoftware.de>, linux-kernel@vger.kernel.org,
        Reyad Attiyat <reyad.attiyat@gmail.com>
Subject: Re: HID: hid-sensor-hub: fix sleeping function called from invalid
 context
References: <53963364.4010104@ahsoftware.de> <alpine.LNX.2.00.1406100038150.2827@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1406100038150.2827@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/09/2014 03:40 PM, Jiri Kosina wrote:
> On Tue, 10 Jun 2014, Alexander Holler wrote:
>
>> Hello,
>>
>> while rebasing the dozens (currently around 60) of refused, ignored or
>> similiar bugfixes and patches I need to use a Linux kernel, I've noticed that
>> Jiri Kosinas patch here
>>
>> https://lkml.org/lkml/2013/8/9/214
>>
>> doesn't apply anymore.
>>
>> Looking why, I've seen that a similiar patch from Srinivas Pandruvada named
>> like the topic ended up in the kernel.
>
> Hi Alexander,
>
> thanks for drawing this one from the boulevard of forgotten patches.
>
> I am actually not aware of any patch by Srinivas that would conflict with
> the one I've written -- could you please elaborate where you believe the
> conflict is?
>
>> Looking at the differences, I wonder if not all spin_lock() calls in
>> hid-sensor-hub.c should be changed into spin_lock_irqsave() like the
>> patch from Jiri Kosina did.
>

There is a patch submitted by "reyad.attiyat@gmail.com"
[PATCH] HID: hid-sensor-hub: Fix lockdep warning for dynamic callback locks.

Already doing this, what you suggested?

+Reyad


Thanks,
Srinivas


> Could you please give me your Tested-by:? I'll then be happily queuing the
> fix. Thanks.
>
>> (sorry for the duplicate message, I've forgotten to add the
>> wanna-be-reviewer-school named lkml to the recipients)
>
> You want to make it to LWN quotes of the week, don't you? :)
>


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932312AbaD1Ufq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 16:35:46 -0400
Received: from mga09.intel.com ([134.134.136.24]:22214 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754708AbaD1Ufo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 16:35:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,946,1389772800"; 
   d="scan'208";a="502497673"
Message-ID: <535EBB5B.4000004@intel.com>
Date: Mon, 28 Apr 2014 22:34:35 +0200
From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Organization: Intel Technology Poland Sp. z o. o., KRS 101882, ul. Slowackiego
 173, 80-298 Gdansk
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Zhang Rui <rui.zhang@intel.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhelgaas@google.com, matthew.garrett@nebula.com,
        dmitry.torokhov@gmail.com
Subject: Re: [PATCH V5 12/12] ACPI: introduce .handle_children flag for acpi
 scan handler
References: <1396886819-2637-1-git-send-email-rui.zhang@intel.com>	 <1396886819-2637-13-git-send-email-rui.zhang@intel.com>	 <3580601.ADWiqFXU1h@vostro.rjw.lan> <1398650870.2443.22.camel@rzhang1-mobl4>
In-Reply-To: <1398650870.2443.22.camel@rzhang1-mobl4>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/28/2014 4:07 AM, Zhang Rui wrote:
> On Mon, 2014-04-28 at 00:26 +0200, Rafael J. Wysocki wrote:
>> On Tuesday, April 08, 2014 12:06:59 AM Zhang Rui wrote:
>>> For some devices with scan handler attached, their children devices
>>> are enumerated by the scan handler, indirectly.
>> This isn't the case really.  They are enumerated by bus controller drivers
>> for the buses they are on.
>>
> that's what I mean by saying "indirectly". :)
>
>>> In this case, we do not want to enumerate the children devices in
>>> acpi scan code explicitly.
>>>
>>> Thus a new flag .handle_children is introduced in this patch.
>>>
>>> For scan handlers with this flag set, we will do default enumeration neither
>>> for the attached devices nor for the children of the attached devices.
>> I'm not sure if that is the right approach.  I would prefer that to be
>> handled in a more fine-graind manner, like a flag per device ID or something
>> similar?
>>
> hmmm, how about this,
> first, keep the device->flags.no_child_enumeration flag introduced in
> this patch
> second, set the flag explicitly, for specified devices, in the scan
> handler .attach() function.

But then it could simply clear the platform_id flag for them, couldn't it?

Rafael


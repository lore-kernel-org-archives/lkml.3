Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752210AbaEUL7a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 07:59:30 -0400
Received: from mga03.intel.com ([143.182.124.21]:18892 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751018AbaEUL73 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 07:59:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,879,1392192000"; 
   d="scan'208";a="434981186"
Message-ID: <537C9511.90206@intel.com>
Date: Wed, 21 May 2014 13:59:13 +0200
From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Organization: Intel Technology Poland Sp. z o. o., KRS 101882, ul. Slowackiego
 173, 80-298 Gdansk
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Zhang Rui <rui.zhang@intel.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, bhelgaas@google.com,
        matthew.garrett@nebula.com, dmitry.torokhov@gmail.com
Subject: Re: [PATCH V6 09/11] ACPI: introduce flag .is_master_device
References: <1400136256-2218-1-git-send-email-rui.zhang@intel.com> <1400136256-2218-10-git-send-email-rui.zhang@intel.com> <20140521085207.GR1651@lahna.fi.intel.com> <2394524.GkgpdWbBbP@vostro.rjw.lan> <20140521110444.GU1651@lahna.fi.intel.com>
In-Reply-To: <20140521110444.GU1651@lahna.fi.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/21/2014 1:04 PM, Mika Westerberg wrote:
> On Wed, May 21, 2014 at 01:10:33PM +0200, Rafael J. Wysocki wrote:
>> On Wednesday, May 21, 2014 11:52:07 AM Mika Westerberg wrote:
>>> On Thu, May 15, 2014 at 02:44:14PM +0800, Zhang Rui wrote:
>>>> For some ACPI device objects, they represent master devices,
>>>> and their children devices are enumerated by bus controller drivers
>>>> for the buses they are on.
>>>>
>>>> In this case, we do not want to enumerate their children devices to
>>>> platform bus explicitly in acpi scan code.
>>>>
>>>> Thus a new flag .is_master_device is introduced in this patch.
>>>>
>>>> For devices with this flag set, we will not do default enumeration
>>>> for their children.
>>> Is there any particular reason we would like to enumerate everything
>>> below the first device by default?
>> Yes, there is.  Device objects without _ADR under the PCI host bridge.
> OK.
>
>> Or we can skip the children under every *platform* device created by this by
>> default and mark the ones where we want the children to be enumerated as
>> platform devices too in a special way if needed.
>>
>> I guess we could try that (that was the Rui's original idea IIRC).
> That sounds better to me.
>
> I wonder if we can do this analogous to of_platform_bus_probe() and
> friends?

Yes, we should actually.

Rafael


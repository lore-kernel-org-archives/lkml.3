Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759733Ab3BHDUH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 22:20:07 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46092 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758939Ab3BHDUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 22:20:05 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <51146EC7.5090504@jp.fujitsu.com>
Date: Fri, 8 Feb 2013 12:19:35 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Yinghai Lu <yinghai@kernel.org>, Jiang Liu <liuj97@gmail.com>,
        Toshi Kani <toshi.kani@hp.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] ACPI / scan: Remove useless #ifndef and simplify
 container driver
References: <1873429.MS5RQDxTye@vostro.rjw.lan> <3164478.OcagzIMET0@vostro.rjw.lan> <5090866.2BHgpRnuEZ@vostro.rjw.lan> <1468930.acVuhKfKYv@vostro.rjw.lan>
In-Reply-To: <1468930.acVuhKfKYv@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

2013/02/08 9:24, Rafael J. Wysocki wrote:
> On Monday, February 04, 2013 12:47:31 AM Rafael J. Wysocki wrote:
>> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>>
>> The only useful thing that the ACPI container driver does is to
>> install system notify handlers for all container and module device
>> objects it finds in the namespace.  The driver structure,
>> acpi_container_driver, and the data structures created by its
>> .add() callback are in fact not used by the driver, so remove
>> them entirely.
>>
>> It also makes a little sense to build that driver as a module,
>> so make it non-modular and add its initialization to the
>> namespace scanning code.
>>
>> In addition to that, make the namespace walk callback used for
>> installing the notify handlers more straightforward.
>
> As pointed out by Toshi Kani, the above changes would make acpi_eject_store()
> fail for containers and it is the only way to eject them currently, so patch
> [2/2] is an improved version of this (with Toshi's changes folded in).
>
> Patch [1/2] is just a cleanup removing a useless #ifndef from acpi_eject_store().

I confimed the patch series works well.

Acked-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Tested-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

Thanks,
Yasuaki Ishimatsu

>
> Thanks,
> Rafael
>
>



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124Ab3G3OS0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 10:18:26 -0400
Received: from mailout2.w2.samsung.com ([211.189.100.12]:32183 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755405Ab3G3OSY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 10:18:24 -0400
X-AuditID: cbfec37a-b7fc36d0000050de-38-51f7cb2ef562
From: Shuah Khan <shuah.kh@samsung.com>
To: Joe Perches <joe@perches.com>
Cc: "joro@8bytes.org" <joro@8bytes.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Varun.Sethi@freescale.com" <Varun.Sethi@freescale.com>,
        "aik@ozlabs.ru" <aik@ozlabs.ru>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tony@atomide.com" <tony@atomide.com>,
        "ohad@wizery.com" <ohad@wizery.com>,
        "andreas.herrmann@calxeda.com" <andreas.herrmann@calxeda.com>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>,
        Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCH v2] iommu: Add event tracing feature to iommu
Thread-topic: [PATCH v2] iommu: Add event tracing feature to iommu
Thread-index: AQHOjMNeamWGzGXnqUif254kO+fg8A==
Date: Tue, 30 Jul 2013 14:18:20 +0000
Message-id: <B8EFE96D1287C24090BAD9D858E15E6174E456@sisaex01sj>
References: <1375147366-2922-1-git-send-email-shuah.kh@samsung.com>
 <1375147768.2075.91.camel@joe-AO722>
Accept-Language: en-US
Content-language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-Originating-IP: [105.144.21.63]
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 8BIT
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNIsWRmVeSWpSXmKPExsVy+t9hX129098DDW6st7boPV5k8e1/D5vF
	4iMxFjNfdzNZLNhvbTH7/mMWi87ZG9gtLu+aw2Zx6cACJovfq38wW+zreMBk8fWng8X+K14W
	M2+tYbF4+fEEiwO/x5OD85g81sxbw+jx7eskFo8Fn6+we/w73M/ksXPWXXaPln232D0m31jO
	6HHjbjObx5dV15g93u+7yubxeZOcx6dP+9gCeKO4bFJSczLLUov07RK4MtpftrIVnOGpeNZx
	hKWBcRVXFyMnh4SAicSrExeZIWwxiQv31rN1MXJxCAksY5T41zmFEcLpZZJYdbcJypnPKLHs
	01k2kBY2AXWJz693sHcxcnCICChK3N3CD1LDLHCfVWLSo+9sIHFhAUeJmZccQMpFBJwk5ryd
	ywxh60ncmnaIBaSERUBV4tDmcJAwr4C9xO0J08DCQgJZEp+Os4CEGYFu+35qDROIzSwgLtHc
	epMF4mYBiSV7zkPdLyrx8vE/VpBWCaBjtq+2gijXkli/8zhUq7bEk3cXWCE2CUr8mHyPZQKj
	2CwkU2chaZmFpGUWkpYFjCyrGMVKi5MLipPSUysM9YoTc4tL89L1kvNzNzFCEkTVDsY7X20O
	MQpwMCrx8G4o+BYoxJpYVlyZe4hRgoNZSYT3/MTvgUK8KYmVValF+fFFpTmpxYcYmTg4pRoY
	mYU7ss9/VHd2urWHJ2/NgZPXDlhME16/UU7jS13g5S1vm3jj1p5e8FDIb2Edk8ljtbtaWUVz
	NQ/v2Fj0Rqj9le2yPwHczF78ijqHzfW2xE+dtea1u/ylrXbKbp/ni3xa7GS5X/XfbVG9KJ+m
	3o0y7RGzZq2+ur5L9P7VnsVa/+xCbiRKrjq2XImlOCPRUIu5qDgRALvZA93uAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2013 07:30 PM, Joe Perches wrote:
> On Mon, 2013-07-29 at 19:22 -0600, Shuah Khan wrote:
>> Add tracing feature to iommu to report various iommu events. Classes
>> iommu_group, iommu_device, iommu_map_unmap, and iommu_amd_event are defined.
>
> Hi again Shuah
>
>> diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
> []
>> @@ -2159,6 +2160,15 @@ static int iommu_prepare_identity_map(struct pci_dev *pdev,
>>   	printk(KERN_INFO
>>   	       "IOMMU: Setting identity map for device %s [0x%Lx - 0x%Lx]\n",
>>   	       pci_name(pdev), start, end);
>> +
>> +	{
>> +		trace_amd_event("Event", 0x1, pdev->devfn, 0, start, 2);
>> +		trace_remove_device_from_group(0, &pdev->dev);
>> +		trace_attach_device_to_domain(&pdev->dev);
>> +		trace_detach_device_from_domain(&pdev->dev);
>> +		trace_map(start, end, 1024);
>> +		trace_unmap(start, end, 1024);
>> +	}
>
> Aren't these parentheses superfluous and
> so the indent too deep too?
>

Hi Joe,

That is the test code, I included by mistake. I had these changes 
sitting uncommitted in my tree for testing and I accidentally generated 
the patch with them. I am going to send a patch without this file.

I should remember to not rush things at the end of day and create noise. :(

-- Shuah

Shuah Khan, Linux Kernel Developer - Open Source Group Samsung Research 
America (Silicon Valley) shuah.kh@samsung.com | (970) 672-0658

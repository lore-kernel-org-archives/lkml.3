Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759674Ab3HNQGW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 12:06:22 -0400
Received: from mailout2.w2.samsung.com ([211.189.100.12]:56430 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974Ab3HNQGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 12:06:21 -0400
X-AuditID: cbfec37b-b7f306d0000047de-20-520baafb232f
Message-id: <520BAAF0.8000509@samsung.com>
Date: Wed, 14 Aug 2013 10:06:08 -0600
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623
 Thunderbird/17.0.7
MIME-version: 1.0
To: Joerg Roedel <joro@8bytes.org>
Cc: alex.williamson@redhat.com, Varun.Sethi@freescale.com, aik@ozlabs.ru,
        joe@perches.com, rostedt@goodmis.org, fweisbec@gmail.com,
        mingo@redhat.com, tony@atomide.com, ohad@wizery.com,
        andreas.herrmann@calxeda.com, will.deacon@arm.com,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        shuahkhan@gmail.com, Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCH v2] iommu: Add event tracing feature to iommu
References: <1375196229-2784-1-git-send-email-shuah.kh@samsung.com>
 <20130814141758.GN28811@8bytes.org>
In-reply-to: <20130814141758.GN28811@8bytes.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.21.63]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOIsWRmVeSWpSXmKPExsVy+t9hX93fq7iDDDY81bLoPV5k8e1/D5vF
	4iMxFjNfdzNZLNhvbTH7/mMWi87ZG9gtLu+aw2Zx6cACJovfq38wW+zreMBk8fWng8X+K14W
	M2+tYbF4+fEEiwO/x5OD85g81sxbw+jx7eskFo8Fn6+we/w73M/ksXPWXXaPln232D0m31jO
	6HHjbjObx5dV15g93u+7yubxeZOcx6dP+9gCeKO4bFJSczLLUov07RK4MubuW8xa8IOr4vSL
	k4wNjL84uhg5OSQETCS2bJvMBmGLSVy4tx7I5uIQEljGKPH+6jIWCKeXSeLzy5vsIFVCAhsZ
	JSbO9wGxeQW0JF4dP8EIYrMIqEocnj2ZGcRmE1CX+Px6B1S9nETTktVAcQ4OUYEIiaPLNSFa
	BSV+TL7HAmKLCChJXP/cygpiMwu8YZLovqAJUi4s4Cgx85IDxJRMiSvNG8GmcwoYSPw/38sC
	UW4tsXLSNkYIW15i85q3zBD1yhJ/Lp9iAhkjIaAosX211QRGkVlIFs9C0j0LSfcCRuZVjGKl
	xckFxUnpqRVGesWJucWleel6yfm5mxghkV29g/HuV5tDjAIcjEo8vBs6uIOEWBPLiitzDzFK
	cDArifCeAQnxpiRWVqUW5ccXleakFh9iZOLglGpgXOlvfkp6HV+uY2WD4cGpDzwVotP5pWfF
	5K19fTpx+nv9zPVVDWF/e6fs93UIv78oa9LJxWw5CgV1n1kPSoVOUY008Y+wZPaXaTjLMDvF
	sjBx5+2uzRtUHi6a9+776ktP6rosH3+MSImKmM3k+VpQadqjyXlujzfIHllpWNT3pTrYy3+B
	/3QzJZbijERDLeai4kQAvUk+I8oCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joerg,

Thanks for the feedback.

On 08/14/2013 08:17 AM, Joerg Roedel wrote:
> Hi Shuah,
>
> thanks for doing this. I have a few suggestions for improvements.
>
> On Tue, Jul 30, 2013 at 08:57:09AM -0600, Shuah Khan wrote:
>> iommu:add_device_to_group
>> iommu:remove_device_from_group
>> iommu:attach_device_to_domain
>> iommu:detach_device_from_domain
>> iommu:unmap
>> iommu:map
>
> Please send these events as seperate patches.

Is this what you have in mind or does my original patch set minus the 
amd_event and drivers/iommu/amd_iommu.c change?

Patch 1:
drivers/iommu/Makefile
drivers/iommu/iommu-traces.c
include/trace/events/iommu.h

One patch for each of the following events?

iommu:add_device_to_group
iommu:remove_device_from_group
iommu:attach_device_to_domain
iommu:detach_device_from_domain
iommu:unmap
iommu:map

>
>> iommu:amd_event
>
> This needs some more thought. For now I would prefer an event in the
> generic report_iommu_fault() routine to report page-faults from all IOMMUs
> that support this.
>

I see what you are saying. Adding event to report_iommu_fault() would 
cover all IOMMUs. I would like to work on adding an event unless you 
already have it in works.

-- Shuah


Shuah Khan
Sr. Linux Kernel Developer
Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658

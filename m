Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932410Ab3DBOpL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 10:45:11 -0400
Received: from va3ehsobe010.messaging.microsoft.com ([216.32.180.30]:54356
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932353Ab3DBOpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 10:45:06 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zzbb2dI98dI9371I1432Izz1f42h1fc6h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bhz2dh668h839h947hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h190ch1946h19b4h19c3h1ad9h1b0ah1155h)
X-WSS-ID: 0MKMUAV-01-GMW-02
X-M-MSG: 
Message-ID: <515AEEE7.40903@amd.com>
Date: Tue, 2 Apr 2013 09:44:55 -0500
From: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] iommu/amd: Add IOMMU event log injection interface
 for testing event flag decoding logic
References: <1364428294-2579-1-git-send-email-suravee.suthikulpanit@amd.com> <20130402143521.GC15687@8bytes.org>
In-Reply-To: <20130402143521.GC15687@8bytes.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/2/2013 9:35 AM, Joerg Roedel wrote:
> On Wed, Mar 27, 2013 at 06:51:34PM -0500, suravee.suthikulpanit@amd.com wrote:
>> From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
>>
>> Add IOMMU event log injection interface for testing event flag decoding logic.
>> This interface allows users to specify device id, event flag, and event types via debugfs.
>>
>> echo 0x300 > /sys/kernel/debug/amd-iommu-evninj/devid // (e.g. Bus:Dev.fun 3:0.0)
>> echo 0xfff > /sys/kernel/debug/amd-iommu-evninj/flags // (e.g. Specify flag value)
>> echo 2 > /sys/kernel/debug/amd-iommu-evninj/type      // (e.g. for IO_PAGE_FAULT event)
>>
>> Once the event is injected, IOMMU driver will parse and print out the event information
>> in kernel log (dmesg) with the various information depending on the types of event and flag
>> specified.
> Why is this needed? I think the risk of regressions in the
> event-handling code is to low to justify the need for an event-injection
> mechanism.
You are right, it is not needed.  I create this interface to provide a 
way for reviewers to test out how the report will be generated for each 
type of events/errors.

Suravee
>
> 	Joerg
>
>
>



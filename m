Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757648Ab3ENOhb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 10:37:31 -0400
Received: from co9ehsobe005.messaging.microsoft.com ([207.46.163.28]:39594
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755561Ab3ENOha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 10:37:30 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zzbb2dI98dI9371I1102Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2dh668h839h947hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah1d0ch1d2eh1d3fh1155h)
X-WSS-ID: 0MMSLY8-02-4S0-02
X-M-MSG: 
Message-ID: <51924C21.3020906@amd.com>
Date: Tue, 14 May 2013 09:37:21 -0500
From: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: <steven.kinney@amd.com>, <linux-kernel@vger.kernel.org>,
        <mingo@redhat.com>, <iommu@lists.linux-foundation.org>,
        <joro@8bytes.org>
Subject: Re: [PATCH 1/2] IOMMU/AMD: Adding IOMMU PC resource management
References: <1368481424-5626-1-git-send-email-steven.kinney@amd.com> <20130514070924.GA15942@dyad.programming.kicks-ass.net>
In-Reply-To: <20130514070924.GA15942@dyad.programming.kicks-ass.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/14/2013 2:09 AM, Peter Zijlstra wrote:
> On Mon, May 13, 2013 at 04:43:44PM -0500, steven.kinney@amd.com wrote:
>> +static void init_iommu_perf_ctr(struct amd_iommu *iommu)
>> +{
>> +	u32 val = 0xabcd, val2 = 0;
>> +
>> +	if (!iommu_feature(iommu, FEATURE_PC))
>> +		return;
>> +
>> +	amd_iommu_pc_present = true;
>> +
>> +	/* Check if the performance counters can be written to */
>> +	if ((0 != amd_iommu_pc_get_set_reg_val(0, 0, 0, 0, &val, true)) ||
>> +	    (0 != amd_iommu_pc_get_set_reg_val(0, 0, 0, 0, &val2, false)) ||
>> +	    (val != val2)) {
>> +		pr_err("AMD-Vi: Unable to write to IOMMU perf counter.\n");
> Would it make sense to clear amd_iommu_pc_present here?
Yes, I'll take care of this here.

Thank you,

Surave


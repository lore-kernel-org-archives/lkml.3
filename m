Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751685AbaK1QHi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 11:07:38 -0500
Received: from mga02.intel.com ([134.134.136.20]:27115 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968AbaK1QHg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 11:07:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="491186485"
Message-ID: <54789DC1.7050003@linux.intel.com>
Date: Sat, 29 Nov 2014 00:07:29 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: tip-bot for Jiang Liu <tipbot@zytor.com>,
        linux-tip-commits@vger.kernel.org, mingo@kernel.org,
        rdunlap@infradead.org, bhelgaas@google.com, hpa@zytor.com,
        tony.luck@intel.com, rjw@rjwysocki.net, grant.likely@linaro.org,
        konrad.wilk@oracle.com, gregkh@linuxfoundation.org, tglx@linutronix.de,
        yinghai@kernel.org, joro@8bytes.org, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org, jroedel@suse.de
Subject: Re: [tip:x86/apic] x86, irq: Use cached IOAPIC entry instead of reading
 from hardware
References: <1416901802-24211-30-git-send-email-jiang.liu@linux.intel.com> <tip-fda7c08b1349cc4c65f8a5240b10f7e9938604b8@git.kernel.org> <20141127193213.GB4190@pd.tnic> <5477DE90.5090500@linux.intel.com> <20141128113358.GB30997@pd.tnic> <20141128115306.GC30997@pd.tnic> <54789774.7030704@linux.intel.com>
In-Reply-To: <54789774.7030704@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/11/28 23:40, Jiang Liu wrote:
> On 2014/11/28 19:53, Borislav Petkov wrote:
>> On Fri, Nov 28, 2014 at 12:33:58PM +0100, Borislav Petkov wrote:
>>> On Fri, Nov 28, 2014 at 10:31:44AM +0800, Jiang Liu wrote:
>>>> 	Thanks for tracking down to this line of change. I have no
>>>> platform to reproduce this bug, so could you please help to revert this
>>>> commit and apply following patch to get some data about IOAPIC entry?
>>>
<snit>
>>
>> Ok, so this is interesting: the cached data has bit 16 set which,
>> AFAICT, is in one of those io redirection table registers. That bit
>> masks out interrupts and if set, those get ignored. Which would explain
>> the timeoutting of the ATA commands because the IRQ is masked.
>>
>> I don't know, though, why your cached data has bit 16 set....
> Hi Borislav,
> 	Sorry, my previous test patch has some issue, but I think I
> should have found the root cause now. Could you please try following
> patch directly on top of tip/master without reverting any patch?
Hi Borislav,
	With this patch applied, KVM with SMP kernel boots successfully
now:)
Regards!
Gerry


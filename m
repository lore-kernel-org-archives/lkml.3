Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753675AbaIOQcd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 12:32:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13186 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752769AbaIOQcc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 12:32:32 -0400
Message-ID: <54171485.5010803@redhat.com>
Date: Mon, 15 Sep 2014 12:32:05 -0400
From: Jon Masters <jcm@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: "dma-coherent" property inheritance (arm vs arm64)
References: <5414FF8F.5040409@redhat.com> <20140915155216.GG5415@arm.com>
In-Reply-To: <20140915155216.GG5415@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/15/2014 11:52 AM, Catalin Marinas wrote:
> Hi Jon,
> 
> On Sun, Sep 14, 2014 at 03:38:07AM +0100, Jon Masters wrote:
>> commit 6ecba8eb51b7d23fda66388a5420be7d8688b186
>> Author: Catalin Marinas <catalin.marinas@arm.com>
>> Date:   Fri Apr 25 15:31:45 2014 +0100
>>
>>     arm64: Use bus notifiers to set per-device coherent DMA ops
>>
>> Thus at this point, on 32-bit systems, we have defined this function:
>>
>> 	set_arch_dma_coherent_ops
> 
> It was a timing issue that they are not in sync. I would have used
> set_arch_dma_coherent_ops() but it wasn't very clear when it gets merged
> and changing the default on arm64 broke some other assumptions, so a
> temporary fix.

Ok. So arm64 will automatically switch over to set_arch_dma_coherent_ops
(once it's there, it will be called automatically anyway because it's in
the callchain anyway already).

For the moment, on our internal PCI trees, we'll add a notifier and wait
for upstream to get PCI support and figure this out as part of that
activity. In the case of ACPI, I'm still pushing for _CCA methods to be
added by default because it makes sense to be verbose in describing
platform hardware devices, even in spite of default.

Jon.


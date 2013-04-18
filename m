Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586Ab3DRS6j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 14:58:39 -0400
Received: from [216.32.180.13] ([216.32.180.13]:17974 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750958Ab3DRS6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 14:58:38 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zzbb2dI98dI9371I1432Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzzz2dh668h839h947hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h190ch1946h19b4h19c3h1ad9h1b0ah1155h)
X-WSS-ID: 0MLGSMJ-01-GBI-02
X-M-MSG: 
Message-ID: <517041EA.70407@amd.com>
Date: Thu, 18 Apr 2013 13:56:42 -0500
From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2 V2] iommu/amd: Add workaround for ERBT1312
References: <1366009666-44792-1-git-send-email-suravee.suthikulpanit@amd.com> <20130418160220.GA4153@8bytes.org> <51701B9F.10003@amd.com> <20130418162856.GA13891@8bytes.org> <5170268E.8080706@amd.com> <20130418183538.GA17148@8bytes.org>
In-Reply-To: <20130418183538.GA17148@8bytes.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/18/2013 1:35 PM, Joerg Roedel wrote:
> On Thu, Apr 18, 2013 at 11:59:58AM -0500, Suthikulpanit, Suravee wrote:
>> One last concern I have for this patch is the case when we re-enable
>> the interrupt, then another interrupt happens while we processing
>> the log and set the bit.  If the interrupt thread doesn't check this
>> right before the thread exits the handler.  We could still end up
>> leaving the interrupt disabled.
> That can't happen, the patch checks whether the bit is really 0 and then
> it processes the event/ppr-log entries. If any new entry is queued while
> we process the logs another interrupt will be fired and the irq-thread
> will run again. So we will not miss any log entry.
According to the "kernel/irq/handle.c:irq_wake_thread()", I thought that 
for the threaded IRQ, if the system getting a new interrupt from the 
device while the thread is running, it will just return and do nothing.

Suravee

> 	Joerg
>
>
>



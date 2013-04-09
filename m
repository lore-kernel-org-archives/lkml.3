Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934936Ab3DIOXH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 10:23:07 -0400
Received: from co9ehsobe004.messaging.microsoft.com ([207.46.163.27]:27966
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762631Ab3DIOXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 10:23:05 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zzbb2dI98dI9371I1432Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzzz2dh668h839h947he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah1889i1155h)
X-WSS-ID: 0MKZRY5-02-O1U-02
X-M-MSG: 
Message-ID: <51642442.7090908@amd.com>
Date: Tue, 9 Apr 2013 09:22:58 -0500
From: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] iommu/amd: Add workaround to propery clearing IOMMU status
 register
References: <1365031144-2543-1-git-send-email-suravee.suthikulpanit@amd.com> <20130409094929.GE6858@8bytes.org>
In-Reply-To: <20130409094929.GE6858@8bytes.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/9/2013 4:49 AM, Joerg Roedel wrote:
> On Wed, Apr 03, 2013 at 06:19:04PM -0500, Suthikulpanit, Suravee wrote:
>> In the system with multiple IOMMU,this handling scheme complicates the
>> synchronization of the IOMMU data structures and status registers as
>> there could be multiple threads competing for the same IOMMU while
>> the other IOMMU could be left unhandled.
> I really like that change in the interrupt handling code to pull the
> different IOMMUs independently. But its problematic to change that in
> the same patch that adds an erratum workaround.
>
> Please move that erratum fix into a seperate small patch that we can
> backport to -stable and resend.
>
>
> 	Joerg
Joerg,

The reason I implemented the "per-thread IOMMU handling" and the 
"workaround" together in one patch
is because it simplifies the synchronization of clearing and checking 
the interrupt enabling bits.
In the previous implementation, we could end up having multiple threads 
trying to access the status register
at the same time.

Suravee
>
>



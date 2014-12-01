Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658AbaLAGca (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 01:32:30 -0500
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:51668 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546AbaLAGc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 01:32:28 -0500
Message-ID: <547C0B4A.4060303@hp.com>
Date: Mon, 01 Dec 2014 14:31:38 +0800
From: "Li, ZhenHua" <zhen-hual@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: Takao Indoh <indou.takao@jp.fujitsu.com>, bhe@redhat.com,
        dwmw2@infradead.org, vgoyal@redhat.com, dyoung@redhat.com,
        iommu@lists.linux-foundation.org, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        alex.williamson@redhat.com, ddutile@redhat.com,
        ishii.hironobu@jp.fujitsu.com, bhelgaas@google.com, doug.hatch@hp.com,
        jerry.hoemann@hp.com, tom.vaden@hp.com, li.zhang6@hp.com,
        lisa.mitchell@hp.com
Subject: Re: [PATCH 0/5] iommu/vt-d: Fix crash dump failure caused by legacy
 DMA/IO
References: <1413878659-1383-1-git-send-email-zhen-hual@hp.com> <20141022100525.GD9060@dhcp-16-116.nay.redhat.com> <545ACF66.9050509@jp.fujitsu.com> <545AD061.4000102@hp.com> <545AD353.8060207@jp.fujitsu.com> <545AD8D3.90709@hp.com> <545B2885.8070009@jp.fujitsu.com> <545B2C07.1070701@hp.com> <5465A0E0.4020001@hp.com> <20141117133858.GA31920@8bytes.org>
In-Reply-To: <20141117133858.GA31920@8bytes.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg,

After I implement these two steps, there comes a new fault:

[1.594890] dmar: DRHD: handling fault status reg 2
[1.594894] dmar: INTR-REMAP: Request device [[41:00.0] fault index 4d
[1.594894] INTR-REMAP:[fault reason 34] Present field in the IRTE entry
is clear

It is caused by similar reason, so I will fix it like fixing the DMAR
faults: Do NOT disable and re-enable the interrupt remapping, try to
use data from old kernel.


Thanks
Zhenhua

On 11/17/2014 09:38 PM, Joerg Roedel wrote:
> On Fri, Nov 14, 2014 at 02:27:44PM +0800, Li, ZhenHua wrote:
>> I am working following  your directions:
>>
>> 1.  If the VT-d driver finds the IOMMU enabled, it reuses its root entry
>> table, and do NOT disable-enable iommu. Other data will be copied.
>>
>> 2. When a device driver issues the first dma_map command for a
>> device, we assign a new and empty page-table, thus removing all
>> mappings from the old kernel for the device.
>>
>> Please let me know if I get something wrong.
>
> Yes, this sounds right. Happily waiting for patches :)
>
>
> 	Joerg
>


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181AbaBSQXE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 11:23:04 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:43928 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753654AbaBSQXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 11:23:01 -0500
Message-ID: <5304DABD.9000605@oracle.com>
Date: Wed, 19 Feb 2014 11:24:29 -0500
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Alexander Gordeev <agordeev@redhat.com>
CC: linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>, linux-pci@vger.kernel.org
Subject: Re: [PATCH] xen-pciback: Use pci_enable_msix_range() instead of pci_enable_msix()
References: <1392804931-30671-10-git-send-email-agordeev@redhat.com> <5304CC49.7020000@oracle.com> <5304D063.90000@oracle.com> <20140219160501.GA32067@dhcp-26-207.brq.redhat.com>
In-Reply-To: <20140219160501.GA32067@dhcp-26-207.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2014 11:05 AM, Alexander Gordeev wrote:
> On Wed, Feb 19, 2014 at 10:40:19AM -0500, Boris Ostrovsky wrote:
>>>> diff --git a/drivers/xen/xen-pciback/pciback_ops.c
>>>> b/drivers/xen/xen-pciback/pciback_ops.c
>>>> index 64eb0cd..f5b4c3e 100644
>>>> --- a/drivers/xen/xen-pciback/pciback_ops.c
>>>> +++ b/drivers/xen/xen-pciback/pciback_ops.c
>>>> @@ -213,9 +213,15 @@ int xen_pcibk_enable_msix(struct
>>>> xen_pcibk_device *pdev,
>>>>           entries[i].vector = op->msix_entries[i].vector;
>>>>       }
>>>>   -    result = pci_enable_msix(dev, entries, op->value);
>>>> +    result = pci_enable_msix_range(dev, entries, op->value, op->value);
>>>> +    if (result < op->value) {
>>>
>>> I think it would be better to have 'if (result != op->value)', in
>>> case op->value is negative (which presumably it should never be).
>>
>> Better yet, at the top of the routine we check 'if (op->value >
>> SH_INFO_MAX_VEC)'. If you add '|| op->value < 0' we'd be all set.
> xen_pci_op::value is uint32_t

Ah, OK --- then 'if (op->value > SH_INFO_MAX_VEC)' alone will catch this 
(hopefully its' not in billions).

Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>


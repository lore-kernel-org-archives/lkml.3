Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962Ab3GHHb6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 03:31:58 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:44376 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045Ab3GHHb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 03:31:57 -0400
Message-ID: <51DA6AE6.9040201@ozlabs.ru>
Date: Mon, 08 Jul 2013 17:31:50 +1000
From: Alexey Kardashevskiy <aik@ozlabs.ru>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: linuxppc-dev@lists.ozlabs.org, Paul Mackerras <paulus@samba.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] powerpc: add real mode support for dma operations
 on powernv
References: <1373123227-22969-6-git-send-email-aik@ozlabs.ru>  <1373258669-3130-1-git-send-email-aik@ozlabs.ru> <1373268055.4446.31.camel@pasglop>
In-Reply-To: <1373268055.4446.31.camel@pasglop>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/2013 05:20 PM, Benjamin Herrenschmidt wrote:
> On Mon, 2013-07-08 at 14:44 +1000, Alexey Kardashevskiy wrote:
> 
>> diff --git a/arch/powerpc/platforms/powernv/pci.h b/arch/powerpc/platforms/powernv/pci.h
>> index 25d76c4..7ea82c1 100644
>> --- a/arch/powerpc/platforms/powernv/pci.h
>> +++ b/arch/powerpc/platforms/powernv/pci.h
>> @@ -52,6 +52,7 @@ struct pnv_ioda_pe {
>>  	int			tce32_seg;
>>  	int			tce32_segcount;
>>  	struct iommu_table	tce32_table;
>> +	phys_addr_t		it_index_rm;
> 
> Please ....
> 
> The fact that we hijack the it_index field of the iommu table
> for the virtual address is bad enough, but really don't need
> to perpetuate this :-)
> 
> Call the field something decent such as "tce_inval_reg_phys"


Yes we can. I just find it veeeeeeery attractive when I can grep "\<it_"
and get all users of iommu_table.

btw is phys_addr_t correct here?


-- 
Alexey

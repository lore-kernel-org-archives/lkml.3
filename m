Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159Ab3FKXs1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 19:48:27 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36997 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686Ab3FKXsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 19:48:25 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.9
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-2
Message-ID: <51B7B728.9000803@jp.fujitsu.com>
Date: Wed, 12 Jun 2013 08:47:52 +0900
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Michael Holzheu <holzheu@linux.vnet.ibm.com>
CC: Vivek Goyal <vgoyal@redhat.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, kexec@lists.infradead.org,
        Jan Willeke <willeke@de.ibm.com>, linux-kernel@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH v5 5/5] s390/vmcore: Use vmcore for zfcpdump
References: <1370624161-2298-1-git-send-email-holzheu@linux.vnet.ibm.com> <1370624161-2298-6-git-send-email-holzheu@linux.vnet.ibm.com>
In-Reply-To: <1370624161-2298-6-git-send-email-holzheu@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/06/08 1:56), Michael Holzheu wrote:
<cut>
> @@ -82,6 +116,43 @@ int remap_oldmem_pfn_range(struct vm_area_struct *vma, unsigned long from,
>   }
>
>   /*
> + * Remap "oldmem" for zfcpdump
> + *
> + * We only map available memory above ZFCPDUMP_HSA_SIZE. Memory below
> + * ZFCPDUMP_HSA_SIZE is read on demand using the copy_oldmem_page() function.
> + */
> +static int remap_oldmem_pfn_range_zfcpdump(struct vm_area_struct *vma,
> +					   unsigned long from,
> +					   unsigned long pfn,
> +					   unsigned long size, pgprot_t prot)
> +{
> +	unsigned long size_hsa;
> +
> +	if (pfn < ZFCPDUMP_HSA_SIZE >> PAGE_SHIFT) {
> +		size_hsa = min(size, OLDMEM_SIZE - (pfn << PAGE_SHIFT));

ZFCPDUMP_HSA_SIZE?

-- 
Thanks.
HATAYAMA, Daisuke


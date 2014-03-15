Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755581AbaCOTZq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 15:25:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1108 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750900AbaCOTZp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 15:25:45 -0400
Message-ID: <5324A92A.3040309@redhat.com>
Date: Sat, 15 Mar 2014 15:25:30 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        benh@kernel.crashing.org, paulus@samba.org
CC: linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powerpc/mm: Make sure a local_irq_disable prevent a parallel
 THP split
References: <1394880478-770-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
In-Reply-To: <1394880478-770-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15/2014 06:47 AM, Aneesh Kumar K.V wrote:
> From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
> 
> We have generic code like the one in get_futex_key that assume that
> a local_irq_disable prevents a parallel THP split. Support that by
> adding a dummy smp call function after setting _PAGE_SPLITTING. Code
> paths like get_user_pages_fast still need to check for _PAGE_SPLITTING
> after disabling IRQ which indicate that a parallel THP splitting is
> ongoing. Now if they don't find _PAGE_SPLITTING set, then we can be
> sure that parallel split will now block in pmdp_splitting flush
> until we enables IRQ
> 
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed

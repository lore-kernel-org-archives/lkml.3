Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932339AbaHODA5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 23:00:57 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:62742 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754945AbaHODAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 23:00:55 -0400
Message-ID: <53ED77DB.8010103@ozlabs.ru>
Date: Fri, 15 Aug 2014 13:00:43 +1000
From: Alexey Kardashevskiy <aik@ozlabs.ru>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Alexander Graf <agraf@suse.de>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Gleb Natapov <gleb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Michael Ellerman <mpe@ellerman.id.au>, kvm-ppc@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [PATCH v2] PC, KVM, CMA: Fix regression caused by wrong get_order()
 use
References: <1407992587-9164-1-git-send-email-aik@ozlabs.ru> <87egwj64bz.fsf@linux.vnet.ibm.com> <53ECBC6B.5030507@suse.de>
In-Reply-To: <53ECBC6B.5030507@suse.de>
Content-Type: text/plain; charset=koi8-r
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2014 11:40 PM, Alexander Graf wrote:
> 
> On 14.08.14 07:13, Aneesh Kumar K.V wrote:
>> Alexey Kardashevskiy <aik@ozlabs.ru> writes:
>>
>>> fc95ca7284bc54953165cba76c3228bd2cdb9591 claims that there is no
>>> functional change but this is not true as it calls get_order() (which
>>> takes bytes) where it should have called ilog2() and the kernel stops
>>> on VM_BUG_ON().
>>>
>>> This replaces get_order() with order_base_2() (round-up version of ilog2).
>>>
>>> Suggested-by: Paul Mackerras <paulus@samba.org>
>>> Cc: Alexander Graf <agraf@suse.de>
>>> Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
>>> Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
>>> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>>> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
>> Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> 
> So this affects 3.17?

Yes.


-- 
Alexey

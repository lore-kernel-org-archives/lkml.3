Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996Ab3CRMnJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 08:43:09 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:56641 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561Ab3CRMnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 08:43:07 -0400
Message-ID: <51470BA1.3060601@linux.vnet.ibm.com>
Date: Mon, 18 Mar 2013 20:42:09 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 4/5] KVM: MMU: store generation-number into mmio spte
References: <51433D98.4050605@linux.vnet.ibm.com> <51433E43.60900@linux.vnet.ibm.com> <5146F830.1070602@redhat.com>
In-Reply-To: <5146F830.1070602@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 13031812-3568-0000-0000-0000034E00B3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/2013 07:19 PM, Paolo Bonzini wrote:
> Il 15/03/2013 16:29, Xiao Guangrong ha scritto:
>> +/*
>> + * spte bits of bit 3 ~ bit 11 are used as low 9 bits of
>> + * generation, the bits of bits 52 ~ bit 61 are used as
>> + * high 12 bits of generation.
>> + */
> 
> High 10 bits.

Yes, i forgot to update the comments! Thank you, Paolo!

> 
> How often does the generation number change?  Especially with Takuya's
> patches, using just 10 bits for the generation might be enough and
> simplifies the code.

I guess it's only updated when guest is initializing and doing hotplug.
In my origin thought, if the number is big enough that it could not
round on all most case of hotplug, the things introduced by Takuya is
not necessary. But, if you guys want to keep the things, 10 bits should
be enough. :)


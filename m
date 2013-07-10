Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493Ab3GJKwJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 06:52:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52222 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754033Ab3GJKwI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 06:52:08 -0400
Subject: Re: [PATCH 3/4] PF: Provide additional direct page notification
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=us-ascii
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <20130710104843.GS24941@redhat.com>
Date: Wed, 10 Jul 2013 12:52:06 +0200
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
        Dominik Dingel <dingel@linux.vnet.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        Xiantao Zhang <xiantao.zhang@intel.com>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Ralf Baechle <ralf@linux-mips.org>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <A0CAE7A6-9615-4513-B4F3-35D394D2E32B@suse.de>
References: <1373378207-10451-1-git-send-email-dingel@linux.vnet.ibm.com> <1373378207-10451-4-git-send-email-dingel@linux.vnet.ibm.com> <51DC33E7.1030404@de.ibm.com> <282EB214-206B-4A04-9830-D97679C9F4EC@suse.de> <20130710104253.GQ24941@redhat.com> <13B3500B-18A9-4B97-8C85-597BEAFC9250@suse.de> <20130710104843.GS24941@redhat.com>
To: Gleb Natapov <gleb@redhat.com>
X-Mailer: Apple Mail (2.1278)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 10.07.2013, at 12:48, Gleb Natapov wrote:

> On Wed, Jul 10, 2013 at 12:45:59PM +0200, Alexander Graf wrote:
>> 
>> On 10.07.2013, at 12:42, Gleb Natapov wrote:
>> 
>>> On Wed, Jul 10, 2013 at 12:39:01PM +0200, Alexander Graf wrote:
>>>> 
>>>> On 09.07.2013, at 18:01, Christian Borntraeger wrote:
>>>> 
>>>>> On 09/07/13 15:56, Dominik Dingel wrote:
>>>>>> By setting a Kconfig option, the architecture can control when
>>>>>> guest notifications will be presented by the apf backend.
>>>>>> So there is the default batch mechanism, working as before, where the vcpu thread
>>>>>> should pull in this information. On the other hand there is now the direct
>>>>>> mechanism, this will directly push the information to the guest.
>>>>>> 
>>>>>> Still the vcpu thread should call check_completion to cleanup leftovers,
>>>>>> that leaves most of the common code untouched.
>>>>>> 
>>>>>> Signed-off-by: Dominik Dingel <dingel@linux.vnet.ibm.com>
>>>>> 
>>>>> Acked-by: Christian Borntraeger <borntraeger@de.ibm.com> 
>>>>> for the "why". We want to use the existing architectured interface.
>>>> 
>>>> Shouldn't this be a runtime option?
>>>> 
>>> Why? What is the advantage of using sync delivery when HW can do it
>>> async?
>> 
>> What's the advantage of having an option at all then? Who selects it?
>> 
> x86 is stupid and cannot deliver the even asynchronously. Platform that
> can do it select the option.

We're in generic code. S390x enables it. X86 does not. That was the missing link!

Thanks a lot and sorry for the fuss :).


Alex


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756556Ab3INMWY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 08:22:24 -0400
Received: from inca-roads.misterjones.org ([213.251.177.50]:50638 "EHLO
	inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752746Ab3INMWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 08:22:23 -0400
To: Alexander Graf <agraf@suse.de>
Subject: Re: [PATCH 1/3] arm: kvm: clamp =?UTF-8?Q?NR=5FVCPUS=20to=20MAX?=  =?UTF-8?Q?=5FVCPUS?=
X-PHP-Originating-Script: 0:main.inc
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Sat, 14 Sep 2013 13:22:16 +0100
From: Marc Zyngier <marc.zyngier@arm.com>
Cc: Andrew Jones <drjones@redhat.com>, <linux@arm.linux.org.uk>,
        <kvm@vger.kernel.org>, <catalin.marinas@arm.com>,
        <will.deacon@arm.com>, <linux-kernel@vger.kernel.org>,
        <pbonzini@redhat.com>, <kvmarm@lists.cs.columbia.edu>,
        <linux-arm-kernel@lists.infradead.org>
Organization: ARM Ltd
In-Reply-To: <AC39CB35-1EE1-49DE-A2E4-F544699A516B@suse.de>
References: <1379160656-28050-1-git-send-email-drjones@redhat.com>
 <1379160656-28050-2-git-send-email-drjones@redhat.com>
 <AC39CB35-1EE1-49DE-A2E4-F544699A516B@suse.de>
Message-ID: <8f88d4700b5f84c6fb92a0fa1dff6314@www.loen.fr>
User-Agent: Roundcube Webmail/0.7.2
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: agraf@suse.de, drjones@redhat.com, linux@arm.linux.org.uk, kvm@vger.kernel.org, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: marc.zyngier@arm.com
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-09-14 13:14, Alexander Graf wrote:
> Am 14.09.2013 um 07:10 schrieb Andrew Jones <drjones@redhat.com>:
>
>> Signed-off-by: Andrew Jones <drjones@redhat.com>
>> ---
>> arch/arm/kvm/arm.c | 2 +-
>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
>> index 741f66a2edbd7..9ebf8ac3a12ff 100644
>> --- a/arch/arm/kvm/arm.c
>> +++ b/arch/arm/kvm/arm.c
>> @@ -201,7 +201,7 @@ int kvm_dev_ioctl_check_extension(long ext)
>>        r = 1;
>>        break;
>>    case KVM_CAP_NR_VCPUS:
>> -        r = num_online_cpus();
>> +        r = min(num_online_cpus(), KVM_MAX_VCPUS);
>
> Is there any real reason to prohibit overcommit?

I don't think this affects overcommit. This is the "recommended" limit, 
and you can still go up to KVM_MAX_CPUS.

         M.
-- 
Fast, cheap, reliable. Pick two.

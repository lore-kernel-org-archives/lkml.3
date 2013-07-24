Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752391Ab3GXHG6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 03:06:58 -0400
Received: from mail-ye0-f180.google.com ([209.85.213.180]:33696 "EHLO
	mail-ye0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153Ab3GXHG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 03:06:56 -0400
Message-ID: <51EF7CFB.8030104@redhat.com>
Date: Wed, 24 Jul 2013 09:06:35 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Jason Wang <jasowang@redhat.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, KY Srinivasan <kys@microsoft.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>, "gleb@redhat.com" <gleb@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] x86: properly handle kvm emulation of hyperv
References: <1374572465-15278-1-git-send-email-jasowang@redhat.com> <1374572465-15278-4-git-send-email-jasowang@redhat.com> <bd93bc49300a4d99996cc4f57c19a008@SN2PR03MB061.namprd03.prod.outlook.com> <51EE97BD.4050402@zytor.com> <51EF59FB.8040207@redhat.com> <51EF5C9C.6070403@zytor.com> <51EF7A2A.6040003@redhat.com>
In-Reply-To: <51EF7A2A.6040003@redhat.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 24/07/2013 08:54, Jason Wang ha scritto:
> On 07/24/2013 12:48 PM, H. Peter Anvin wrote:
>> On 07/23/2013 09:37 PM, Jason Wang wrote:
>>> On 07/23/2013 10:48 PM, H. Peter Anvin wrote:
>>>> On 07/23/2013 06:55 AM, KY Srinivasan wrote:
>>>>> This strategy of hypervisor detection based on some detection order IMHO is not
>>>>> a robust detection strategy. The current scheme works since the only hypervisor emulated
>>>>> (by other hypervisors happens to be Hyper-V). What if this were to change.
>>>>>
>>>> One strategy would be to pick the *last* one in the CPUID list, since
>>>> the ones before it are logically the one(s) being emulated...
>>>>
>>>> 	-hpa
>>>>
>>> How about simply does a reverse loop from 0x40010000 to 0x40010000?
>>>
>> Not all systems like being poked too far into hyperspace.  Just remember
>> the last match and walk the list.
>>
>> 	-hpa
>>
> 
> Ok, but it raises a question - how to know it was the 'last' match
> without knowing all signatures of other hyper-visor?

You can return a "priority" value from the .detect function.  The
priority value can simply be the CPUID leaf where the signature was
found (or a low value such as 1 if detection was done with DMI).

Then you can pick the hypervisor with the highest priority instead of
hard-coding the order.

Paolo

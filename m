Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751683Ab3J3Pi6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 11:38:58 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:38699 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724Ab3J3Pi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 11:38:56 -0400
Message-ID: <5271284A.6000002@linux.vnet.ibm.com>
Date: Wed, 30 Oct 2013 21:09:54 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Tim Gardner <tim.gardner@canonical.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Gleb Natapov <gleb@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, KVM list <kvm@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 3.12-rc7] KVM: Fix modprobe failure for kvm_intel/kvm_amd
References: <1383059634-55512-1-git-send-email-tim.gardner@canonical.com> <CA+55aFwUdXp4412F5LdmCRrGZCYiFpiPk7oksGi30CzP6i5O+w@mail.gmail.com> <52700C24.9050001@linux.vnet.ibm.com> <CA+55aFzqumDX8hRyC4avbpA2g_RRb28ZPYk=_-4atGJ=67Zu1A@mail.gmail.com> <52711121.9030606@linux.vnet.ibm.com> <20131030142359.GA32196@kroah.com>
In-Reply-To: <20131030142359.GA32196@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13103015-1618-0000-0000-000004E4F861
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30/2013 07:53 PM, Greg KH wrote:
[...]
>>
>> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
>> index a0e2a8a..e475fdb 100644
>> --- a/arch/x86/kernel/kvm.c
>> +++ b/arch/x86/kernel/kvm.c
>> @@ -622,7 +622,7 @@ static int __init kvm_spinlock_debugfs(void)
>>
>>   	d_kvm = kvm_init_debugfs();
>>   	if (d_kvm == NULL)
>> -		return -ENOMEM;
>> +		return -EEXIST;
>
> Why even error out at all here?  You should never care about debugfs
> file creation return values, so why pass any error back up the stack?

We could change this to return 0, but we will still be left with
kvm_main.c: kvm_init_debug() function which creates the kvm  debugfs
directory. (I thought Paolo and Gleb's ack would be needed for
that change since it would be a bigger decision for me)

So I just made the patch to fix only Linus's concern.

But sorry that I did not make that explicit. (infact module insertion 
error was because of successful creation of kvm directory in above code
and then error coming from kvm_init_debug() in kvm_main.c).


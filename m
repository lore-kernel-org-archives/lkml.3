Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142Ab3J3Pqw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 11:46:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42747 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750735Ab3J3Pqv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 11:46:51 -0400
Message-ID: <527129D4.3010308@redhat.com>
Date: Wed, 30 Oct 2013 16:46:28 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130923 Thunderbird/17.0.9
MIME-Version: 1.0
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
CC: Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tim Gardner <tim.gardner@canonical.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Gleb Natapov <gleb@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 3.12-rc7] KVM: Fix modprobe failure for kvm_intel/kvm_amd
References: <1383059634-55512-1-git-send-email-tim.gardner@canonical.com> <CA+55aFwUdXp4412F5LdmCRrGZCYiFpiPk7oksGi30CzP6i5O+w@mail.gmail.com> <52700C24.9050001@linux.vnet.ibm.com> <CA+55aFzqumDX8hRyC4avbpA2g_RRb28ZPYk=_-4atGJ=67Zu1A@mail.gmail.com> <52711121.9030606@linux.vnet.ibm.com> <20131030142359.GA32196@kroah.com> <5271284A.6000002@linux.vnet.ibm.com>
In-Reply-To: <5271284A.6000002@linux.vnet.ibm.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 30/10/2013 16:39, Raghavendra K T ha scritto:
>>
>> Why even error out at all here?  You should never care about debugfs
>> file creation return values, so why pass any error back up the stack?
> 
> We could change this to return 0, but we will still be left with
> kvm_main.c: kvm_init_debug() function which creates the kvm  debugfs
> directory. (I thought Paolo and Gleb's ack would be needed for
> that change since it would be a bigger decision for me)
> 
> So I just made the patch to fix only Linus's concern.

Even if it is okay to exit and not create the files (and I think it's a
bit surprising), I'd like at least a printk to signal what's happening.
 But there should be no reason for debugfs directory creation to fail in
the end, except for basic mistakes such as the one that Tim reported, so
I think it's better to report the failure.

> But sorry that I did not make that explicit. (infact module insertion
> error was because of successful creation of kvm directory in above code
> and then error coming from kvm_init_debug() in kvm_main.c).

Yes, and I'm keeping the error reporting there too, while fixing the
bogus EFAULT.

Paolo

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954Ab3HEOd7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 10:33:59 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:47563 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753825Ab3HEOd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 10:33:57 -0400
Message-ID: <51FFB937.6050003@linux.vnet.ibm.com>
Date: Mon, 05 Aug 2013 20:09:51 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@redhat.com>
CC: Ingo Molnar <mingo@kernel.org>, mingo@redhat.com, x86@kernel.org,
        tglx@linutronix.de, jeremy@goop.org,
        konrad wilk <konrad.wilk@oracle.com>, hpa@zytor.com,
        linux-doc@vger.kernel.org, habanero@linux.vnet.ibm.com,
        xen-devel@lists.xensource.com, peterz@infradead.org,
        mtosatti@redhat.com,
        stefano stabellini <stefano.stabellini@eu.citrix.com>,
        andi@firstfloor.org, attilio rao <attilio.rao@citrix.com>,
        ouyang@cs.pitt.edu, gregkh@suse.de, agraf@suse.de,
        chegu vinod <chegu_vinod@hp.com>, torvalds@linux-foundation.org,
        avi kivity <avi.kivity@gmail.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, riel@redhat.com, drjones@redhat.com,
        virtualization@lists.linux-foundation.org,
        srivatsa vaddagiri <srivatsa.vaddagiri@gmail.com>
Subject: Re: [PATCH RFC V11 15/18] kvm : Paravirtual ticketlocks support for
 linux guests running on KVM hypervisor
References: <51F0ED31.3040200@linux.vnet.ibm.com> <20130731062440.GK28372@redhat.com> <51FA1087.9080908@linux.vnet.ibm.com> <20130802092539.GB28327@gmail.com> <20130802095406.GB30072@redhat.com> <20130805094603.GA29303@gmail.com> <20130805095901.GL2258@redhat.com> <20130805135222.GA32429@gmail.com> <1952910281.9619371.1375711538505.JavaMail.root@redhat.com>
In-Reply-To: <1952910281.9619371.1375711538505.JavaMail.root@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13080514-1618-0000-0000-00000466BF69
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2013 07:35 PM, Paolo Bonzini wrote:
>>>> I guess you'd want to carry this in the KVM tree or so - maybe in a
>>>> separate branch because it changes Xen as well?
>>>
>>> It changes KVM host and guest side, XEN and common x86 spinlock code. I
>>> think it would be best to merge common x86 spinlock bits and guest side
>>> KVM/XEN bits through tip tree and host KVM part will go through KVM
>>> tree. If this is OK with you, Ingo, and XEN folks Raghavendra can send
>>> two separate patch series one for the tip and one for KVM host side.
>>
>> Sure, that's fine - if the initial series works fine in isolation as well
>> (i.e. won't break anything).
>
> It would be a big problem if it didn't!  Raghavendra, please send the
> two separate series as Gleb explained above.
>

Yes. Sure.  The patches have been split in that way.

Only thing I am thinking is about KVM_FEATURE_PV_UNHALT, and 
KVM_HC_KICK_CPU definition in the below hunk, that is needed by guest
as well. may be this header file change can be a separate patch so that
duplicate can be handled easily during merge?

I do testing of all combination after splitting and post.

diff --git a/arch/x86/include/uapi/asm/kvm_para.h 
b/arch/x86/include/uapi/asm/kvm_para.h
index 06fdbd9..94dc8ca 100644
--- a/arch/x86/include/uapi/asm/kvm_para.h
+++ b/arch/x86/include/uapi/asm/kvm_para.h
@@ -23,6 +23,7 @@
  #define KVM_FEATURE_ASYNC_PF           4
  #define KVM_FEATURE_STEAL_TIME         5
  #define KVM_FEATURE_PV_EOI             6
+#define KVM_FEATURE_PV_UNHALT          7

diff --git a/include/uapi/linux/kvm_para.h b/include/uapi/linux/kvm_para.h
index cea2c5c..2841f86 100644
--- a/include/uapi/linux/kvm_para.h
+++ b/include/uapi/linux/kvm_para.h
@@ -19,6 +19,7 @@
  #define KVM_HC_MMU_OP                  2
  #define KVM_HC_FEATURES                        3
  #define KVM_HC_PPC_MAP_MAGIC_PAGE      4
+#define KVM_HC_KICK_CPU                        5



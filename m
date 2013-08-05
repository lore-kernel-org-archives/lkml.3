Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810Ab3HEOqQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 10:46:16 -0400
Received: from mx4-phx2.redhat.com ([209.132.183.25]:43405 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349Ab3HEOqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 10:46:14 -0400
Date: Mon, 5 Aug 2013 10:45:16 -0400 (EDT)
From: Paolo Bonzini <pbonzini@redhat.com>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: Gleb Natapov <gleb@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        mingo@redhat.com, x86@kernel.org, tglx@linutronix.de, jeremy@goop.org,
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
Message-ID: <930127352.9647991.1375713916924.JavaMail.root@redhat.com>
In-Reply-To: <51FFB937.6050003@linux.vnet.ibm.com>
References: <51F0ED31.3040200@linux.vnet.ibm.com> <20130802092539.GB28327@gmail.com> <20130802095406.GB30072@redhat.com> <20130805094603.GA29303@gmail.com> <20130805095901.GL2258@redhat.com> <20130805135222.GA32429@gmail.com> <1952910281.9619371.1375711538505.JavaMail.root@redhat.com> <51FFB937.6050003@linux.vnet.ibm.com>
Subject: Re: [PATCH RFC V11 15/18] kvm : Paravirtual ticketlocks support for
 linux guests running on KVM hypervisor
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.82.11]
X-Mailer: Zimbra 8.0.3_GA_5664 (ZimbraWebClient - SAF5 (Mac)/8.0.3_GA_5664)
Thread-Topic: kvm : Paravirtual ticketlocks support for linux guests running on KVM hypervisor
Thread-Index: c4e32RRS2tZALFoolFW3eluSuJDHJA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Only thing I am thinking is about KVM_FEATURE_PV_UNHALT, and
> KVM_HC_KICK_CPU definition in the below hunk, that is needed by guest
> as well. may be this header file change can be a separate patch so that
> duplicate can be handled easily during merge?

Sure, good idea.

Paolo

> I do testing of all combination after splitting and post.

> diff --git a/arch/x86/include/uapi/asm/kvm_para.h
> b/arch/x86/include/uapi/asm/kvm_para.h
> index 06fdbd9..94dc8ca 100644
> --- a/arch/x86/include/uapi/asm/kvm_para.h
> +++ b/arch/x86/include/uapi/asm/kvm_para.h
> @@ -23,6 +23,7 @@
>   #define KVM_FEATURE_ASYNC_PF           4
>   #define KVM_FEATURE_STEAL_TIME         5
>   #define KVM_FEATURE_PV_EOI             6
> +#define KVM_FEATURE_PV_UNHALT          7
> 
> diff --git a/include/uapi/linux/kvm_para.h b/include/uapi/linux/kvm_para.h
> index cea2c5c..2841f86 100644
> --- a/include/uapi/linux/kvm_para.h
> +++ b/include/uapi/linux/kvm_para.h
> @@ -19,6 +19,7 @@
>   #define KVM_HC_MMU_OP                  2
>   #define KVM_HC_FEATURES                        3
>   #define KVM_HC_PPC_MAP_MAGIC_PAGE      4
> +#define KVM_HC_KICK_CPU                        5
> 
> 
> 

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255AbaHNClz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 22:41:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:32989 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752527AbaHNCly (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 22:41:54 -0400
Message-ID: <53EC21E1.80502@zytor.com>
Date: Wed, 13 Aug 2014 19:41:37 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>, "Theodore Ts'o" <tytso@mit.edu>,
        kvm list <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>, X86 ML <x86@kernel.org>,
        Daniel Borkmann <dborkman@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Bandan Das <bsd@redhat.com>, Andrew Honig <ahonig@google.com>
Subject: Re: [PATCH v5 0/5] random,x86,kvm: Rework arch RNG seeds and get
 some from kvm
References: <cover.1406177531.git.luto@amacapital.net> <CALCETrXtLf3ZFtyrbwj29C=t3PcTxRT2AJWZCUHdKC3AYyUVAA@mail.gmail.com> <20140812191723.GI12871@thunk.org> <CALCETrVmviT=upxHfPfmLy2aUOKdCuCbNg9WZQcx6f=8T8vv=g@mail.gmail.com> <53EB1859.6030800@zytor.com> <20140813143209.GD6437@thunk.org> <CALCETrUQ8yRmmN1kbdCy99ae2+-Xp4caOBgrXvaQhCCUi=i0zg@mail.gmail.com> <53EBA435.3020207@zytor.com> <20140813182219.GE6437@thunk.org> <CALCETrVTsyq4u+G2Td7Gmi6pa6c1ePgavqN31mjo9_E5=7bGCg@mail.gmail.com> <53EBB214.4030102@zytor.com>
In-Reply-To: <53EBB214.4030102@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2014 11:44 AM, H. Peter Anvin wrote:
> On 08/13/2014 11:33 AM, Andy Lutomirski wrote:
>>
>> As for doing arch_random_init after clone/migration, I think we'll
>> need another KVM extension for that, since, AFAIK, we don't actually
>> get notified that we were cloned or migrated.  That will be
>> nontrivial.  Maybe we can figure that out at KS, too.
>>
> 
> We don't need a reset when migrated (although it might be a good idea
> under some circumstances, i.e. if the pools might somehow have gotten
> exposed) but definitely when cloned.
> 

But yes, we need a notification.  For obvious reasons there is no
suspend event (one can snapshot a running VM) but we need to be notified
upon wakeup, *or* we need to give KVM a way to update the necessary state.

	-hpa



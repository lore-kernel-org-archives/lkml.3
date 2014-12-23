Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906AbaLWKZU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 05:25:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48157 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754844AbaLWKZS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 05:25:18 -0500
Message-ID: <54994304.1060808@redhat.com>
Date: Tue, 23 Dec 2014 11:25:08 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Santosh Shukla <sshukla@mvista.com>
CC: Andy Lutomirski <luto@amacapital.net>,
        Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Cleaning up the KVM clock
References: <CALCETrV4Bhc=pwjJR-S7dfgcR7n0xKtj0o=ofOxCfJmnVFcjGw@mail.gmail.com>	<20141222133430.GA23631@amt.cnet>	<CALCETrXU+Z_t3qon+DR1hUiqSgpWLe9w74guBxbDG68ytM0icg@mail.gmail.com>	<54989FF0.3090300@redhat.com> <CAAyOgsbNsDmPGzJcEuYExaswWaQoLHzkMVd+r6r-8jnGc00yTA@mail.gmail.com>
In-Reply-To: <CAAyOgsbNsDmPGzJcEuYExaswWaQoLHzkMVd+r6r-8jnGc00yTA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 23/12/2014 11:23, Santosh Shukla wrote:
> 
> 
>     No.  kvm_guest_time_update is called by vcpu_enter_guest, while the vCPU
>     is not running, so it's entirely atomic from the point of view of
>     the guest.
> 
>  
> Then checking odd value for version field (at guest side: function
> pvclock_clocksource_read / pvclock_read_flag) is redundant considering
> that  kvm_guest_time_update incremented by 2. 

The code is common to Xen and KVM.  Xen uses seqlock semantics.  The
cost of one AND is not detectable.

Paolo

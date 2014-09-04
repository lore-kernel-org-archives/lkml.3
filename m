Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754938AbaIDRSJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 13:18:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13872 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753875AbaIDRSH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 13:18:07 -0400
Message-ID: <54089EA5.5080407@redhat.com>
Date: Thu, 04 Sep 2014 19:17:25 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Gleb Natapov <gleb@kernel.org>
CC: Gleb Natapov <gleb@cloudius-systems.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jroedel@suse.de, agraf@suse.de,
        valentine.sinitsyn@gmail.com, jan.kiszka@siemens.com,
        avi@cloudius-systems.com
Subject: Re: [PATCH 3/4] KVM: x86: inject nested page faults on emulated instructions
References: <1409670830-14544-1-git-send-email-pbonzini@redhat.com> <1409670830-14544-4-git-send-email-pbonzini@redhat.com> <20140904070220.GL9842@cloudius-systems.com> <54087343.5050409@redhat.com> <20140904150500.GA25317@minantech.com>
In-Reply-To: <20140904150500.GA25317@minantech.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 04/09/2014 17:05, Gleb Natapov ha scritto:
>> >         if (ctxt->have_exception) {
>> >                 inject_emulated_exception(vcpu);
>> > -               r = EMULATE_DONE;
>> > +               return EMULATE_DONE;
> If there was no vmexit we still want to writeback. Perhaps:
>     writeback = inject_emulated_exception(vcpu);
> and return false if there was vmexit due to nested page fault (or any fault,
> can't L1 ask for #GP/#UD intercept that need to be handled here too?)
> 

Sounds good.

Paolo

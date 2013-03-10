Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897Ab3CJRTN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 13:19:13 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:37109 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437Ab3CJRTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 13:19:12 -0400
Message-ID: <513CC08B.2040800@redhat.com>
Date: Sun, 10 Mar 2013 18:19:07 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, mtosatti@redhat.com,
        jan.kiszka@siemens.com
Subject: Re: [PATCH] x86: kvm: reset the bootstrap processor when it gets
 an INIT
References: <1362811713-25830-1-git-send-email-pbonzini@redhat.com> <20130310114646.GM11223@redhat.com> <513C9E82.1020304@redhat.com> <20130310153540.GL24444@redhat.com>
In-Reply-To: <20130310153540.GL24444@redhat.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 10/03/2013 16:35, Gleb Natapov ha scritto:
>> > However, it would effectively redefine the meaning of
>> > KVM_MP_STATE_INIT_RECEIVED and KVM_MP_STATE_SIPI_RECEIVED, respectively
>> > to KVM_MP_STATE_WAIT_FOR_SIPI and KVM_MP_STATE_RESETTING.  I wasn't sure
>> > if this is considered an API change (personally, I would treat it as one).
>> > 
> If it is kernel module internal it definitely is not API change.
> INIT/SIPI handling is a bit ad-hoc right now anyway as Jan noticed. For
> instance INIT does not really resets VCPU. Only after SIPI it is really
> reset, so KVM_MP_STATE_SIPI_RECEIVED is really KVM_MP_STATE_RESET_ME_RIGHT_NOW
> state.

Yeah, and the current definition is ambiguous (without hypervisor
patches, there's no way to use it as the names would suggest), so
perhaps the right thing to do is to rename the states (old names kept
for backwards compatibility only) and work from there.

Paolo

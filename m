Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991Ab3CJSKk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 14:10:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23139 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751562Ab3CJSKj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 14:10:39 -0400
Date: Sun, 10 Mar 2013 20:10:36 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, mtosatti@redhat.com,
        jan.kiszka@siemens.com
Subject: Re: [PATCH] x86: kvm: reset the bootstrap processor when it gets an
 INIT
Message-ID: <20130310181035.GM24444@redhat.com>
References: <1362811713-25830-1-git-send-email-pbonzini@redhat.com>
 <20130310114646.GM11223@redhat.com>
 <513C9E82.1020304@redhat.com>
 <20130310153540.GL24444@redhat.com>
 <513CC08B.2040800@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <513CC08B.2040800@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 10, 2013 at 06:19:07PM +0100, Paolo Bonzini wrote:
> Il 10/03/2013 16:35, Gleb Natapov ha scritto:
> >> > However, it would effectively redefine the meaning of
> >> > KVM_MP_STATE_INIT_RECEIVED and KVM_MP_STATE_SIPI_RECEIVED, respectively
> >> > to KVM_MP_STATE_WAIT_FOR_SIPI and KVM_MP_STATE_RESETTING.  I wasn't sure
> >> > if this is considered an API change (personally, I would treat it as one).
> >> > 
> > If it is kernel module internal it definitely is not API change.
> > INIT/SIPI handling is a bit ad-hoc right now anyway as Jan noticed. For
> > instance INIT does not really resets VCPU. Only after SIPI it is really
> > reset, so KVM_MP_STATE_SIPI_RECEIVED is really KVM_MP_STATE_RESET_ME_RIGHT_NOW
> > state.
> 
> Yeah, and the current definition is ambiguous (without hypervisor
> patches, there's no way to use it as the names would suggest), so
> perhaps the right thing to do is to rename the states (old names kept
> for backwards compatibility only) and work from there.
> 
I do not see how renaming clarify things. From userspace point of view
KVM_MP_STATE_SIPI_RECEIVED does not exists. If AP is hard reset
userspase makes it UNINIT, if soft reset it makes it INIT_RECEIVED, if
BSP it makes it running no matter what type of reset.

--
			Gleb.

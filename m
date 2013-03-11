Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751702Ab3CKOFJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 10:05:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9557 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750923Ab3CKOFH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 10:05:07 -0400
Date: Mon, 11 Mar 2013 16:05:03 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>
Subject: Re: [PATCH] x86: kvm: reset the bootstrap processor when it gets an
 INIT
Message-ID: <20130311140503.GO31619@redhat.com>
References: <20130310153540.GL24444@redhat.com>
 <513CC08B.2040800@redhat.com>
 <20130310181035.GM24444@redhat.com>
 <513DAE8F.3050102@redhat.com>
 <20130311102852.GE31619@redhat.com>
 <513DBF45.9030803@redhat.com>
 <20130311115144.GG31619@redhat.com>
 <513DDCC2.9070807@redhat.com>
 <20130311135441.GN31619@redhat.com>
 <513DE3C4.5000503@siemens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <513DE3C4.5000503@siemens.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 03:01:40PM +0100, Jan Kiszka wrote:
> > We are not moving away from mp_state, we are moving away from using
> > mp_state for signaling because with nested virt INIT does not always
> > change mp_state, not only that it can change mp_state long after signal
> > is received after vmx off is done.
> 
> Right.
> 
> BTW, for that to happen, we will also need to influence the INIT level.
> Unless I misread the spec, INIT is blocked while in root mode, and if
> you deassert INIT before leaving root (vmxoff, vmenter), nothing
> actually happens. So what matters is the INIT signal level at the exit
> of root mode.
> 
You are talking about INIT# signal received via CPU pin, right? I think
INIT send by IPI cannot go away.

--
			Gleb.

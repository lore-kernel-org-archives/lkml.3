Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753192Ab3CKOM5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 10:12:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9754 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752658Ab3CKOMz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 10:12:55 -0400
Date: Mon, 11 Mar 2013 16:12:52 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>
Subject: Re: [PATCH] x86: kvm: reset the bootstrap processor when it gets an
 INIT
Message-ID: <20130311141252.GQ31619@redhat.com>
References: <20130311102852.GE31619@redhat.com>
 <513DBF45.9030803@redhat.com>
 <20130311115144.GG31619@redhat.com>
 <513DDCC2.9070807@redhat.com>
 <20130311135441.GN31619@redhat.com>
 <513DE3C4.5000503@siemens.com>
 <20130311140503.GO31619@redhat.com>
 <513DE4DA.4050009@siemens.com>
 <20130311140925.GP31619@redhat.com>
 <513DE5E5.1080402@siemens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <513DE5E5.1080402@siemens.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 03:10:45PM +0100, Jan Kiszka wrote:
> On 2013-03-11 15:09, Gleb Natapov wrote:
> > On Mon, Mar 11, 2013 at 03:06:18PM +0100, Jan Kiszka wrote:
> >> On 2013-03-11 15:05, Gleb Natapov wrote:
> >>> On Mon, Mar 11, 2013 at 03:01:40PM +0100, Jan Kiszka wrote:
> >>>>> We are not moving away from mp_state, we are moving away from using
> >>>>> mp_state for signaling because with nested virt INIT does not always
> >>>>> change mp_state, not only that it can change mp_state long after signal
> >>>>> is received after vmx off is done.
> >>>>
> >>>> Right.
> >>>>
> >>>> BTW, for that to happen, we will also need to influence the INIT level.
> >>>> Unless I misread the spec, INIT is blocked while in root mode, and if
> >>>> you deassert INIT before leaving root (vmxoff, vmenter), nothing
> >>>> actually happens. So what matters is the INIT signal level at the exit
> >>>> of root mode.
> >>>>
> >>> You are talking about INIT# signal received via CPU pin, right? I think
> >>> INIT send by IPI cannot go away.
> >>
> >> Why shouldn't it? Besides edge, there is also level-triggered INIT.
> >>
> > OK, so level-triggered INIT can be de-asserted what about edge triggered
> > one? :)
> 
> It should be lost while in root mode.
> 
Ah, that's great. Removes some potential complications.

--
			Gleb.

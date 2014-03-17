Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229AbaCQRGA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 13:06:00 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:60848 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097AbaCQRF7 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:7:1>);
	Mon, 17 Mar 2014 13:05:59 -0400
Message-Id: <532739810200007800124E85@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Mon, 17 Mar 2014 17:05:53 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "David Vrabel" <david.vrabel@citrix.com>,
        "George Dunlap" <George.Dunlap@eu.citrix.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        "Sarah Newman" <srn@prgmr.com>, "Ingo Molnar" <mingo@redhat.com>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCHv1] x86: don't schedule when handling
 #NM exception
References: <1394468273-13676-1-git-send-email-david.vrabel@citrix.com>
 <531DEB11.2070709@zytor.com> <531DF319.6010800@citrix.com>
 <53266841.6090308@prgmr.com>
 <1ebfa80c-4a68-4602-bc98-e5d5f0893998@email.android.com>
 <CAFLBxZZz4Ot0CgWRHNRaM5zVkpf+QdXveFz_m3aVYnKUd9cAdQ@mail.gmail.com>
 <5327291D.60009@zytor.com>
In-Reply-To: <5327291D.60009@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 17.03.14 at 17:55, "H. Peter Anvin" <hpa@zytor.com> wrote:
> On 03/17/2014 05:19 AM, George Dunlap wrote:
>> On Mon, Mar 17, 2014 at 3:33 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>>> No, the right thing is to unf*ck the Xen braindamage and use eagerfpu as a 
> workaround for the legacy hypervisor versions.
>> 
>> The interface wasn't an accident.  In the most common case you'll want
>> to clear the bit anyway. In PV mode clearing it would require an extra
>> trip up into the hypervisor.  So this saves one trip up into the
>> hypervisor on every context switch which involves an FPU, at the
>> expense of not being able to context-switch away when handling the
>> trap.
> 
> The interface was a complete faceplant, because it caused failures.
> You're not infinitely unconstrained since you want to play in the same
> sandbox as the native architecture, and if you want to have a hope of
> avoiding these kinds of failures you really need to avoid making random
> "improvements", certainly not without an explicit guest opt-in (the same
> we do for the native CPU architecture when adding new features.)
> 
> So if this interface wasn't an accident it was active negligence and
> incompetence.

I don't think so - while it (as we now see) disallows certain things
inside the guest, back at the time when this was designed there was
no sign of any sort of allocation/scheduling being done inside the
#NM handler. And furthermore, a PV specification is by its nature
allowed to define deviations from real hardware behavior, or else it
wouldn't be needed in the first place.

Jan



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126AbaCRIPa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 04:15:30 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:54931 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753698AbaCRIOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 04:14:07 -0400
Date: Tue, 18 Mar 2014 09:14:03 +0100
From: Ingo Molnar <mingo@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jan Beulich <JBeulich@suse.com>,
        George Dunlap <George.Dunlap@eu.citrix.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        Ingo Molnar <mingo@redhat.com>, David Vrabel <david.vrabel@citrix.com>,
        Sarah Newman <srn@prgmr.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Xen-devel] [PATCHv1] x86: don't schedule when handling #NM
 exception
Message-ID: <20140318081403.GC28075@gmail.com>
References: <1394468273-13676-1-git-send-email-david.vrabel@citrix.com>
 <531DEB11.2070709@zytor.com>
 <531DF319.6010800@citrix.com>
 <53266841.6090308@prgmr.com>
 <1ebfa80c-4a68-4602-bc98-e5d5f0893998@email.android.com>
 <CAFLBxZZz4Ot0CgWRHNRaM5zVkpf+QdXveFz_m3aVYnKUd9cAdQ@mail.gmail.com>
 <5327291D.60009@zytor.com>
 <532739810200007800124E85@nat28.tlf.novell.com>
 <53272CED.4010901@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53272CED.4010901@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 03/17/2014 10:05 AM, Jan Beulich wrote:
> > 
> > I don't think so - while it (as we now see) disallows certain things
> > inside the guest, back at the time when this was designed there was
> > no sign of any sort of allocation/scheduling being done inside the
> > #NM handler. And furthermore, a PV specification is by its nature
> > allowed to define deviations from real hardware behavior, or else it
> > wouldn't be needed in the first place.
> > 
> 
> And this is exactly the sort of thing about Xen that make me want to 
> go on murderous rampage.  You think you can just take the current 
> Linux implementation at whatever time you implement the code and 
> later come back and say "don't change that, we hard-coded it in 
> Xen."

And the solution is that we just ignore that kind of crap in the 
native kernel and let Xen sort it out as best as it can.

When Xen (and PV) was merged it was promised that a PV interface can 
always adopt to whatever Linux does, without restricting the kernel on 
the native side in any fashion - time to check on that promise.

Thanks,

	Ingo

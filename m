Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755612Ab3DPIoz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 04:44:55 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:46257 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753310Ab3DPIox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 04:44:53 -0400
Date: Tue, 16 Apr 2013 09:44:18 +0100
From: Will Deacon <will.deacon@arm.com>
To: Colin Cross <ccross@android.com>
Cc: Rob Herring <robherring2@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Kees Cook <keescook@chromium.org>, Tony Luck <tony.luck@intel.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>
Subject: Re: [RFC PATCH 1/3] pstore-ram: use write-combine mappings
Message-ID: <20130416084418.GA30756@mudshark.cambridge.arm.com>
References: <1365563297-12480-1-git-send-email-robherring2@gmail.com>
 <CAMbhsRSvQPbzJ7Nt=OSSYE_A1e+eaUjO7XY+qRppJ5_gfWmW4A@mail.gmail.com>
 <51656992.60203@gmail.com>
 <CAMbhsRS1hnBRoomoiNijrXZB-938d2RSs1cu9EdSfmXD3xpSQg@mail.gmail.com>
 <516C9454.4060009@gmail.com>
 <CAMbhsRRT7tOBHppvjJEW5wRtVaUhwxr8=YQY=Sy0VAFeBg1JmQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMbhsRRT7tOBHppvjJEW5wRtVaUhwxr8=YQY=Sy0VAFeBg1JmQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 16, 2013 at 01:43:09AM +0100, Colin Cross wrote:
> On Mon, Apr 15, 2013 at 4:59 PM, Rob Herring <robherring2@gmail.com> wrote:
> > Exclusive accesses still have further restrictions. From section 3.4.5:
> >
> > • It is IMPLEMENTATION DEFINED whether LDREX and STREX operations can be
> > performed to a memory region
> >    with the Device or Strongly-ordered memory attribute. Unless the
> > implementation documentation explicitly
> >   states that LDREX and STREX operations to a memory region with the
> > Device or Strongly-ordered attribute are
> >  permitted, the effect of such operations is UNPREDICTABLE.
> >
> >
> > Given that it is implementation defined, I don't see how Linux can rely
> > on that behavior.
> 
> I see, the problem is that while noncached and writecombined appear to
> be similar mappings, noncached is mapped in PRRR to strongly-ordered,
> while writecombined is mapped to unbufferable normal memory.
> 
> I think adding a wmb() to persistent_ram_write is going to be
> expensive on cpus with outer caches like the L2X0, where wmb() will
> result in a spinlock.  Is there a real SoC where this doesn't work?

A real SoC where exclusives don't work to memory not mapped as normal? Take
your pick...

Will

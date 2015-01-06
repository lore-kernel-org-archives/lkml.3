Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933287AbbAFVjF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 16:39:05 -0500
Received: from one.firstfloor.org ([193.170.194.197]:57759 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932611AbbAFVjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 16:39:02 -0500
Date: Tue, 6 Jan 2015 22:39:00 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Andi Kleen <andi@firstfloor.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        ilya.enkovich@intel.com
Subject: Re: [PATCH 3.19 3/3] x86, mpx: Change the MPX enable/disable API
 to arch_prctl
Message-ID: <20150106213900.GX2915@two.firstfloor.org>
References: <CALCETrU3oHO5Rjqp_DmJaOkEBOtZpQ+f99xXiY5=84JfJphZCA@mail.gmail.com>
 <54AC1FFB.7030504@linux.intel.com>
 <CALCETrVJyBR7NoZvC=A4htRtm-fLe5NUEGUdvJRL28adU4MhUg@mail.gmail.com>
 <54AC29B1.70004@linux.intel.com>
 <CALCETrUE+kZeC+vx1OnpYsuL-b0u3fFJe3QfjeZQ=hCiQRPrHg@mail.gmail.com>
 <54AC2F62.40708@linux.intel.com>
 <20150106191649.GU2915@two.firstfloor.org>
 <CALCETrUNpi1Gc-Qpmu1bJ0BVcSH2xquaY_X+YYhLjbPaQcf0_w@mail.gmail.com>
 <20150106212255.GV2915@two.firstfloor.org>
 <CALCETrUpR6ZCBSXdbY232inK=LaXLK0LAssqUt+r8DAn9=xjJg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrUpR6ZCBSXdbY232inK=LaXLK0LAssqUt+r8DAn9=xjJg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2015 at 01:34:56PM -0800, Andy Lutomirski wrote:
> On Tue, Jan 6, 2015 at 1:22 PM, Andi Kleen <andi@firstfloor.org> wrote:
> >> Given that it doesn't seen to have been committed yet, I'm not too
> >> worried about compatibility.  And "prctl (43)" doesn't actually seem a
> >> whole lot better than "syscall(SYS_arch_prctl, ARCH_ENABLE_MPX, 0)"
> >
> > This would actually fail with the EINVAL change you requested.
> >
> 
> So the libmpx code needs to change anyway, then, right?  I really
> don't think we should accept garbage in the extra prctl slots just
> because uncommitted code somewhere fails to initialize them.

Yes it would.

I think that is why most prctls don't do it. After all if you need a new
field you can just add another one. I usually added the checks in the
ones I added, but I can see why not doing it.

-Andi

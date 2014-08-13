Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206AbaHMJTM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 05:19:12 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:43610 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751722AbaHMJTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 05:19:11 -0400
Date: Wed, 13 Aug 2014 10:18:37 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Josh Triplett <josh@joshtriplett.org>,
        John Stultz <john.stultz@linaro.org>,
        "ksummit-discuss@lists.linuxfoundation.org" 
	<ksummit-discuss@lists.linuxfoundation.org>,
        "Joseph S. Myers" <joseph@codesourcery.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [Ksummit-discuss] (Resend) 2038 Kernel Summit Discussion Fodder
Message-ID: <20140813091837.GA18495@arm.com>
References: <53EAAC95.7080301@linaro.org>
 <20140813013342.GB6783@cloud>
 <CALCETrVP64FSJWyHHbm0R-2qTzN1Q5PwXh4k9+qjg1Q8bSud2w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALCETrVP64FSJWyHHbm0R-2qTzN1Q5PwXh4k9+qjg1Q8bSud2w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2014 at 02:37:11AM +0100, Andy Lutomirski wrote:
> On Tue, Aug 12, 2014 at 6:33 PM,  <josh@joshtriplett.org> wrote:
> > On Tue, Aug 12, 2014 at 05:08:53PM -0700, John Stultz wrote:
> >> A more aggressive version of the previous proposal is what I’m calling the
> >> “New Virtual-Architecture” approach, basically extending the versioning
> >> control from the linker down into the kernel as well.  It would be adding a
> >> new “virtual-architecture” to the kernel, not entirely unlike how x32 is
> >> supported on x86_64 systems.  We would create entirely new ABI and
> >> architecture name in the kernel (think something like “armllt” or
> >> “i386llt”). We would preserve compatibility for legacy applications via
> >> personalities, similar mechanism as the compat_ interface used to support
> >> 32bit applications on 64bit kernels. In this case, we wouldn’t introduce
> >> new 64 bit syscalls in the kernel, as the existing interfaces would just be
> >> typed correctly for our new virtual architecture, but we would have
> >> duplicate syscall interfaces via the compat interfaces. The extra
> >> complexity would also be that we would have to support new 32bit compat
> >> environment on 64bit systems. Userspace would be completely rebuilt to
> >> support the new -llt architecture, and compatibility for legacy
> >> applications would be done via the same multiarch packaging as is done now
> >> for running 32bit applications on 64bit systems.
> >
> > I wonder: could we make this new architecture effectively use the
> > signatures of the 64-bit syscalls (similar to x32), just with a 32-bit
> > calling convention?
> 
> Doesn't x32 do the reverse?  It invokes *compat* syscalls using a
> 64-bit calling convention.

Not entirely. It uses 64-bit syscalls primarily with compat only when
sharing structures containing pointers. We are working on something
similar for arm64 (called the ILP32 ABI).

-- 
Catalin

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843AbaBNTXd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 14:23:33 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:37043 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752036AbaBNTXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 14:23:32 -0500
Date: Fri, 14 Feb 2014 19:23:22 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Kees Cook <keescook@chromium.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Steve Capper <steve.capper@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] ARM: mm: report both sections from PMD
Message-ID: <20140214192322.GJ30257@n2100.arm.linux.org.uk>
References: <20140213195230.GA15275@www.outflux.net> <20140214101724.GC10590@arm.com> <CAGXu5jKYq=0Ud-A6bdD2zMe=+r0S7nja8Rg+OxeT+JHzdpwTKg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jKYq=0Ud-A6bdD2zMe=+r0S7nja8Rg+OxeT+JHzdpwTKg@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 14, 2014 at 11:13:53AM -0800, Kees Cook wrote:
> On Fri, Feb 14, 2014 at 2:17 AM, Catalin Marinas
> <catalin.marinas@arm.com> wrote:
> > On Thu, Feb 13, 2014 at 07:52:30PM +0000, Kees Cook wrote:
> >> On 2-level page table systems, the PMD has 2 section entries. Report
> >> these, otherwise ARM_PTDUMP will miss reporting permission changes on
> >> odd section boundaries.
> >>
> >> Signed-off-by: Kees Cook <keescook@chromium.org>
> >
> > Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> 
> On Fri, Feb 14, 2014 at 9:05 AM, Steve Capper <steve.capper@linaro.org> wrote:
> > Tested-by: Steve Capper <steve.capper@linaro.org>
> 
> Thanks to both of you! If you have a moment can you check this other
> patch which has additional fixes for the dump code?
> 
> https://lkml.org/lkml/2014/2/12/662

It's not that simple, because APX in section descriptors doesn't exist
on pre-v6 ARMs.  This needs to be conditional upon the CPU arch.

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091AbaIESEK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 14:04:10 -0400
Received: from mail-qg0-f51.google.com ([209.85.192.51]:49457 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbaIESEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 14:04:08 -0400
Date: Fri, 5 Sep 2014 14:04:03 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Daniel Thompson <daniel.thompson@linaro.org>
cc: Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v1 1/6] arm: fiq: Replace default FIQ handler
In-Reply-To: <54097C6B.7040805@linaro.org>
Message-ID: <alpine.LFD.2.11.1409051348200.16533@knanqh.ubzr>
References: <1409662853-29313-1-git-send-email-daniel.thompson@linaro.org> <1409846620-14542-1-git-send-email-daniel.thompson@linaro.org> <1409846620-14542-2-git-send-email-daniel.thompson@linaro.org> <alpine.LFD.2.11.1409041452500.16533@knanqh.ubzr>
 <54097C6B.7040805@linaro.org>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Sep 2014, Daniel Thompson wrote:

> On 04/09/14 19:57, Nicolas Pitre wrote:
> > On Thu, 4 Sep 2014, Daniel Thompson wrote:
> > 
> >> +@ svc_exit_via_fiq - similar to svc_exit but switches to FIQ mode before exit
> >> +@
> >> +@ This macro acts in a similar manner to svc_exit but switches to FIQ
> >> +@ mode to restore the final part of the register state.
> >> +@
> >> +@ We cannot use the normal svc_exit procedure because that would
> >> +@ clobber spsr_svc (FIQ could be delivered during the first few instructions
> >> +@ of vector_swi meaning its contents have not been saved anywhere).
> >> +@
> > 
> > Wouldn't it be better for this macro to live in entry-header.S alongside 
> > the others?
> 
> I'm not sure either way.
> 
> svc_exit_from_fiq isn't needed by entry-common.S and cannot be used by
> entry-v7m.S because v7m has no FIQ. For that reason I decided to place
> it alongside svc_entry in entry-armv.S rather than alongside svc_exit in
> entry-header.S .

Here's a list of macros from entry-headers.S that I don't see being used 
in entry-v7m.S: zero_fp, alignment_trap, store_user_sp_lr, 
load_user_sp_lr, svc_exit, ct_user_exit, ct_user_enter.

Yet, entry-header.S contains macros such as v7m_exception_entry and 
v7m_exception_slow_exit which are unlikely to ever be used in 
entry-armv.S.

> I am happy to move it if you have a strong preference here. Please let
> me know.

I don't have a strong preference, but a preference nevertheless.

It just looks odd that a file is already dedicated to gather all those 
macros for similar purposes and this one is not there.  That makes 
future code review/maintenance a bit annoying if similar things are not 
kept in one place.


Nicolas

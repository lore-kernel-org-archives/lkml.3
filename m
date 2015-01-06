Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932197AbbAFCnz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 21:43:55 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:33850 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbbAFCnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 21:43:53 -0500
Message-ID: <1420512220.2910.39.camel@cyril>
Subject: Re: [PATCH 0/2] Quieten softlockup detector on virtualised kernels
From: Cyril Bur <cyrilbur@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, mpe@ellerman.id.au, drjones@redhat.com,
        dzickus@redhat.com, mingo@kernel.org, uobergfe@redhat.com,
        chaiw.fnst@cn.fujitsu.com, cl@linu.com, fabf@skynet.be,
        atomlin@redhat.com, benzh@chromium.org
Date: Tue, 06 Jan 2015 13:43:40 +1100
In-Reply-To: <20150105140950.9ef64425359c62475b48733d@linux-foundation.org>
References: <1419224764-11384-1-git-send-email-cyrilbur@gmail.com>
	 <20150105140950.9ef64425359c62475b48733d@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2015-01-05 at 14:09 -0800, Andrew Morton wrote:
> On Mon, 22 Dec 2014 16:06:02 +1100 Cyril Bur <cyrilbur@gmail.com> wrote:
> 
> > When the hypervisor pauses a virtualised kernel the kernel will observe a jump
> > in timebase, this can cause spurious messages from the softlockup detector.
> > 
> > Whilst these messages are harmless, they are accompanied with a stack trace
> > which causes undue concern and more problematically the stack trace in the
> > guest has nothing to do with the observed problem and can only be misleading.
> > 
> > Futhermore, on POWER8 this is completely avoidable with the introduction of
> > the Virtual Time Base (VTB) register.
> 
> Does this problem apply to other KVM implementations and to Xen?  If
> so, what would implementations of running_clock() for those look like? 
> If not, why not?
Yes the problem should appear on other KVM implementations, not really
sure about Xen but I don't see why the problem wouldn't crop up.

x86 do have a method for dealing with it in the softlockup detector,
they've added a check in the softlockup using a paravirtualised clock
where the guest can discover if it had been paused, Xen could be using
too.
It doesn't appear s390 do anything.

Thanks,

Cyril
> 
> 



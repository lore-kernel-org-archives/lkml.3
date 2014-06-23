Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755776AbaFWWBM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 18:01:12 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:58403 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505AbaFWWBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 18:01:08 -0400
MIME-Version: 1.0
In-Reply-To: <53A88966.5080400@intel.com>
References: <1403084656-27284-1-git-send-email-qiaowei.ren@intel.com>
 <1403084656-27284-9-git-send-email-qiaowei.ren@intel.com> <53A8874A.3050301@mit.edu>
 <53A88966.5080400@intel.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 23 Jun 2014 15:00:46 -0700
Message-ID: <CALCETrX7B8yxrNgojCR8YNH+6zHX8vq+GMFn0RjdWXdLmhA-Fg@mail.gmail.com>
Subject: Re: [PATCH v6 08/10] x86, mpx: add prctl commands PR_MPX_REGISTER, PR_MPX_UNREGISTER
To: Dave Hansen <dave.hansen@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Qiaowei Ren <qiaowei.ren@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 23, 2014 1:09 PM, "Dave Hansen" <dave.hansen@intel.com> wrote:
>
> On 06/23/2014 01:00 PM, Andy Lutomirski wrote:
> > On 06/18/2014 02:44 AM, Qiaowei Ren wrote:
> >> > This patch adds the PR_MPX_REGISTER and PR_MPX_UNREGISTER prctl()
> >> > commands. These commands can be used to register and unregister MPX
> >> > related resource on the x86 platform.
> >> >
> >> > The base of the bounds directory is set into mm_struct during
> >> > PR_MPX_REGISTER command execution. This member can be used to
> >> > check whether one application is mpx enabled.
> > The register and unregister operations seem to be almost the same thing.
> >  How about just PR_SYNC_MPX?
>
> That wouldn't support a usage model where userspace wanted to keep using
> MPX, but wanted the kernel to butt out and not try to free unused bounds
> tables.  That's not super-important, but it does lose some level of
> flexibility.
>

Hmm.  How about PR_SET/GET_MPX_BOUNDS_TABLE, to update the kernel's
copy.  No fpu magic needed.

This has an added benefit: CRIU will need updating for MPX, and
they'll appreciate having the required interface already exist.
(They'll want a way to allocate "MPX" memory, too, but that's probably
somewhat less important, and it won't result in duplicated
functionality.)

> FWIW, I think it would also be handy to support a PR_MPX_DISABLE prctl
> too.  That way, a wrapper program could set a flag that any children
> could notice if they try a PR_MPX_REGISTER.  That way we could
> software-disable MPX in cases in a process tree where it was not wanted.

Seccomp can do this :)

--Andy

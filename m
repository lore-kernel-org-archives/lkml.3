Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483AbaJ0L4V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 07:56:21 -0400
Received: from unicorn.mansr.com ([81.2.72.234]:56087 "EHLO unicorn.mansr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751191AbaJ0L4U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 07:56:20 -0400
X-Greylist: delayed 421 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Oct 2014 07:56:19 EDT
From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
To: Will Deacon <will.deacon@arm.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>, Russell King <linux@arm.linux.org.uk>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm\@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Rob Clark <robdclark@gmail.com>
Subject: Re: [PATCH v2 2/3] ARM: vfp: Fix VFPv3 hwcap detection on CPUID based cpus
References: <1413294539-22069-1-git-send-email-sboyd@codeaurora.org>
	<1413294539-22069-3-git-send-email-sboyd@codeaurora.org>
	<20141027103118.GA8768@arm.com>
Date: Mon, 27 Oct 2014 11:49:15 +0000
In-Reply-To: <20141027103118.GA8768@arm.com> (Will Deacon's message of "Mon,
	27 Oct 2014 10:31:18 +0000")
Message-ID: <yw1xppddwx50.fsf@unicorn.mansr.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will Deacon <will.deacon@arm.com> writes:

> Perhaps it would be better to consider exposing the ID registers to
> userspace in some manner? This could be done either via an undef handler, or
> using the vdso. We would add a (final) hwcap advertising this cpuid support.
> For big/little systems, the kernel would need to expose a suitable subset of
> the features (we already have the sanity checking code from Rutland).

This was discussed a few years ago, and some people raised various
objections.  Off the top of my head:

- Some features (e.g. VFP/NEON) need kernel support, and if this is not
  enabled, the actual system capabilities will not match the raw
  register value.  Fudging the values exposed to userspace would be
  fragile.
  (This argument has some merit.)

- Only v7 and newer CPUs have the CPUID registers.  Ridiculously old
  CPUs don't even have a CP15.  Providing synthetic values might be
  tricky.  Software thus needs to support alternate feature detection
  methods for such hardware.
  (This is true enough.)

- It would only be available on new kernels, so software would still
  need a fallback to another method for the foreseeable future.
  (This is a rather lazy argument.)

- It would be specific to Linux, so software can't rely on it anyway.
  (This is an even lazier argument.)

-- 
Måns Rullgård
mans@mansr.com

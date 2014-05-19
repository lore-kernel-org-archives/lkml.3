Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854AbaESKTB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 06:19:01 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:17393 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753434AbaESKS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 06:18:58 -0400
Date: Mon, 19 May 2014 11:18:49 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Paul Bolle <pebolle@tiscali.nl>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: remove ARM710 specific assembler code
Message-ID: <20140519101848.GG5113@arm.com>
References: <1364507176.1345.45.camel@x61.thuisdomein>
 <8309592.drxAj71PnZ@wuerfel>
 <1400059550.31197.12.camel@x220>
 <4305975.PvMXZQ020k@wuerfel>
 <1400232598.20342.16.camel@x220>
 <20140516125545.GO3693@n2100.arm.linux.org.uk>
 <20140517092337.GA67711@MacBook-Pro.local>
 <20140517094636.GP3693@n2100.arm.linux.org.uk>
 <9DBC3527-1961-40DD-8CBA-9A1B5D3003C9@arm.com>
 <20140517102638.GQ3693@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140517102638.GQ3693@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 17, 2014 at 11:26:38AM +0100, Russell King - ARM Linux wrote:
> On Sat, May 17, 2014 at 10:56:02AM +0100, Catalin Marinas wrote:
> > > The difference between what you're proposing and what happened to ARMv3
> > > is that ARMv3 was broken for quite some time (we read from some of the
> > > CP15 registers which are read-only in ARMv3) and no one ever raised a
> > > problem with that.  So, after a sufficient period of time, it got removed
> > > - and no one batted an eyelid.  That's the correct way to do it - allow
> > > code to age, and if no one notices it's been broken, then it can be
> > > removed.
> > 
> > I’m more for pro-actively “breaking” it with a DEPRECATED
> > dependency. For example, if you suspect that some code like ARM710T is
> > no longer in use, we mark it and see if anyone complains about this over
> > a two years period. If not, it gets removed.
> > 
> > Waiting for code to get broken is another way but it’s less
> > predictable.
> 
> When code being used gets broken, it's nice to think that we'll get
> bug reports which will tell us if it's still being used.

But if you don't get any reports, you can't really whether it's broken
(just because it compiles doesn't mean it still works). So we end up
with keeping code in the kernel for much longer than necessary.

> The problem
> with DEPRECATED is that it will get lost amongst all the thousands
> of other config options and won't be noticed.  Just like EXPERIMENTAL
> or any of the other similar options we've had.

DEPRECATED is meant for documenting the planned removal. If people
complain afterwards, it's their problem for not reporting it earlier.

But we can make it even clearer by adding "depends on n" for DEPRECATED
or just making it not user selectable, so that people would need to
actively change the Kconfig source. They can't complain they haven't
noticed.

-- 
Catalin

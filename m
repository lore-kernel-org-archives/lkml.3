Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152Ab3JDLue (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 07:50:34 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40474 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753518Ab3JDLuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 07:50:32 -0400
Date: Fri, 4 Oct 2013 12:50:22 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Olof Johansson <olof@lixom.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-msm@vger.kernel.org, Feng Kan <fkan@apm.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Kumar Gala <galak@codeaurora.org>
Subject: Re: Use of drivers/platform and matching include?
Message-ID: <20131004115022.GN12758@n2100.arm.linux.org.uk>
References: <BC1C47B3-5412-4829-A1D9-AAB04694D1CC@codeaurora.org> <CAOesGMjJ6Uj0uGFJqtnWQyDW+tr6eLVWoHZ+B7uFna+L8N6E8Q@mail.gmail.com> <20131003170914.GA11992@kroah.com> <CAOesGMhBaj14++kJ9tVko68MjC7D+JZrBRgoxa4zmZ9z186MQw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOesGMhBaj14++kJ9tVko68MjC7D+JZrBRgoxa4zmZ9z186MQw@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 03, 2013 at 10:54:07AM -0700, Olof Johansson wrote:
> It wouldn't be a huge deal to add something like arch/arm/syslib and
> give some of the system library-type code a home there -- stuff like
> resource allocation libraries, etc. I don't think we want to collect
> all the back-end drivers in there though, just libraries.

We don't need yet another subdirectory in arch/arm - yes, that's a
favourite way of avoiding any issues, but really it's not the right
answer.  We already have a place for shared cross-platform code, and
it's called arch/arm/common.

> I think many of us are hesitant to introduce something that runs the
> risk of becoming a dumping ground for all these "I don't know where to
> put them, so here you go" drivers, since we've spent so much time
> cleaning them all up and de-forking per-vendor implementations of
> similar things.

"Drivers go under drivers/" is what we've decided.  If we want to change
that, then we should move all those IRQ, gpio and clock drivers back out
of the drivers/ subtree, because many of them are SoC specific.

Please, think back to why we made the original decision(s) to move this
stuff out of arch/arm.

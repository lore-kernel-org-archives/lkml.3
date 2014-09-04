Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782AbaIDQsR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 12:48:17 -0400
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:55527 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754309AbaIDQsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 12:48:16 -0400
Date: Thu, 4 Sep 2014 17:47:09 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@kernel.org>
Cc: "H. Peter Anvin" <h.peter.anvin@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: RFC: Tainting the kernel on raw I/O access
Message-ID: <20140904174709.5bcb9b28@alan.etchedpixels.co.uk>
In-Reply-To: <20140904050739.GA27112@gmail.com>
References: <5407863B.9030608@intel.com>
	<20140904050739.GA27112@gmail.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Sep 2014 07:07:39 +0200
Ingo Molnar <mingo@kernel.org> wrote:

> 
> * H. Peter Anvin <h.peter.anvin@intel.com> wrote:
> 
> > In a meeting earlier today, we discussed MSR access and that it could be
> > used to do bad things.  The same applies to other forms of raw I/O
> > (/dev/mem, /dev/port, ioperm, iopl, etc.)
> > 
> > This is basically the same problem with which the secure boot people
> > have been struggling.
> > 
> > Peter Z. suggested we should taint the kernel on raw I/O access, and I
> > tend to concur.
> 
> Lets start with the 'only for developers and the crazy' 
> interfaces, like /dev/msr access, and extend it step by step?

/dev/msr is used by standard distribution tools like powertop, and by
chromeos power management layers like dptf.

msr writes might fit the crazy book but I think you'd need to take a
close look at the standard tools first

This is the need a whitelist problem.

Alan

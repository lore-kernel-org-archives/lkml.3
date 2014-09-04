Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632AbaIDQpK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 12:45:10 -0400
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:55506 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754404AbaIDQpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 12:45:06 -0400
Date: Thu, 4 Sep 2014 17:43:40 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        "H. Peter Anvin" <h.peter.anvin@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: RFC: Tainting the kernel on raw I/O access
Message-ID: <20140904174340.24e8bdc0@alan.etchedpixels.co.uk>
In-Reply-To: <540872E9.7060608@gmail.com>
References: <5407863B.9030608@intel.com>
	<87tx4op8s5.fsf@tassilo.jf.intel.com>
	<540872E9.7060608@gmail.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > As for the original purpose of taints, I'm not aware of any
> > problems with MSR access or port IO causing excessive 
> > kernel oops reports. Are you?

I'm not. From the bugzilla trends I don't think its a major cause, and we
can usually root out the "user with dumb external module" problem already.

> Really? Either one can be used to modify the running kernel (or
> microcode), and possibly even destroy hardware. 

At least on x86 I would hope not the latter at least on modern systems.
So the most irritating thing you can do is probably rootkit the box. It's
not as if you can't rootkit a typical distribution shipping Linux system
half a dozen other simpler ways than using I/O ports. Besides which once
someone has rootkitted your box it won't show the taint anyway !

As a security measure the tainting is next to useless.

As a debug aid it's potentially handy.

> > If there are none I don't think it makes sense.
> > 
> > At least personally I use MSR accesses quite frequently
> > for benign purposes.
> But how much of that is just reading MSR's, and of the writes, how much
> are either debugging or things that the average user isn't ever going to do?

Most of the uses are benign and sensible things like power monitoring
tools. 

Alan

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130AbaFJTUP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 15:20:15 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:33044 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758AbaFJTUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:20:14 -0400
Date: Tue, 10 Jun 2014 20:19:43 +0100
From: Sitsofe Wheeler <sitsofe@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Igor Mammedov <imammedo@redhat.com>, Toshi Kani <toshi.kani@hp.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [BISECTED][REGRESSION] Kernel does not boot on EeePC
Message-ID: <20140610191943.GA19896@sucs.org>
References: <20140608090223.GA8703@sucs.org>
 <20140608094517.GB12736@gmail.com>
 <5394A260.8000900@zytor.com>
 <20140609140215.GA1579@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140609140215.GA1579@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 09, 2014 at 04:02:15PM +0200, Ingo Molnar wrote:
> 
> * H. Peter Anvin <hpa@zytor.com> wrote:
> 
> > I really want to say *THANK YOU* to Sitsofe for a very timely and 
> > complete report.  You really saved us some highly valuable time.
> 
> Seconded!

You're welcome. For what it's worth these are the things that allowed
this drive-by testing to occur:

git bisect:
Without this there would have been a generic complaint that would have
only gone to the general kernel mailing list. I thought the issue was
going to lie with the GPU drivers but just following the bisection and
testing the final commit zoned in on the true cause.

Able to cut out most features:
I tend to build cut down kernels which only supports my hardware because
they take less time to compile and boot faster.

Single file builds:
I often do builds on Internet connected machines. Because I can 
can build everything in I only have one file to copy at the end.

Distro doesn't need initrd/initramfs:
One less thing to setup because everything is built in but some distros
seem dependent on having one these days.

I guess the one nice thing to have in the future would be a make
checkedconfig that automatically turned on all checking/verification
features (e.g. slab debugging/memory poisoning) for the current config.
This is would make it easier to get such kernels 

-- 
Sitsofe | http://sucs.org/~sits/

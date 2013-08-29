Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993Ab3H2XwD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 19:52:03 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:49863 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753503Ab3H2Xv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 19:51:59 -0400
Date: Thu, 29 Aug 2013 16:51:36 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>,
        David Howells <dhowells@redhat.com>, Ming Lei <ming.lei@canonical.com>,
        USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        arnd.bergmann@linaro.org, olof@lixom.net, benh@kernel.crashing.org
Subject: Re: Memory synchronization vs. interrupt handlers
Message-ID: <20130829235136.GX3871@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <Pine.LNX.4.44L0.1308281501000.1541-100000@iolanthe.rowland.org>
 <521E5D58.5070708@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <521E5D58.5070708@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082923-8236-0000-0000-0000014188B1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 28, 2013 at 01:28:08PM -0700, H. Peter Anvin wrote:
> On 08/28/2013 12:16 PM, Alan Stern wrote:
> > Russell, Peter, and Ingo:
> > 
> > Can you folks enlighten us regarding this issue for some common 
> > architectures?
> 
> On x86, IRET is a serializing instruction; it guarantees hard
> serialization of absolutely everything.

So a second interrupt from this same device could not appear to happen
before the IRET, no matter what device and/or I/O bus?  Or is IRET
defined to synchronize all the way out to the whatever device is
generating the next interrupt?

> I would expect architectures that have weak memory ordering to put
> appropriate barriers in the IRQ entry/exit code.

Adding a few on CC.  Also restating the question as I understand it:

	Suppose that a given device generates an interrupt on CPU 0,
	but that before CPU 0's interrupt handler completes, this device
	wants to generate a second interrupt on CPU 1.  This can happen
	as soon as CPU 0's handler does an EOI or equivalent.

	Can CPU 1's interrupt handler assume that all the in-memory effects
	of CPU 0's interrupt handler will be visible, even if neither
	interrupt handler uses locking or memory barriers?

							Thanx, Paul


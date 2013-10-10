Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752922Ab3JJEUD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 00:20:03 -0400
Received: from gate.crashing.org ([63.228.1.57]:38549 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752204Ab3JJEUC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 00:20:02 -0400
Message-ID: <1381378788.4330.30.camel@pasglop>
Subject: sysfs for my chips
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Thu, 10 Oct 2013 15:19:48 +1100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg !

(random CC list of clueful people)

On some new powerpc platforms (non-hypervisor or rather linux is the
hypervisor), I want to expose a bunch of stuff per "chip", the chips
being currently the processor chips and the "centaurs" (think of them as
the bottom half of the memory controllers).

Among other, I want a sysfs file in there to access "xscom" on the chip
which is a sideband bus used for low level stuff (think jtag on steroid)
which we can use, among others, for chip health monitoring, general
debugging and diagnostics, etc...

I might add more such as VPD, model information, etc... later or at
least a link to corresponding device-tree node.

How do you suggest I expose that ? So far I've been thinking about
something like

	/sys/chips/{processor,centaur}/chip#/files

or to avoid namespace clashes

	/sys/firmware/chips/{processor,centaur}/chip#/files

Or maybe just

	/sys/firmware/chips/chip#/files

(the chip type can be inferred from the chip#, they use the same space
at least as far my firmware exposes them to Linux)

(the actual access to xscom goes via firmware tho it makes *some* sense)

But I could instead create platform devices corresponding to the
device-tree representation of each of those chips ... and have the
platform devices contain the magic attributes. That's a bit more
convoluted though.

What's the current trend of the day for that sort of thing ? I'd rather
avoid yet-another-chardev-with-ioctl's here ...

Cheers,
Ben.



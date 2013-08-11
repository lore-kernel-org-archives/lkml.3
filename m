Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751738Ab3HKBqi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 21:46:38 -0400
Received: from netrider.rowland.org ([192.131.102.5]:51933 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751493Ab3HKBqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 21:46:35 -0400
Date: Sat, 10 Aug 2013 21:46:35 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Thomas Richter <richter@rus.uni-stuttgart.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: [HANG] Trouble with NEC-based USB adapter in PCMCIA slot on
 E7110
In-Reply-To: <52069907.6090602@rus.uni-stuttgart.de>
Message-ID: <Pine.LNX.4.44L0.1308102140420.10834-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Aug 2013, Thomas Richter wrote:

> Sorry, need to look further. I replaced ehci-pci from 2.6.31.14, and 
> yenta_socket as well. No changes were necessary. Also replaced ehci-hcd, 

Do you mean that you took the source code for ehci-hcd from the 2.6.31 
kernel, copied it into the source directory for the 2.6.32 kernel, and 
built it there?

> but that required two minor changes because in 2.6.32, apparently, one 
> hardware related structure was pulled out of the ehci structure.
> 
> Still did not make any difference, still locks up.
> 
> What's the next module up in the call chain I should be looking at?

Have you tried comparing a usbmon trace from 2.6.31 with a comparable 
trace from 2.6.32?  I doubt there will be any important differences, 
but you never know until you try.

If the two traces are the same, that rules out everything in the USB 
and SCSI stacks except for ehci-hcd, and you have already ruled that 
out.

Alan Stern


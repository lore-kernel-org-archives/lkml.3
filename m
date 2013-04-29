Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758814Ab3D2UbE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 16:31:04 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:51205 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757800Ab3D2UbC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 16:31:02 -0400
Date: Mon, 29 Apr 2013 15:01:14 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: debugging live kernel
To: lkml@tigusoft.pl
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <klllre$plq$1@ger.gmane.org> (from lkml@tigusoft.pl on Mon Apr
	29 06:34:08 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1367265674.18069.187@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/2013 06:34:08 AM, lkml@tigusoft.pl wrote:
> In case if my currently running kernel starts to do strange things  
> and I
> suspect it might have bug or was corrupted, what steps can be taken to
> check for more info, other then dmesg?

If you built it with kgdb, you can use that. If you have a jtag  
connected to the hardware, you can use that. If you built with kernel  
crash dumps, you can use that. If you kept the vmlinux file  
corresponding to your bzImage you can (VERY CAREFULLY) look at  
/dev/kmem with gdb (or use the corresponding system.map to decode  
addresses by hand; note this is horrible but possible)...

There's levels of difficulty here: "Kernel was hooked up to monitoring  
stuff before it went wrong" is the easy path. "Kept the box it came in"  
is the less easy path. "Flying blind on a rocketcycle" is not easy, and  
you pretty much have to have experience with the first two before you  
can even attempt the third. (And unless you're off in the enterprise  
space you generally go "Can I reproduce the issue? Let's reproduce it  
under a properly instrumented environment. If I _can't_ reproduce the  
issue then a reboot fixed it and we're good.)

Your problem description is way too vague to give specific advice  
about. "If I start to feel poorly, is there anything I can do to  
diagnose my illness?" Ummm... yes? (No, I'm not going to exchange a  
dozen emails with you to about it, and nothing here should be  
considered medical advice.)

Rob
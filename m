Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155Ab3I1VOc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 17:14:32 -0400
Received: from 87-127-191-49.static.enta.net ([87.127.191.49]:55918 "EHLO
	mail.linicks.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754873Ab3I1VO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 17:14:28 -0400
Date: Sat, 28 Sep 2013 22:14:26 +0100
From: Nick Warne <nick@linicks.net>
To: linux-kernel@vger.kernel.org, linux-apci@vger.kernel.org
Subject: Re: Samsung N145 Plus lid state issue on sleep
Message-ID: <20130928211426.GA11350@sauron>
References: <20130920195939.GA2353@sauron>
 <20130922104023.GA2332@sauron>
 <20130926172500.GA7036@sauron>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130926172500.GA7036@sauron>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 26, 2013 at 06:25:00PM +0100, Nick Warne wrote:
> Hi all,
> 
> I have a strange problem, which has been on going on for ages, and I finally decided to look at it (as it is a pain in the arse).
> 
> Brief details:
> 
> Samsung N145 Plus running Slack 14 with handbuilt kernel
> Kernel: Linux 3.11.1 #3 SMP Mon Sep 23 19:09:00 BST 2013 i686 Intel(R) Atom(TM) CPU N455   @ 1.66GHz GenuineIntel GNU/Linux
> I have no modules built in (.config on request if it helps).
> 
> This issue also happened with 'distro' kernel builds... so either it is BIOS issue or hardware fault.  But just in case:
> 
> Boot laptop into console - no X - so running pure acpi events.
> 
> cat /proc/acpi/button/lid/LID0/state
> state:      open
> 
> shut lid
> 
> laptop goes to sleep all great.
> 
> open lid.  Laptop wakes up, video, wlan0 all comes on line, everything hunky dory - but:
> 
> cat /proc/acpi/button/lid/LID0/state
> state:      closed
> 
> The lid is open, of course!
> 
> OK, shut lid.  LCD backlight goes off (so something knows the lid is shut), but no sleep event.  Open lid after a few seconds (maybe 10), and screen lights up and then laptop goes to sleep!
> 
> Shut lid (wait for a few seconds), open lid, laptop wakes up fine again, and now:
> 
> cat /proc/acpi/button/lid/LID0/state
> state:      open
> 
> !
> 
> So it appears that closing lid flags 'closed' state but opening it doesn't flag 'open' state... unless I then close it again and open which then flags 'closed' state when open so goes to sleep.  So no open it again, and 'state now reports 'open' again.  At this point, back to square one (confused?  I am!).
> 
> Using Fn [sleep] in any mode above works OK.  The same happens in X using xfce4 PM or similar.
> 
> What is confusing me is that something can see the lid flapping as backlight works on lid open/close.
> 
> acpi_listen reports the events as described above, but I can't work out how to record the events when a sleep :)
> 
> And ideas/help etc. appreciated, and also I am in the position to be able to debug (with help, of course)!

OK, doing a lot of research, it appears the dsdt is well fubarred.

I have now managed to get a clean build of the extracted dsdt, and testing with various (LIDS) stuff in the code it seems that something is drastically wrong.

Anyhow, I have now got a decent working dsdt that at least sleeps everytime on lid close - although it then goes to sleep again after lid is open, but I can handle that (reverse of my original problem, almost, but at least lid close makes it sleep 100%).

Sleep button (Fn Esc) works as it should.

Anybody good at asl coding?  There is some thing obvioulsy wrong with the logic in this code.

Nick
-- 
FSF Associate Member 5508
http://linicks.net/

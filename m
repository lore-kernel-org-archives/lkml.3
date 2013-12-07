Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759233Ab3LGX6o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Dec 2013 18:58:44 -0500
Received: from qmta03.westchester.pa.mail.comcast.net ([76.96.62.32]:45220
	"EHLO qmta03.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754303Ab3LGX6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Dec 2013 18:58:41 -0500
X-Greylist: delayed 365 seconds by postgrey-1.27 at vger.kernel.org; Sat, 07 Dec 2013 18:58:41 EST
To: linux-kernel@vger.kernel.org
From: Karl Dahlke <eklhad@comcast.net>
Reply-to: Karl Dahlke <eklhad@comcast.net>
User-Agent: edbrowse/3.4.9
Subject: Bug in tty cooked mode kernel 3.12.3
Date: Sat, 07 Dec 2013 18:46:07 -0500
Message-ID: <20131107184607.eklhad@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This may have appeared in 3.9.11 with the changes to tty.
Don't know; I just started running 3.12 from kernel.org.
Perhaps nobody saw it before because nobody runs command line programs,
we're all on desktops or x or whatever,
and even those in the command line are still raw.
bash is raw by default, but I run it cooked.
You can supress its readline functions like this.

set +o emacs
set +o vi
set +o histexpand
set +o history

That puts its tty back into cooked mode.

Come up in run level 3, command line mode,
and bring up two consoles with bash in cooked mode as above.
Set a simple prompt like this.

PS1='$ '

Switch to console 2 via alt-f2.
Hit return.
The cursor should drop to a new line then give you the $ prompt.
But it puts the $ prompt next too the old one, then drops down
to a blank line.
The $ prompt and the crlf are out of sequence.
Hit return a few more times and it will straighten itself out.
Then switch back to console 1 alt-f1
Hit return and the same bug,
$ $

hit return a few more times to straighten it out.
Switch back to console 2 and the same problem.
For me it's repeatable.

It's also very confusing when I'm running other command line programs with cooked tty.
For unknown reasons the crlf can come out at the wrong time,
breaking lines or leaving lines together.
My editor can run either way, so I've switched it over to readline mode
and I haven't noticed any problems this way, yet.
But I would prefer the cooked mode.

I looked through MAINTAINERS but couldn't find
a clear maintainer for drivers/tty/tty*.c
Please forward this to the appropriate people.

Thank you.

Karl Dahlke

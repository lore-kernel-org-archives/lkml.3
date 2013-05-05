Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751183Ab3EEAke (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 May 2013 20:40:34 -0400
Received: from ppp121-44-32-163.lns20.syd6.internode.on.net ([121.44.32.163]:50019
	"EHLO mail.enc.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931Ab3EEAkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 May 2013 20:40:33 -0400
X-Greylist: delayed 601 seconds by postgrey-1.27 at vger.kernel.org; Sat, 04 May 2013 20:40:32 EDT
Date: Sun, 5 May 2013 10:30:28 +1000
From: Craig Small <csmall@enc.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, Craig Small <csmall@enc.com.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] TTY: fix atime/mtime regression
Message-ID: <20130505003028.GA24796@enc.com.au>
References: <CA+55aFxVDub+aXyOrojz_yRCHHG50MnviOjP_-uRxKLuQRYXUw@mail.gmail.com>
 <1366976933-5514-1-git-send-email-jslaby@suse.cz>
 <CA+55aFxwCY3uagCUf1th6sr5+HGO0Mba-dhS-OtsnJ6o41JANw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxwCY3uagCUf1th6sr5+HGO0Mba-dhS-OtsnJ6o41JANw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 26, 2013 at 10:02:12AM -0700, Linus Torvalds wrote:
> Craig, background: the current git kernel (so 3.9, and these commits
> will presumably be back-ported) does not update tty timestamps very
> often, because you can use the timestamps to look at peoples typing
> behavior. Initially it didn't update the timestamps AT ALL, but that
> broke the whole idle routine. Now it updates it only at minute
> boundaries, so things like "w" _work_, but the hundreth-of-a-second
> idle precision is obviously just totally random noise.
I've always personally got confused with that field!  Joey Hess kept
bugging me for the -o option which was derived from w.bassman though
its been so long ago I forget where that came from.

I saw someone wants the 10 second resolution, can I get it confirmed
that the kernel will only be updating at minute intervals (so the .1 
second stuff is completely useless) or 10 second (so the .1 second
stuff is just confusing for most of us).

I'll then make some sort of change to w, possibly flipping the logic of
the -o flag.

 - Craig
-- 
Craig Small VK2XLZ   http://enc.com.au/          csmall at : enc.com.au
Debian GNU/Linux     http://www.debian.org/      csmall at : debian.org
GPG fingerprint:     5D2F B320 B825 D939 04D2  0519 3938 F96B DF50 FEA5

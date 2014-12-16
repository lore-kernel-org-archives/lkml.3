Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791AbaLPCr7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 21:47:59 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:49978 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758AbaLPCry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 21:47:54 -0500
Date: Mon, 15 Dec 2014 18:47:50 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Borislav Petkov <bp@alien8.de>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, patchwork@lists.ozlabs.org
Subject: Re: Maintainer abuse
Message-ID: <20141216024750.GD9759@ld-irv-0074>
References: <alpine.DEB.2.11.1412130016090.16494@nanos>
 <20141212234336.GA28451@pd.tnic>
 <20141213135231.5684cf9d@lxorguk.ukuu.org.uk>
 <alpine.DEB.2.11.1412151211520.16494@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1412151211520.16494@nanos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+ patchwork devs

On Mon, Dec 15, 2014 at 12:15:35PM +0100, Thomas Gleixner wrote:
> On Sat, 13 Dec 2014, One Thousand Gnomes wrote:
> > Is it the year for a Google summer of code project or similar to turn
> > patchwork into a proper patch management tool (one that collects the
> > patches, provides a good maintainer interface, tells people automatically
> > that their patches are queued, deletes repeats, gives them status urls
> > they can give to managers or check, and also has the right bits
> > maintainer side to actually do stuff like send out "your patch set no
> > longer merges, please update" emails, and tell the maintainer if it
> > merges, the coding style important bits, etc and with buttons for "merge
> > me"

Patchwork definitely could use some work to help it scale better. Your
todo list also sounds interesting.

> If that works with command line tools which nicely integrate into
> e-mail, that might be something useful. If it involves browser clicky
> interfaces, then at least for me not so much.

Patchwork has an XML-based RPC interface and a command-line 'pwclient'
tool which uses it. I've had moderate success hooking this into mutt
myself.

> > It could then be integrated into git (if only so we can have a "git lost"
> > command to block annoying sources)

Not sure exactly what this is referring to, but patchwork has a
rudimentary post-receive hook already which can be used to map patch
diffs back to their likely patch source and update its status
accordingly. e.g.,

   git push myremote HEAD:next

could mark all myremote/next..HEAD patches as 'Awaiting Upstream', and

   git push myremote HEAD:for-linus

could mark myremote/for-linus..HEAD as 'Accepted'. This is a bit of a
crapshoot if you haven't resolved the 'duplicate patches' problem
though.

Regards,
Brian

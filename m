Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762424AbaGRWWf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 18:22:35 -0400
Received: from imap.thunk.org ([74.207.234.97]:44404 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759315AbaGRWWd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 18:22:33 -0400
Date: Fri, 18 Jul 2014 18:22:15 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Andrey Utkin <andrey.krieger.utkin@gmail.com>
Cc: kernelnewbies@kernelnewbies.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Subject: Re: How to automate checkpatch && get_maintainers && git send-email
 of commits range?
Message-ID: <20140718222215.GF18775@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Andrey Utkin <andrey.krieger.utkin@gmail.com>,
	kernelnewbies@kernelnewbies.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org
References: <CANZNk81LiTM9vY0dRV=T0BCT9k-BxU45Ojw_PyOcpdmtXHKM2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANZNk81LiTM9vY0dRV=T0BCT9k-BxU45Ojw_PyOcpdmtXHKM2Q@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 05:38:30PM +0300, Andrey Utkin wrote:
> Is there script for automated checkpatch.pl && get_maintainers.pl &&
> git send-email for range of commits? I see none. Would it be welcome
> to submit such one to kernel tree?

Too much automation can be a really bad thing.  You **really** want to
sanity check the output of checkpatch.pl and get_maintainers.pl.
Their output is not always correct, and some amount of human common
sense is required.  (Granted Nick Krause hasn't shown much in the way
of common sense, but some human intervention --- assuming he is human
and not an badly written, automated troll program --- is better than
none.)

The other thing is that I strongly recommend that people use git
format-patch first, to make sure that what you will be blasting out to
thousands of peoples' mail boxes is in fact sane.

And then think very hard about which patches people need to see in
order to be able to evaluate a patch.  For example, if you have patch
1 out of a series which adds a new function, and then patches 2
through 1000 modify a thousand different drivers to use that new
function, if you use an automated get_maintainers.pl script to send
each patch to just the maintainer, then the device driver maintainer
might not see patch #1 which is critical context to understanding the
patch that you want to make to his driver.  And then you will have
several hundred very angry and annoyed developers wondering why you
sent them patch 345/1000, with no other context, and wondering what
the heck they are supposed to do with the email that you have just
launched into their inbox.

There's a reason why many developers cordially hate these scripts;
it's too easy to misuse them, and unfortunately, there are too many
Nick Krause like idiots out there who mindlessly use such scripts and
cause pain to maintainers.  The critical step is to force such idiots
to stop and ***think*** and unfortunately, automation seems to
encourage the opposite behaviour.

Regards,

						- Ted

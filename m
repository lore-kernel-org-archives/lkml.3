Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754973AbaKPCFW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2014 21:05:22 -0500
Received: from imap.thunk.org ([74.207.234.97]:60810 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751099AbaKPCFT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2014 21:05:19 -0500
Date: Sat, 15 Nov 2014 21:05:11 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Andy Lutomirski <luto@amacapital.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Michael Kerrisk-manpages <mtk.manpages@gmail.com>,
        Linux API <linux-api@vger.kernel.org>,
        linux-man <linux-man@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] groups: Allow unprivileged processes to use
 setgroups to drop groups
Message-ID: <20141116020511.GB5507@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Josh Triplett <josh@joshtriplett.org>,
	Andy Lutomirski <luto@amacapital.net>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kees Cook <keescook@chromium.org>,
	Michael Kerrisk-manpages <mtk.manpages@gmail.com>,
	Linux API <linux-api@vger.kernel.org>,
	linux-man <linux-man@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <3ccec8a13019b5e8ce7b1d7889677b778b070dc8.1416041823.git.josh@joshtriplett.org>
 <0895c1f268bc0b01cc6c8ed4607d7c3953f49728.1416041823.git.josh@joshtriplett.org>
 <87d28osceg.fsf@x220.int.ebiederm.org>
 <20141115192924.GB19060@thin>
 <CALCETrUM=GqsOumTmDMF4B5GS1w=x56t41eE-2xW1bBOfUz02w@mail.gmail.com>
 <20141115202042.GA20900@thin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141115202042.GA20900@thin>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 15, 2014 at 12:20:42PM -0800, Josh Triplett wrote:
> > However, sudoers seems to allow negative group matches.  So maybe
> > allowing this only with no_new_privs already set would make sense.
> 
> Sigh, bad sudo.  Sure, restricting this to no_new_privs only seems fine.
> I'll do that in v2, and document that in the manpage.

I've also seen use cases (generally back in the bad old days of big
timesharing VAX 750's :-) where the system admin might assign someone
to the "games-abusers" group, and then set /usr/games to mode 705
root:games-abusers --- presumably because it's easier to add a few
people to the deny list rather than having to add all of the EECS
department to the games group minus the abusers.

So arbitrarily anyone to drop groups from their supplemental group
list will result in a change from both existing practice and legacy
Unix systems, and it could potentially lead to a security exposure.

Cheers,

						- Ted

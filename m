Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755107AbaKPDkS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2014 22:40:18 -0500
Received: from imap.thunk.org ([74.207.234.97]:60880 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754934AbaKPDkP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2014 22:40:15 -0500
Date: Sat, 15 Nov 2014 22:40:06 -0500
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
Message-ID: <20141116034005.GC5507@thunk.org>
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
 <20141116020511.GB5507@thunk.org>
 <6C690A2C-8EB1-421A-94C3-9803AFB95760@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6C690A2C-8EB1-421A-94C3-9803AFB95760@joshtriplett.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 15, 2014 at 06:35:05PM -0800, Josh Triplett wrote:
> >So arbitrarily anyone to drop groups from their supplemental group
> >list will result in a change from both existing practice and legacy
> >Unix systems, and it could potentially lead to a security exposure.
> 
> As Andy pointed out, you can already do that with a user namespace,
> for any case not involving a setuid or setgid (or otherwise
> privilege-gaining) program.  And requiring no_new_privs handles
> that.

Well, it's no worse than what we can do already with the user
namespace, yes.  I'm still worried it's going to come as a surprise
for some configurations because it's a change from what was allowed
historically.  Then again, pretty much all of the tripwire and rootkit
scanners won't notice a "setuid" program that uses capabilities
instead of the traditional setuid bit, and most sysadmins won't think
to check for an executable with a forced capability mask, so this
isn't exactly a new problem....

							- Ted
							

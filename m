Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755168AbaKPCfY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2014 21:35:24 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:44855 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755091AbaKPCfW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2014 21:35:22 -0500
X-Originating-IP: 172.56.33.26
User-Agent: K-9 Mail for Android
In-Reply-To: <20141116020511.GB5507@thunk.org>
References: <3ccec8a13019b5e8ce7b1d7889677b778b070dc8.1416041823.git.josh@joshtriplett.org> <0895c1f268bc0b01cc6c8ed4607d7c3953f49728.1416041823.git.josh@joshtriplett.org> <87d28osceg.fsf@x220.int.ebiederm.org> <20141115192924.GB19060@thin> <CALCETrUM=GqsOumTmDMF4B5GS1w=x56t41eE-2xW1bBOfUz02w@mail.gmail.com> <20141115202042.GA20900@thin> <20141116020511.GB5507@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH 2/2] groups: Allow unprivileged processes to use setgroups to drop groups
From: Josh Triplett <josh@joshtriplett.org>
Date: Sat, 15 Nov 2014 18:35:05 -0800
To: "Theodore Ts'o" <tytso@mit.edu>
CC: Andy Lutomirski <luto@amacapital.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Michael Kerrisk-manpages <mtk.manpages@gmail.com>,
        Linux API <linux-api@vger.kernel.org>,
        linux-man <linux-man@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <6C690A2C-8EB1-421A-94C3-9803AFB95760@joshtriplett.org>
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On November 15, 2014 6:05:11 PM PST, Theodore Ts'o <tytso@mit.edu> wrote:
>On Sat, Nov 15, 2014 at 12:20:42PM -0800, Josh Triplett wrote:
>> > However, sudoers seems to allow negative group matches.  So maybe
>> > allowing this only with no_new_privs already set would make sense.
>> 
>> Sigh, bad sudo.  Sure, restricting this to no_new_privs only seems
>fine.
>> I'll do that in v2, and document that in the manpage.
>
>I've also seen use cases (generally back in the bad old days of big
>timesharing VAX 750's :-) where the system admin might assign someone
>to the "games-abusers" group, and then set /usr/games to mode 705
>root:games-abusers --- presumably because it's easier to add a few
>people to the deny list rather than having to add all of the EECS
>department to the games group minus the abusers.
>
>So arbitrarily anyone to drop groups from their supplemental group
>list will result in a change from both existing practice and legacy
>Unix systems, and it could potentially lead to a security exposure.

As Andy pointed out, you can already do that with a user namespace, for any case not involving a setuid or setgid (or otherwise privilege-gaining) program.  And requiring no_new_privs handles that.

Given the combination of those two things, do you still see any problematic cases?

- Josh Triplett


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543AbaKPTM3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 14:12:29 -0500
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:33293 "EHLO
	relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152AbaKPTM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 14:12:27 -0500
X-Originating-IP: 50.43.41.112
Date: Sun, 16 Nov 2014 11:12:19 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Michael Kerrisk-manpages <mtk.manpages@gmail.com>,
        Linux API <linux-api@vger.kernel.org>,
        linux-man <linux-man@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] groups: Allow unprivileged processes to use
 setgroups to drop groups
Message-ID: <20141116191219.GD5032@thin>
References: <0895c1f268bc0b01cc6c8ed4607d7c3953f49728.1416041823.git.josh@joshtriplett.org>
 <87d28osceg.fsf@x220.int.ebiederm.org>
 <20141115192924.GB19060@thin>
 <CALCETrUM=GqsOumTmDMF4B5GS1w=x56t41eE-2xW1bBOfUz02w@mail.gmail.com>
 <20141115202042.GA20900@thin>
 <20141116020511.GB5507@thunk.org>
 <6C690A2C-8EB1-421A-94C3-9803AFB95760@joshtriplett.org>
 <87vbmfq1uw.fsf@x220.int.ebiederm.org>
 <20141116133230.GA32030@thunk.org>
 <CALCETrUPsH_So2Mgk38Fe_pjp5Y+cgjzCUe7fzFcnsFzivHeNA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrUPsH_So2Mgk38Fe_pjp5Y+cgjzCUe7fzFcnsFzivHeNA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 16, 2014 at 07:42:30AM -0800, Andy Lutomirski wrote:
> On Sun, Nov 16, 2014 at 5:32 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> > On Sat, Nov 15, 2014 at 09:08:07PM -0600, Eric W. Biederman wrote:
> >>
> >> That may be a bug with the user namespace permission check.  Perhaps we
> >> shouldn't allow dropping groups that aren't mapped in the user
> >> namespace.
> >
> > I'm not saying that we can't change the behavior of whether or not a
> > user can drop a group permission.  I'm just saying that we need to do
> > so consciously.  The setgroups()/getgroups() ABI isn't part of
> > POSIX/SuSv3 so we wouldn't be breaking POSIX compatibility, for those
> > people who care about that.
> 
> It may make sense to reach out to some place like oss-security.
> 
> FWIW, I think we should ask, at the same time, about:
> 
>  - Dropping supplementary groups.
>  - Switching gid/egid/sgid to a supplementary group.
>  - Denying ptrace of a process with supplementary groups that the
> tracer doesn't have.

I wonder how crazy it would be to just require either CAP_SYS_PTRACE or
cred1 == cred2 (as in, you have *exactly* the same credentials as the
target)?

> Also, I much prefer a sysctl to a boot option.  Boot options are nasty
> to configure in many distributions.

Agreed.

- Josh Triplett

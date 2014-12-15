Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751013AbaLOUtq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 15:49:46 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41399 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbaLOUto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 15:49:44 -0500
Date: Mon, 15 Dec 2014 20:49:30 +0000
From: Serge Hallyn <serge.hallyn@ubuntu.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-man <linux-man@vger.kernel.org>, Kees Cook <keescook@chromium.org>,
        Richard Weinberger <richard@nod.at>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Josh Triplett <josh@joshtriplett.org>, stable <stable@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Kenton Varda <kenton@sandstorm.io>,
        LSM <linux-security-module@vger.kernel.org>,
        Michael Kerrisk-manpages <mtk.manpages@gmail.com>,
        Linux API <linux-api@vger.kernel.org>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [CFT] Can I get some Tested-By's on this series?
Message-ID: <20141215204930.GD28877@ubuntumail>
References: <87a92xn2io.fsf@x220.int.ebiederm.org>
 <87r3w8liw4.fsf@x220.int.ebiederm.org>
 <87iohklfvj.fsf_-_@x220.int.ebiederm.org>
 <87mw6vh31e.fsf_-_@x220.int.ebiederm.org>
 <20141210224822.GG20012@ubuntumail>
 <87lhmcy2et.fsf@x220.int.ebiederm.org>
 <20141212220840.GF22091@castiana.ipv6.teksavvy.com>
 <8761dgze56.fsf@x220.int.ebiederm.org>
 <20141215193838.GB28375@ubuntumail>
 <8761dcwu40.fsf@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8761dcwu40.fsf@x220.int.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> Serge Hallyn <serge.hallyn@ubuntu.com> writes:
> 
> > Quoting Eric W. Biederman (ebiederm@xmission.com):
> >> Stéphane Graber <stgraber@ubuntu.com> writes:
> >> 
> >> > On Fri, Dec 12, 2014 at 03:38:18PM -0600, Eric W. Biederman wrote:
> >> >> Serge Hallyn <serge.hallyn@ubuntu.com> writes:
> >> >> 
> >> >> > Quoting Eric W. Biederman (ebiederm@xmission.com):
> >> >> >> 
> >> >> >> Will people please test these patches with their container project?
> >> >> >> 
> >> >> >> These changes break container userspace (hopefully in a minimal way) if
> >> >> >> I could have that confirmed by testing I would really appreciate it.  I
> >> >> >> really don't want to send out a bug fix that accidentally breaks
> >> >> >> userspace again.
> >> >> >> 
> >> >> >> The only issue sort of under discussion is if there is a better name for
> >> >> >> /proc/<pid>/setgroups, and the name of the file will not affect the
> >> >> >> functionality of the patchset.
> >> >> >> 
> >> >> >> With the code reviewed and written in simple obviously correct, easily
> >> >> >> reviewable ways I am hoping/planning to send this to Linus ASAP.
> >> >> >> 
> >> >> >> Eric
> >> >> >
> >> >> > Is there a git tree we can clone?
> >> >> 
> >> >> Have either of you been able to check to see if any of my changes
> >> >> affects lxc?
> >> >> 
> >> >> I am trying to gauge how hard and how fast I should push to Linus.  lxc
> >> >> being the largest adopter of unprivileged user namespaces for general
> >> >> purpose containers.
> >> >> 
> >> >> I expect you just call newuidmap and newgidmap and don't actually care
> >> >> about not being able to set gid_map without privilege.  But I really
> >> >> want to avoid pushing a security fix and then being surprised that
> >> >> things like lxc break.
> >> >> 
> >> >> Eric
> >> >
> >> > Hi Eric,
> >> >
> >> > I've unfortunately been pretty busy this week as I was (well, still am)
> >> > travelling to South Africa for a meeting. I don't have a full kernel
> >> > tree around here and a full git clone isn't really doable over the kind
> >> > of Internet I've got here :)
> >> >
> >> > Hopefully Serge can give it a quick try, otherwise I should be able to
> >> > do some tests on Tuesday when I'm back home.
> >> 
> >> I thought Serge was going to but I haven't heard yet so I am prodding ;-)
> >
> > Ok, thanks - yes, unprivileged lxc is working fine with your kernels.
> > Just to be sure I was testing the right thing I also tested using
> > my unprivileged nsexec testcases, and they failed on setgroup/setgid
> > as now expected, and succeeded there without your patches.
> 
> Thanks.
> 
> Serge unless you object will add your Tested-By to my pull message to Linus.

Sounds good.

> Minor question do you runprivileged nsexec test cases test to see if the
> write to gid_map succeeds?  I would have expected the gid_map write to
> fail before the setgroups setgid system calls came into play.

Yes, I did that by hand, and it failed (with your kernel).

-serge

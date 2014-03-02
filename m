Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544AbaCBWjc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 17:39:32 -0500
Received: from mail-ob0-f173.google.com ([209.85.214.173]:34021 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348AbaCBWjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 17:39:12 -0500
From: yaro@marupa.net
To: usspookslovesystmd@muchomail.com
Cc: yaro@marupa.net, scott.ferguson.debian.user@gmail.com,
        debian-devel@lists.debian.org, debian-ctte@lists.debian.org,
        debian-vote@lists.debian.org, debian-project@lists.debian.org,
        linux-kernel@vger.kernel.org, pascal@plouf.fr.eu.org,
        cbannister@slingshot.co.nz, andreimpopescu@gmail.com,
        ghaverla@materialisations.com, debian-mirrors@lists.debian.org,
        debian-security@lists.debian.org, debian-user@lists.debian.org
Subject: Re: Four people decided the fate of debian with systemd. Bad faith likely - SysV is fine
Date: Sun, 02 Mar 2014 16:39:11 -0600
Message-ID: <66372183.jmchDdSAh1@twilight>
User-Agent: KMail/4.12.2 (Linux/3.12.13-1-ck; KDE/4.12.2; x86_64; ; )
In-Reply-To: <20140302142352.52A6A3E3@m0005309.ppops.net>
References: <20140302142352.52A6A3E3@m0005309.ppops.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fine, I'll just poke at this reply since it's that asinine. But this is 
probably my last post in this thread since the idiocy from this poster has 
gone from "curiously amusing" to "stupidly annoying."

By the way, I noticed you changed your fake email at least once in this 
thread. I'm guessing you noticed people are starting to block you. Ever think 
why?

On Sunday, March 02, 2014 02:23:52 PM NoTo CTTE wrote:
> You say nothing because there is nothing that you can say.
> 

I say nothing because you're just insulting my intelligence.

> Simplicity is beautiful, and it works.
> 

Initscripts are not simple. At all. Have you even looked at an initscript? I'm 
thinking no.

> Systemd is a nightmare, 

Why? What makes it a nightmare? Have you even used systemd or are you just 
trolling?

> but you are using politics and psyops to push it on
> every single linux user, every distro, everywhere.
> 

Uh... no, I gave valid technical reasons why systemd is better. Dependency-
based concurrent boot with cgroups control. And that's just ONE reason.

You're the one coming on here making paranoid claims about systemd being an 
attempt to conquer Linux. I didn't make any political claims at any point in 
this entire thread.

> I showed you code that does your vaunted concurrent boot systemddeeeee in a
> few lines of shell.
> 

That's not shell, that's C. You don't even know what a shall script is, I'm 
thinking.

Also, it doesn't do concurrency at all the same way as systemd does. Do you 
even know how SysV and systemd work? I'm guessing, again, no.

> That simplicity was the way unix and linux was, before the windows
> programmers and the govt funded companies sunk their teeth into linux.
> 

Hahaha. Initscripts are NOT simple. Please. PLEASE, do yourself a favor and 
actually look at an initscript. Educate yourself. You're making yourself look 
like an idiot.

> You know what & does.
> I guess not, you're too new to gnu.
> 

Don't presume to know how long I've been using Linux. Judging by your complete 
and utter lack of technical knowledge I'm willing to bet I've been using Linux 
and the GNU toolchain a heck of a lot longer than you have.

> --- yaro@marupa.net wrote:
> 
> From: yaro@marupa.net
> To: usspookslovesystmd@muchomail.com
> Subject: Re: Four people decided the fate of debian with systemd. Bad faith
> likely - SysV is fine Date: Sun, 02 Mar 2014 16:15:41 -0600
> 
> On Sunday, March 02, 2014 02:12:48 PM NoTo CTTE wrote:
> > System V is NOT hard to "maintain"

Clearly you never wrote a shell script or tried to fix one. I have. I've also 
worked with unit files. It's no contest that systemd unit files are much simpler 
and easier to work with,

> > The scripts were written YEARS ago. They're fine. They do NOT need to be
> > changed. Debian SysV has concurrent boot aswell.
> > 

As concurrent as initscripts can safely get, which isn't that far. And hell 
yes they need to be changed. Ever administrate a Debian Stable server? I 
welcome a change to systemd on my server, way less hassle.

> > Systemd is a poison apple. 200k lines of unaudited root privlege code. A
> > consulting service to go along with this new _operating system_
> > 

Who says it's unaudited? You? Do you know how much work the DDs put into 
supporting their packages? I don't think you do.

What new operating system?

Are you aware SysV also runs with root privileges? And it probably exposes the 
system to more hazards given how many more processes it has to spawn over the 
courseof just ONE initscript?

> > Here's an under 100 line init with concurrent boot:
> > 
> > #include <signal.h>
> > #include <unistd.h>
> > 
> > int main()
> > {
> > sigset_t set;
> > int status;
> > 
> > if (getpid() != 1) return 1;
> > 
> > sigfillset(&set);
> > sigprocmask(SIG_BLOCK, &set, 0);
> > 
> > if (fork()) for (;;) wait(&status);
> > 
> > sigprocmask(SIG_UNBLOCK, &set, 0);
> > 
> > setsid();
> > setpgid(0, 0);
> > return execve("/etc/rc", (char *[]){ "rc", 0 }, (char *[]){ 0 });
> > }

The above is not an initscript. I'll concede it's a poorly thought out init 
with a badly implemented concurrency setup, but your attempt to make systemd's 
concurrency look like nothing special is laughable.

> > 
> > >/etc/rc is a shell script
> > >syslogd && getty ; udev ; network-config ; sshd & cron & nginx

Your point? What's so great about shell scripts? They're overcomplex, hard to 
maintain, difficult to test and debug, spend more time in boilerplate than 
system management, and are prone to failure. Nothign I say here is new/

> > 
> > see how much bullsht systemd is.

I see how much bullshit your claims are.

> > 
> > 
> > _____________________________________________________________
> > The Free Email with so much more!
> > =====> http://www.MuchoMail.com <=====
> 
> It'd be almost too easy to mock a laughable post like this, but I'll let
> someone else do it. It's just not fun anymore.
> 
> Conrad
> 
> 
> 
> 
> _____________________________________________________________
> The Free Email with so much more!
> =====> http://www.MuchoMail.com <=====


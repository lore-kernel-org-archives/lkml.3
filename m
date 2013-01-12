Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751853Ab3ALFJV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 00:09:21 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:65376 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737Ab3ALFJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 00:09:19 -0500
X-Nat-Received: from [202.181.97.72]:60944 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1357967335.10608
To: eparis@redhat.com
Cc: linux-kernel@vger.kernel.org, dwalsh@redhat.com, dmalcolm@redhat.com,
        sds@tycho.nsa.gov, segoon@openwall.com,
        linux-security-module@vger.kernel.org
Subject: Re: Friendlier EPERM - Request for input
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <1357747463.2593.28.camel@localhost>
	<1357760637.2593.55.camel@localhost>
	<201301110014.CDB90164.MFtFHVSQOFOJLO@I-love.SAKURA.ne.jp>
	<1357835679.1342.45.camel@localhost>
In-Reply-To: <1357835679.1342.45.camel@localhost>
Message-Id: <201301121408.GCH51539.SFOVOFLJMOFHQt@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sat, 12 Jan 2013 14:08:50 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 12012013 #9025758, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Paris wrote:
> On Fri, 2013-01-11 at 00:14 +0900, Tetsuo Handa wrote:
> > The reason I think is that people turn off LSMs because they are using LSMs
> > without understanding "what the current configuration is" and/or "how to change
> > configuration". People do not spend (or cannot afford spending) resources for
> > understanding LSM's configuration.
> 
> This is not the point I am arguing.  This is not about LSMs, how hard
> they are to configure, or how to 'fix' them.  It certainly isn't about
> how one LSM is better, easier, or superior to another.  This is about
> getting more information in userspace when operations fail.  I'll quote
> an off list e-mail I received:
> 
> Friendlier/more complete error messages would eliminate an awful lot of
> digging around trying to figure *what* the problem is, preparatory to
> discerning *where* the problem is and *how* to fix it.

I agree that having a mechanism to allow the caller to know the reason of
failure would be nice. What I'm worrying is that they will simply disable the
LSM (e.g. "setenforce 0") even if users are promptly told (via e.g. perror())
that "Cannot open foo for reading: Denied by SELinux" unless very serious
effort to allow users to understand "what the current configuration is" and
"how to change configuration" is made.

While SELinux provides many boolean configuration options, basic stance of
SELinux sounds (at least to me) that "users need not to understand/know SELinux
configuration; we won't ask users to understand/know SELinux configuration".
This is horrible for enterprise systems because who builds a system and who
uses/maintains that system are generally different (and therefore builder's
administration skill and user/maintainer's administration skill may drastically
differ). The person who builds a system is unlikely contactable when the person
who uses/maintains that system encountered a trouble. My fear is that
"Friendlier EPERM" results in saving only debugging time until LSM is disabled
by the builder/user/maintainer.

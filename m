Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751915Ab3IMFJd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 01:09:33 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:43271 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582Ab3IMFJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 01:09:31 -0400
Date: Fri, 13 Sep 2013 07:09:28 +0200
From: Ingo Molnar <mingo@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] perf fixes
Message-ID: <20130913050927.GA8634@gmail.com>
References: <CA+55aFwgyjqRHxLaWGxxsg_v07FrxbVTeLdHTGp7MfeSRjrKsQ@mail.gmail.com>
 <CA+55aFyCeXXr=57em8CC_Uzfk5PvOw0RHyA309wuOP-oDL7VxA@mail.gmail.com>
 <20130912184341.GA11400@ghostprotocols.net>
 <52321CE4.1080804@gmail.com>
 <20130912201855.GC32644@gmail.com>
 <20130912203831.GD11400@ghostprotocols.net>
 <20130912204618.GA3262@gmail.com>
 <52322D81.5090708@gmail.com>
 <20130912211846.GA7890@gmail.com>
 <52323BE4.5080100@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52323BE4.5080100@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Ahern <dsahern@gmail.com> wrote:

> > By default a simple 'make' should build perf to the maximum extent 
> > possible, with no other input required from the user - with warnings 
> > displayed as package install suggestions.
> 
> By default there is no config. Autoprobing generates a first one or a 
> user can specify a defconfig.

This could work if there's not two but three states for individual 
features:

  - autoprobe
  - on
  - off

and if autoprobe, if a system feature has been probed successfully, 
automatically turned 'autoprobe' entries into 'on'.

That would give us the best of all worlds - autodetection, configurability 
and caching:

 - initial user types 'make' and gets a .config that has almost all
   entries 'on', a few 'autoprobe'.

 - once the user installs a dependency, the corresponding .config entry
   turns into 'on'.

 - the regular user or developers would have libraries that turn all
   entries in the .config to 'on'.

 - if a user is genuinely uninterested in a feature, he can mark it 'off', 
   which would then stay off permanently. This could also be used by
   embedded/specialized builds.

 - other specialized users, like distro builds, could use a .config with
   all entries 'on' and could enforce the presence of all dependencies for 
   a successful build. [We could add 'make allyesconfig' to help that.]

Thanks,

	Ingo

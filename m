Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933294Ab3HNVWd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 17:22:33 -0400
Received: from jenson.atom.hu ([62.112.193.66]:49536 "EHLO jenson.atom.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933191Ab3HNVWc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 17:22:32 -0400
From: Gergely Risko <gergely@risko.hu>
To: Michal Hocko <mhocko@suse.cz>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org
Subject: Re: [PATCH] mm: memcontrol: fix handling of swapaccount parameter
References: <1376486495-21457-1-git-send-email-gergely@risko.hu>
	<20130814183604.GE24033@dhcp22.suse.cz>
	<20130814184956.GF24033@dhcp22.suse.cz>
Date: Wed, 14 Aug 2013 23:22:23 +0200
In-Reply-To: <20130814184956.GF24033@dhcp22.suse.cz> (Michal Hocko's message
	of "Wed, 14 Aug 2013 20:49:56 +0200")
Message-ID: <87ioz855o0.fsf@gergely.risko.hu>
User-Agent: GNU Emacs with Gnus
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Aug 2013 20:49:56 +0200, Michal Hocko <mhocko@suse.cz> writes:

> On Wed 14-08-13 20:36:04, Michal Hocko wrote:
>> On Wed 14-08-13 15:21:35, Gergely Risko wrote:
>> > Fixed swap accounting option parsing to enable if called without argument.
>> 
>> We used to have [no]swapaccount but that one has been removed by a2c8990a
>> (memsw: remove noswapaccount kernel parameter) so I do not think that
>> swapaccount without any given value makes much sense these days.
>
> Now that I am reading your changelog again it says this is a fix. Have
> you experienced any troubles because of the parameter semantic change?

Yeah, I experienced trouble, I was new to all of this containers +
cgroups + namespaces thingies and while trying out stuff it was totally
impossible for me to enable swap accounting and I didn't understand why.

In Debian swap accounting is off by default, even when you
cgroup_enable=memory.  So you have to explicitly enable swapaccounting.

I've found the following documentation snippets all pointing to enable
swap accounting by just simply adding "swapaccount" to the kernel
command line.  They all state that "swapaccount" is enough, no need for
"swapaccount=1" (actually some of them don't even mention =1 at all):
  - make menuconfig documentation for swap accounting,
  - /usr/share/doc/lxc/README.Debian from the lxc package,
  - Documentation/kernel-parameters.txt:
	swapaccount[=0|1]
			[KNL] Enable accounting of swap in memory resource
			controller if no parameter or 1 is given or disable
			it if 0 is given (See Documentation/cgroups/memory.txt),
  - the comment in the source code just above the line ("consider enabled
    if no parameter or 1 is given").

And of course it's a trivial thing for the user to try swapaccount=1
when simply swapaccount doesn't work, but it's still a very bad
experience, because the documentation seems to be clear and every
command line change requires a reboot.

It's OK for me if we fix the documentation instead of the code.  But
notice that the code is trivial to fix and the documentation has already
spread out to various debian packages, internet forums, bug reports,
etc.  So it seems to be less hassle to actually implement the
documentation than to document the code.

Gergely

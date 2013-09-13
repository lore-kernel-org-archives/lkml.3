Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992Ab3IMRPh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 13:15:37 -0400
Received: from mail-vb0-f52.google.com ([209.85.212.52]:43265 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036Ab3IMRPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 13:15:34 -0400
MIME-Version: 1.0
In-Reply-To: <20130913094555.GA11611@gmail.com>
References: <20130912184341.GA11400@ghostprotocols.net>
	<52321CE4.1080804@gmail.com>
	<20130912201855.GC32644@gmail.com>
	<20130912203831.GD11400@ghostprotocols.net>
	<20130912204618.GA3262@gmail.com>
	<52322D81.5090708@gmail.com>
	<20130912211846.GA7890@gmail.com>
	<52323BE4.5080100@gmail.com>
	<20130913050927.GA8634@gmail.com>
	<CAFrcx1=7Crxms8GBaen451JuYPO_WpC_SbcTuti5y3MfeQMCZA@mail.gmail.com>
	<20130913094555.GA11611@gmail.com>
Date: Fri, 13 Sep 2013 19:15:33 +0200
Message-ID: <CAFrcx1=+m7tnBDAN_uNHfz5mrCBPRyGuhxj=_BzWYu84FcXqwQ@mail.gmail.com>
Subject: Re: [GIT PULL] perf fixes
From: Jean Pihet <jean.pihet@linaro.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 September 2013 11:45, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Jean Pihet <jean.pihet@linaro.org> wrote:
>
>> Hi,
>>
>> On 13 September 2013 07:09, Ingo Molnar <mingo@kernel.org> wrote:
>> >
>> > * David Ahern <dsahern@gmail.com> wrote:
>> >
>> >> > By default a simple 'make' should build perf to the maximum extent
>> >> > possible, with no other input required from the user - with warnings
>> >> > displayed as package install suggestions.
>> >>
>> >> By default there is no config. Autoprobing generates a first one or a
>> >> user can specify a defconfig.
>> >
>> > This could work if there's not two but three states for individual
>> > features:
>> >
>> >   - autoprobe
>> >   - on
>> >   - off
>> >
>> > and if autoprobe, if a system feature has been probed successfully,
>> > automatically turned 'autoprobe' entries into 'on'.
>> >
>> > That would give us the best of all worlds - autodetection, configurability
>> > and caching:
>> >
>> >  - initial user types 'make' and gets a .config that has almost all
>> >    entries 'on', a few 'autoprobe'.
>> >
>> >  - once the user installs a dependency, the corresponding .config entry
>> >    turns into 'on'.
>> >
>> >  - the regular user or developers would have libraries that turn all
>> >    entries in the .config to 'on'.
>> >
>> >  - if a user is genuinely uninterested in a feature, he can mark it 'off',
>> >    which would then stay off permanently. This could also be used by
>> >    embedded/specialized builds.
>> >
>> >  - other specialized users, like distro builds, could use a .config with
>> >    all entries 'on' and could enforce the presence of all dependencies for
>> >    a successful build. [We could add 'make allyesconfig' to help that.]
>>
>> Is there a way to detect the presence of a dependency and _also_ check
>> its version? Some new features are depending on a recent version of a
>> library, e.g. dwarf unwinding depends on libunwind >= 1.1 (cf.
>> http://www.spinics.net/lists/kernel/msg1598951.html).
>
> Yeah, see the testcases in tools/perf/config/feature-tests.mak, they
> typically include the latest library API usages, which will fail on older
> versions.
Ok!
I just sent a patch to feature-tests.mak for the newly added dwarf
unwinding feature ('perf tools: Check libunwind for availability of
dwarf parsing feature').

Thanks,
Jean

>
> That kind of 'does it actually work?' test is a lot more robust than
> explicit version checks, and combined with caching it should be fast and
> parallelizable as well. (One of the problems of the current simple
> implementation of the feature tests is that they are 20 serial tests with
> no parallelization.)
>
> Thanks,
>
>         Ingo

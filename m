Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933092Ab3GCSko (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 14:40:44 -0400
Received: from mga11.intel.com ([192.55.52.93]:60259 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932882Ab3GCSkn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 14:40:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,989,1363158000"; 
   d="scan'208";a="360089721"
From: "Dilger, Andreas" <andreas.dilger@intel.com>
To: Greg KH <greg@kroah.com>, Dave Chinner <david@fromorbit.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "Theodore Ts'o" <tytso@mit.edu>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "Drokin, Oleg" <oleg.drokin@intel.com>
Subject: Re: [GIT PULL] ext4 updates for 3.11
Thread-Topic: [GIT PULL] ext4 updates for 3.11
Thread-Index: AQHOd4CrS2aK5u+qFkKcSBY4ZrI70ZlSlgmAgAABGoCAAADSgIAAKX2AgAD2v4D//6MzAA==
Date: Wed, 3 Jul 2013 18:40:40 +0000
Message-ID: <CDF9C6B7.51285%andreas.dilger@intel.com>
In-Reply-To: <20130703181249.GA21797@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.254.78.168]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8EEE1B4F3556DD4F80590F0D46B5BA2F@intel.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/03/07 12:12 PM, "Greg KH" <greg@kroah.com> wrote:

>On Wed, Jul 03, 2013 at 01:29:41PM +1000, Dave Chinner wrote:
>> On Tue, Jul 02, 2013 at 06:01:11PM -0700, Greg KH wrote:
>> > On Tue, Jul 02, 2013 at 05:58:15PM -0700, Linus Torvalds wrote:
>> > > On Tue, Jul 2, 2013 at 5:54 PM, Greg KH <greg@kroah.com> wrote:
>> > > > On Tue, Jul 02, 2013 at 05:02:21PM -0700, Linus Torvalds wrote:
>> > > >>
>> > > >> I'm really not convinced this whole Lustre thing was correctly
>> > > >> handled. Merging it into stable and yet being in such bad shape
>>that
>> > > >> it isn't enabled even there? I just dunno. But I have the turd
>>in my
>> > > >> tree now, let's hope it gets fixed up.
>> > > >
>> > > > It's in "staging", not "stable" :)
>> > > 
>> > > Yes. But what was the reason to actually merge it even there? And
>>once
>> > > it gets merged, disabling it again rather than fixing the problems
>>it
>> > > has?
>> > 
>> > The problems turned out to be too big, too late in the merge cycle for
>> > me to be able to take them (they still aren't even done, as I don't
>>have
>> > a working set of patches yet.)  So I just disabled it from the build
>>to
>> > give Andreas and team time to get it working properly.

In our defence, the code has been working fine for years, but only on
vendor
kernels, so we are playing catch-up to the mainline kernel, and hit a
bunch of
snags when merging into -next.

Also, all of the configure checks have been removed from the version
submitted
to the kernel, so this caused some breakage on platforms that Lustre
actually
runs on regularly (e.g. PPC).  On the flip side, nobody ever uses Lustre
on S390
or 32-bit clients, so it is no surprise that there were problems there.

>> > I could have just removed it, but I thought I would give them a
>>chance.

Thanks.  The code is just too big to get it ready for inclusion in one
piece,
and the only way that we can make it acceptable for mainline kernel
inclusion
is through -staging and incrementally cleaning it up.

>> > > This is a filesystem that Intel apparently wants to push. I think it
>> > > would have been a better idea to push back a bit and say "at least
>> > > clean it up a bit first". It's not like Intel is one of the clueless
>> > > companies that couldn't have done so and need help from the
>>community.

Well, it's been around for 10 years, and is pretty much the standard
filesystem
in HPC.  While we are part of Intel now, there is still only a limited
number of
people working on it, and we don't have free reign to focus on getting it
into
the kernel.  We still have customers to support and bugs to fix and
features to
develop for the next huge systems (1B cores writing 300TB/s to 1EB fs in
2018).
At the same time, there is enough demand in the
workgroup/department/university
scale that it makes sense to try and get it into mainline.

It isn't that we didn't want to get it into the kernel previously, but
-staging
didn't always exist and we don't have enough resources at one time to
rewrite
all of the code.  Thanks to Peng Tao and EMC this is finally happening.
This
isn't "volunteer community" effort, there are dedicated resources working
on it.

>> > For this filesystem, it seems that they don't have any resources to do
>> > this work and are relying on the community to help out.  Which is odd,
>> > but big companies are strange some times...
>> 
>> Didn't we learn this lesson already with POHMELFS? i.e. that dumping
>> filesystem code in staging on the assumption "the community" will
>> fix it up when nobody in "the community" uses or can even test that
>> filesystem is a broken development model....
>
>They (Intel) has said that they will continue to clean up this code in
>the tree, until it is in good enough shape to be merged into fs/
>properly.  If they ever stop helping out, I will end up dropping it from
>the tree, just like I did for pohmelfs, so don't worry about it
>lingering around abandoned.

Right, we are going to continue working on cleaning the code at a steady
pace
until it is ready to move to fs/.  I don't expect Al or Dave or Christoph
to
spend their time (or make their eyes bleed) with the current state of the
code.
It has already undergone some significant cleanup, but needs a bunch more
still.

To be honest, I expect it will be in -staging for a year or so, but that is
fine with me since we've been working on it for 10+ years already and we
only
have so much capacity for changing/testing the code for the kernel while
keeping
all of the existing sites in working condition.

Cheers, Andreas
-- 
Andreas Dilger

Lustre Software Architect
Intel High Performance Data Division



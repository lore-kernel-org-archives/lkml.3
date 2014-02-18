Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727AbaBRJqw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 04:46:52 -0500
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:42307 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754472AbaBRJqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 04:46:49 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmwOALoqA1N5LJYe/2dsb2JhbABZgwY4g1mlHwORV4VUgRQXdIIlAQEFIw8BIyMQCAECEQMBAgECAgUhAgIPBQ0YAxMOE4dxAxAOjQqbf5lxDYgPFxaBE4s+GYIBB4JvNYEUBJZAgWuKUIIPhUWBb4FSKA
Date: Tue, 18 Feb 2014 20:46:44 +1100
From: Dave Chinner <david@fromorbit.com>
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Cc: Namjae Jeon <linkinjeon@gmail.com>, viro@zeniv.linux.org.uk, bpm@sgi.com,
        tytso@mit.edu, adilger.kernel@dilger.ca, jack@suse.cz,
        mtk.manpages@gmail.com, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ashish Sangwan <a.sangwan@samsung.com>
Subject: Re: [PATCH RESEND 3/10] ext4: Add support FALLOC_FL_COLLAPSE_RANGE
 for fallocate
Message-ID: <20140218094644.GD28666@dastard>
References: <1391319874-3203-1-git-send-email-linkinjeon@gmail.com>
 <alpine.LFD.2.00.1402111209450.2225@localhost.localdomain>
 <CAKYAXd-bD6ZZgpc9E8V1kD9Dj2wrCkbi1i6drNBdUAwsMiv5gg@mail.gmail.com>
 <alpine.LFD.2.00.1402181001530.2216@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.2.00.1402181001530.2216@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 10:05:49AM +0100, Lukáš Czerner wrote:
> On Wed, 12 Feb 2014, Namjae Jeon wrote:
> 
> > Date: Wed, 12 Feb 2014 11:28:35 +0900
> > From: Namjae Jeon <linkinjeon@gmail.com>
> > To: Lukáš Czerner <lczerner@redhat.com>
> > Cc: viro@zeniv.linux.org.uk, david@fromorbit.com, bpm@sgi.com, tytso@mit.edu,
> >     adilger.kernel@dilger.ca, jack@suse.cz, mtk.manpages@gmail.com,
> >     linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
> >     linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
> >     Namjae Jeon <namjae.jeon@samsung.com>,
> >     Ashish Sangwan <a.sangwan@samsung.com>
> > Subject: Re: [PATCH RESEND 3/10] ext4: Add support FALLOC_FL_COLLAPSE_RANGE
> >     for fallocate
> > 
> > 2014-02-11 20:59 GMT+09:00, Lukáš Czerner <lczerner@redhat.com>:
> > > On Sun, 2 Feb 2014, Namjae Jeon wrote:
> > >
> > >> Date: Sun,  2 Feb 2014 14:44:34 +0900
> > >> From: Namjae Jeon <linkinjeon@gmail.com>
> > >> To: viro@zeniv.linux.org.uk, david@fromorbit.com, bpm@sgi.com,
> > >> tytso@mit.edu,
> > >>     adilger.kernel@dilger.ca, jack@suse.cz, mtk.manpages@gmail.com
> > >> Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
> > >>     linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
> > >>     Namjae Jeon <linkinjeon@gmail.com>, Namjae Jeon
> > >> <namjae.jeon@samsung.com>,
> > >>     Ashish Sangwan <a.sangwan@samsung.com>
> > >> Subject: [PATCH RESEND 3/10] ext4: Add support FALLOC_FL_COLLAPSE_RANGE
> > >> for
> > >>     fallocate
> > >>
> > >> From: Namjae Jeon <namjae.jeon@samsung.com>
> > >>
> > >> Add support FALLOC_FL_COLLAPSE_RANGE for fallocate
> > Hi Lukas.
> > >
> > > Description is missing here, please provide FALLOC_FL_COLLAPSE_RANGE
> > > description so people know what it's supposed to be doing.
> > >
> > > more comments bellow.
> > Okay, I will udpate.
> > >
> > > Thanks!
> > > -Lukas
> 
> Hi,
> 
> you may have noticed my patches for new FALLOC_FL_ZERO_RANGE
> fallocate flag. This changes things around the same area as your
> patches does so we should probably figure out which are going to
> land in first and then rebase the other on top of that.
> 
> One concern I have is that I have not seen any tests provided to
> verify the feature. But I just may have missed it. Do you have any
> xfstests test or at least fsx and fsstress patches to provide
> support for testing FALLOC_FL_COLLAPSE_RANGE ? Patches for
> util_linux might also be handy.

There were 5 xfstests patches posted that used the
_test_generic_punch infrastructure to test this functionality.
See the december 08 index here, search for "shared/00[1-5]":

http://oss.sgi.com/archives/xfs/2013-12/index.html

They need a little rework, but otherwise the test code is there.
Having the feature added to fsx and fsstress would probably be a
good idea, though.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760167Ab3HOG3E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 02:29:04 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:39506 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753442Ab3HOG3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 02:29:01 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1308142316220.31947@nftneq.ynat.uz>
References: <520BB9EF.5020308@linux.intel.com> <20130814194359.GA22316@thunk.org>
 <520BED7A.4000903@intel.com> <20130814230648.GD22316@thunk.org>
 <CALCETrVaRQ3WQ5++Uu_0JTaVnjUugAaAhqQK__7r5YWvLxpAhw@mail.gmail.com>
 <20130815011101.GA3572@thunk.org> <20130815021028.GM6023@dastard>
 <CALCETrUfuzgG9U=+eSzCGvbCx-ZskWw+MhQ-qmEyWZK=XWNVmg@mail.gmail.com>
 <20130815060149.GP6023@dastard> <CALCETrUF+dGhE3qv4LoYmc7A=a+ry93u-d-GgHSAwHXvYN+VNw@mail.gmail.com>
 <alpine.DEB.2.02.1308142316220.31947@nftneq.ynat.uz>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 14 Aug 2013 23:28:40 -0700
Message-ID: <CALCETrUeodAKHAhqrSkd+bUn_qF=twRPraKrsfOmcg6Bp7VsvQ@mail.gmail.com>
Subject: Re: page fault scalability (ext3, ext4, xfs)
To: David Lang <david@lang.hm>
Cc: Dave Chinner <david@fromorbit.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Dave Hansen <dave.hansen@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>, xfs@oss.sgi.com,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 14, 2013 at 11:18 PM, David Lang <david@lang.hm> wrote:
> On Wed, 14 Aug 2013, Andy Lutomirski wrote:
>
>>> The big problem with this approach is that not doing the
>>> timestamp update on page faults is going to break the inode change
>>> version counting because for ext4, btrfs and XFS it takes a
>>> transaction to bump that counter. NFS needs to know the moment a
>>> file is changed in memory, not when it is written to disk. Also, NFS
>>> requires the change to the counter to be persistent over server
>>> failures, so it needs to be changed as part of a transaction....
>>
>>
>> NFS can do whatever it wants, although I suspect that even NFS can get
>> away with deferring cmtime updates.
>
>
> NFS already has to do syncs to make sure the data is safe on disk, have a
> flag that NFS can use to make the ctime safe, everyone else can get the
> performance improvement and NFS can have it's slow-but-safe approach.
>

I don't see the current code that updates times for NFS.  I'm not
planning on making any changes that'll affect NFS at all (i.e. I don't
think any flag will be needed), but I'd be more confident if I
understand why it worked in the first place.

(For filesystems that provide page_mkwrite, there hasn't been a
file_update_time call in the core code for several kernel versions.)

--Andy

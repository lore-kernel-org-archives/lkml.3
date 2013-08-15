Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760204Ab3HOGSY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 02:18:24 -0400
Received: from mail.lang.hm ([64.81.33.126]:44364 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752763Ab3HOGSW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 02:18:22 -0400
Date: Wed, 14 Aug 2013 23:18:01 -0700 (PDT)
From: David Lang <david@lang.hm>
X-X-Sender: dlang@asgard.lang.hm
To: Andy Lutomirski <luto@amacapital.net>
cc: Dave Chinner <david@fromorbit.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Dave Hansen <dave.hansen@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>, xfs@oss.sgi.com,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>
Subject: Re: page fault scalability (ext3, ext4, xfs)
In-Reply-To: <CALCETrUF+dGhE3qv4LoYmc7A=a+ry93u-d-GgHSAwHXvYN+VNw@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1308142316220.31947@nftneq.ynat.uz>
References: <520BB9EF.5020308@linux.intel.com> <20130814194359.GA22316@thunk.org> <520BED7A.4000903@intel.com> <20130814230648.GD22316@thunk.org> <CALCETrVaRQ3WQ5++Uu_0JTaVnjUugAaAhqQK__7r5YWvLxpAhw@mail.gmail.com> <20130815011101.GA3572@thunk.org>
 <20130815021028.GM6023@dastard> <CALCETrUfuzgG9U=+eSzCGvbCx-ZskWw+MhQ-qmEyWZK=XWNVmg@mail.gmail.com> <20130815060149.GP6023@dastard> <CALCETrUF+dGhE3qv4LoYmc7A=a+ry93u-d-GgHSAwHXvYN+VNw@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Aug 2013, Andy Lutomirski wrote:

>> The big problem with this approach is that not doing the
>> timestamp update on page faults is going to break the inode change
>> version counting because for ext4, btrfs and XFS it takes a
>> transaction to bump that counter. NFS needs to know the moment a
>> file is changed in memory, not when it is written to disk. Also, NFS
>> requires the change to the counter to be persistent over server
>> failures, so it needs to be changed as part of a transaction....
>
> NFS can do whatever it wants, although I suspect that even NFS can get
> away with deferring cmtime updates.

NFS already has to do syncs to make sure the data is safe on disk, have a flag 
that NFS can use to make the ctime safe, everyone else can get the performance 
improvement and NFS can have it's slow-but-safe approach.

David Lang

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751683Ab3HSXXr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 19:23:47 -0400
Received: from mail.lang.hm ([64.81.33.126]:34142 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751404Ab3HSXXp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 19:23:45 -0400
Date: Mon, 19 Aug 2013 16:23:23 -0700 (PDT)
From: David Lang <david@lang.hm>
X-X-Sender: dlang@asgard.lang.hm
To: Dave Chinner <david@fromorbit.com>
cc: Jan Kara <jack@suse.cz>, Andy Lutomirski <luto@amacapital.net>,
        "Theodore Ts'o" <tytso@mit.edu>, Dave Hansen <dave.hansen@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>, xfs@oss.sgi.com,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>
Subject: Re: page fault scalability (ext3, ext4, xfs)
In-Reply-To: <20130815212826.GS6023@dastard>
Message-ID: <alpine.DEB.2.02.1308191621130.30740@nftneq.ynat.uz>
References: <520BED7A.4000903@intel.com> <20130814230648.GD22316@thunk.org> <CALCETrVaRQ3WQ5++Uu_0JTaVnjUugAaAhqQK__7r5YWvLxpAhw@mail.gmail.com> <20130815011101.GA3572@thunk.org> <20130815021028.GM6023@dastard> <CALCETrUfuzgG9U=+eSzCGvbCx-ZskWw+MhQ-qmEyWZK=XWNVmg@mail.gmail.com>
 <20130815060149.GP6023@dastard> <CALCETrUF+dGhE3qv4LoYmc7A=a+ry93u-d-GgHSAwHXvYN+VNw@mail.gmail.com> <20130815071141.GQ6023@dastard> <20130815074531.GA2147@quack.suse.cz> <20130815212826.GS6023@dastard>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Aug 2013, Dave Chinner wrote:

> The problem with "not exported, don't update" is that files can be
> modified on server startup (e.g. after a crash) or in short
> maintenance periods when the NFS service is down. When the server is
> started back up, the change number needs to indicate the file has
> been modified so that clients reconnecting to the server see the
> change.
>
> IOWs, even if the NFS server is not up or the filesystem not
> exported we still need to update change counts whenever a file
> changes if we are going to tell the NFS server that we keep them...

This sounds like you need something more like relctime rather than noctime, 
something that updates the time in ram, but doesn't insist on flushing it to 
disk immediatly, updating when convienient or when the file is closed.

David Lang

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197Ab3AaIBX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 03:01:23 -0500
Received: from mx4-phx2.redhat.com ([209.132.183.25]:55449 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754688Ab3AaIBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 03:01:22 -0500
Date: Thu, 31 Jan 2013 03:01:10 -0500 (EST)
From: CAI Qian <caiqian@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com, linux-xfs@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Message-ID: <2103902716.11642129.1359619270232.JavaMail.root@redhat.com>
In-Reply-To: <20130131040748.GH32297@disturbed.disaster>
Subject: Re: 3.8-rc5 xfs corruption
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.13.37]
X-Mailer: Zimbra 7.2.0_GA_2669 (ZimbraWebClient - FF3.0 (Linux)/7.2.0_GA_2669)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



----- Original Message -----
> From: "Dave Chinner" <david@fromorbit.com>
> To: "CAI Qian" <caiqian@redhat.com>
> Cc: xfs@oss.sgi.com, linux-xfs@vger.kernel.org, "linux-kernel" <linux-kernel@vger.kernel.org>
> Sent: Thursday, January 31, 2013 12:07:48 PM
> Subject: Re: 3.8-rc5 xfs corruption
> 
> On Wed, Jan 30, 2013 at 10:16:47PM -0500, CAI Qian wrote:
> > Hello,
> > 
> > (Sorry to post to xfs mailing lists but unsure about which one is
> > the
> > best for this.)
> 
> Trimmed to just xfs@oss.sgi.com.
Thanks for quick response, Dave.
> 
> > I have seen something like this once during testing on a system
> > with a
> > EMC VNX FC/multipath back-end.
> 
> This is a trace from the verifier code that was added in 3.8-rc1 so
> I doubt it has anything to do with any problem you've seen in the
> past....
> 
> Can you tell us what workload you were running and what hardware you
> are using as per:
> 
> http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F
This was the system,
- AMD Opteron(tm) Processor 4130 (1 socket, 4 cores)
- PowerEdge R415 
- 8G memory
- mptsas local disks

Software version,
- xfsprogs-3.1.10

The workload was running some fs_mark, syscalls tests, some nfs/cifs
connectathon tests, memory, libhugetlbfs tests, and some dynamic debug
(Documentation/dynamic-debug-howto.txt) tests.
> 
> As it is, if you mounted the filesystem after this problem was
> detected, log recovery probably propagated it to disk. I'd suggest
> that you run xfs_repair -n on the device and post the output so we
> can see if any corruption has actaully made it to disk. If no
> corruption made it to disk, it's possible that we've got the
> incorrect verifier attached to the buffer.
The system was taken away from me, so I can only occupy it again later
if needed.

Regards,
CAI Qian
> 
> > [ 3025.063024] ffff8801a0d50000: 2e 2e 2f 2e 2e 2f 75 73 72 2f 6c
> > 69 62 2f 6d 6f  ../../usr/lib/mo
> 
> The start of a block contains a path and the only
> type of block that can contain this format of metadata is remote
> symlink block. Remote symlink blocks don't have a verifier attached
> to them as there is nothing that can currently be used to verify
> them as correct.
> 
> I can't see exactly how this can occur as stale buffers have the
> verifier ops cleared before being returned to the new user, and
> newly allocated xfs_bufs are zeroed before being initialised. I
> really need to know what you are doing to be able to get to the
> bottom of it....
> 
> Cheers,
> 
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
> 

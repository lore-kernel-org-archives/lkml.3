Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318AbaKFR0T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 12:26:19 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:39286 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbaKFR0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 12:26:16 -0500
To: Boaz Harrosh <boaz@plexistor.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@fb.com>, Matthew Wilcox <willy@linux.intel.com>,
        Dmitry Monakhov <dmonakhov@openvz.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Karel Zak <kzak@redhat.com>
Subject: Re: [PATCH 4/5] brd: Request from fdisk 4k alignment
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <545A2D69.8090003@plexistor.com> <545A2F52.3040303@plexistor.com>
	<yq1k339enl5.fsf@sermon.lab.mkp.net> <545A379D.30608@plexistor.com>
Date: Thu, 06 Nov 2014 12:25:56 -0500
In-Reply-To: <545A379D.30608@plexistor.com> (Boaz Harrosh's message of "Wed,
	05 Nov 2014 16:43:41 +0200")
Message-ID: <yq1sihwb5qz.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Boaz" == Boaz Harrosh <boaz@plexistor.com> writes:

Boaz,

Boaz> Note that blk_queue_physical_block_size() also trashes io_min, but
Boaz> we can leave this one to be 512. io_min as opposed to
Boaz> physical_block_size will actually change Kernel behavior

>> Care to elaborate?

I wanted you to elaborate on how io_min changes kernel behavior.

>> Also, fdisk and parted should be aligning on 1MB by default
>> regardless of block size. So I'm also not sure why you need to trick
>> fdisk to align by setting the pbs.

Boaz> fdisk will not align partition-start on 1M, only the very
Boaz> first-sector, libgparted and cfdisk are as you say, but with fdisk
Boaz> if you put any odd numbered partition-size, the next start-sector
Boaz> will just be the sum, but with this patch it will offer a small
Boaz> hole and will align the partition-start on 4K.  (And even with
Boaz> this patch user can enter bad values)

It really sounds like either your fdisk is way too old or you are
running it in DOS compat mode.

I don't have a fundamental issue reporting pbs of 4K. But if you are
only doing it to force a certain partition alignment then it sounds like
a kernel fix for a userland problem.

I've CC:ed Karel who can comment on fdisk partition alignment issues.

-- 
Martin K. Petersen	Oracle Linux Engineering

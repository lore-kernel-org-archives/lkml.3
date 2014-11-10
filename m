Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363AbaKJRAg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 12:00:36 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:42477 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229AbaKJRAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 12:00:35 -0500
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
	<yq1sihwb5qz.fsf@sermon.lab.mkp.net> <545FA9D4.5080908@plexistor.com>
Date: Mon, 10 Nov 2014 12:00:11 -0500
In-Reply-To: <545FA9D4.5080908@plexistor.com> (Boaz Harrosh's message of "Sun,
	09 Nov 2014 19:52:20 +0200")
Message-ID: <yq1389r6les.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Boaz" == Boaz Harrosh <boaz@plexistor.com> writes:

Boaz> I do not know why I thought that only io_min does that, I can see
Boaz> now that both effect the Kernel the same way. Which scares me a
Boaz> bit.

The difference is subtle. io_min is a hint from the storage about its
preferred minimum I/O size. pbs describes the smallest unit that can be
atomically written (like a sector on a drive with 512-byte logical/4K
physical blocks). In most cases they are the same, pbs is just a
slightly harder guarantee than io_min.

What I was objecting to in your patch description was mostly the
statement you made that these values affect kernel behavior. They really
don't. Not directly, anyway. The queue limits are stacked and offsets
are adjusted based on partitions, etc. But they don't alter the kernel
runtime behavior.

The queue limits are reported to userland and will affect things like
partitioning, MD/DM tooling and mkfs.*. And therefore they only
indirectly affect the kernel's behavior.

-- 
Martin K. Petersen	Oracle Linux Engineering

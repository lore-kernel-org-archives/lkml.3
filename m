Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756562Ab3EUH17 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 03:27:59 -0400
Received: from smtp2.macqel.be ([194.78.208.39]:28306 "EHLO smtp2.macqel.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756512Ab3EUH15 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 03:27:57 -0400
Date: Tue, 21 May 2013 09:27:54 +0200
From: Philippe De Muyter <phdm@macqel.be>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Karel Zak <kzak@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 2/5] Add aix lvm partitions support files
Message-ID: <20130521072754.GB19266@frolo.macqel>
References: <1367270313-18871-1-git-send-email-phdm@macqel.be> <1367270313-18871-3-git-send-email-phdm@macqel.be> <20130520163927.8e4c2fe753b60a02c368ceb5@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130520163927.8e4c2fe753b60a02c368ceb5@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Mon, May 20, 2013 at 04:39:27PM -0700, Andrew Morton wrote:
> On Mon, 29 Apr 2013 23:18:30 +0200 Philippe De Muyter <phdm@macqel.be> wrote:
> 
> > adding partitions/aix.h and partitions/aix.c
> > 
> > Partitions (called Logical Volumes in AIX) can be non-contiguous or
> > even split on more than one disk.  Altough we detect such partitions,
> > we cannot describe them to the Linux partitions layer, so we simply
> > discard them and issue a diagnose message.
> 
> This description is rather hard to follow.
> 
> It appears that the new code permits Linux to access some types of AIX
> partitions, but not other types, correct?  If so, can we please provide
> a more explicit description of which typesw are and are not supported?
> 

AIX LVM permits to make "logical volumes" which are made of multiple slices
of multiple disks.  The new code allows only access to the "logical volumes"
which are made of one slice on the probed disk, a slice being a contiguous
disk area.  The code also detects "logical volumes" made of multiple slices
on the probed disk, but can not describe them to the partition layer, because
the partition layer generic code does not support that.  When such
non-contiguous "logical volumes" are detected, a diagnostic message is
printed.

Philippe

-- 
Philippe De Muyter +32 2 6101532 Macq SA rue de l'Aeronef 2 B-1140 Bruxelles

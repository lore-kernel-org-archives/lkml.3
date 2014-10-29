Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756678AbaJ2TCu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 15:02:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40784 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756619AbaJ2TCs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 15:02:48 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: "Jason B. Akers" <jason.b.akers@intel.com>
Cc: linux-ide@vger.kernel.org, axboe@fb.com, kapil.karkra@intel.com,
        dan.j.williams@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/5] block, ioprio: include caching advice via ionice
References: <20141029180454.4879.75088.stgit@stg-AndroidDev-VirtualBox>
	<20141029182345.4879.98373.stgit@stg-AndroidDev-VirtualBox>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 29 Oct 2014 15:02:42 -0400
In-Reply-To: <20141029182345.4879.98373.stgit@stg-AndroidDev-VirtualBox>
	(Jason B. Akers's message of "Wed, 29 Oct 2014 11:23:45 -0700")
Message-ID: <x49bnoupulp.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Jason B. Akers" <jason.b.akers@intel.com> writes:

> From: Dan Williams <dan.j.williams@intel.com>
>
> Steal one unused bit from the priority class and two bits from the
> priority data, to implement a 3 bit cache-advice field.  Similar to the
> page cache advice from fadvise() these hints are meant to be consumed
> by hybrid drives.  Solid State Hyrbid-Drives, as defined by the SATA-IO
> Specification, implement up to a 4-bit cache priority that can be
> specified along with a FPDMA command.

ionice is about setting an I/O scheduling class for a *process*.  So,
unless I've missed something, this does not seem like the right
interface for passing I/O hints.

You mention fadvise hints, which sounds like a good fit (and madvise
would be equally interesting), but I don't see where you've wired them
up in this patch set.  Did I miss it?

Cheers,
Jeff

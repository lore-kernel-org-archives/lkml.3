Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753684AbaF0MBP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 08:01:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18170 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753419AbaF0MBN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 08:01:13 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Joe Lawrence <joe.lawrence@stratus.com>
Cc: Jens Axboe <axboe@kernel.dk>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/2] block,scsi: fixup blk_get_request dead queue scenarios
References: <1401909633-25931-1-git-send-email-joe.lawrence@stratus.com>
	<x49wqc34psf.fsf@segfault.boston.devel.redhat.com>
	<53AC461D.6080004@kernel.dk>
	<x49oaxf4mfo.fsf@segfault.boston.devel.redhat.com>
	<alpine.DEB.2.02.1406262319140.16358@jlaw-desktop.mno.stratus.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Fri, 27 Jun 2014 07:59:59 -0400
In-Reply-To: <alpine.DEB.2.02.1406262319140.16358@jlaw-desktop.mno.stratus.com>
	(Joe Lawrence's message of "Thu, 26 Jun 2014 23:23:29 -0400")
Message-ID: <x49egyaef5s.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Lawrence <joe.lawrence@stratus.com> writes:

> On Thu, 26 Jun 2014, Jeff Moyer wrote:
>> Thanks, Jens.  Joe, the patches don't apply anymore... would you mind
>> sending an updated set so Jens doesn't have to do the fixups?  I think
>> you also need to convert blk_mq_alloc_request, I didn't see that in your
>> patch.
>
> Hi Jeff,
>
> I have a new set that applies on top of 3.16-rc2... but before posting, I 
> wasn't sure what needs to be converted w/regard to blk_mq_alloc_request.  
> As far as I can tell, the new multi-queue block IO queueing implementation 
> via blk_mq_alloc_request should be safe from this bug as it doesn't 
> include any dead queue checks that introduce early exits.

Hi, Joe,

blk_mq_alloc_request will return NULL if blk_mq_queue_enter() returns
non-zero.

Cheers,
Jeff

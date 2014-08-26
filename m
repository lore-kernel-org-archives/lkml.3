Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892AbaHZWBi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 18:01:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57296 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755588AbaHZWBg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 18:01:36 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Joe Lawrence <joe.lawrence@stratus.com>, linux-kernel@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>, Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH v3 0/2] block,scsi: fixup blk_get_request dead queue scenarios
References: <1404329718-19367-1-git-send-email-joe.lawrence@stratus.com>
	<x49egw36u55.fsf@segfault.boston.devel.redhat.com>
	<53FCF9DB.6010501@kernel.dk>
	<x49mwar54ca.fsf@segfault.boston.devel.redhat.com>
	<53FCFD40.2010903@kernel.dk> <53FCFE01.8080701@kernel.dk>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 26 Aug 2014 18:01:23 -0400
In-Reply-To: <53FCFE01.8080701@kernel.dk> (Jens Axboe's message of "Tue, 26
	Aug 2014 15:37:05 -0600")
Message-ID: <x49iole6hcc.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <axboe@kernel.dk> writes:

>> I have applied the first one, will look over the second one and hand
>> apply it. Seems the NULL return was completely removed, so we _should_
>> be ok on the IS_ERR() conversion, though that sort of thing always
>> worries me a little bit. A NULL return can quickly show up again, and
>> then they would all fail.

Well, we could guard against that with a BUG_ON in blk_get_request,
right?

> Additionally, there's still quite a few places that call
> blk_get_request() and don't check the error return if __GFP_WAIT is set.
> Since most of the point of this is to fix segfaulting on queue dead
> scenarios, why aren't they all converted?

Odd, I thought they all were converted last I checked.  They definitely
should be.

-Jeff

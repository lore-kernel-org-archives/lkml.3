Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193AbaCLTe1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 15:34:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17346 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750967AbaCLTeX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 15:34:23 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Frank Mayhar <fmayhar@google.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel <linux-kernel@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Theodore Tso <tytso@google.com>
Subject: Re: [PATCH] block:  Force sector and nr_sects to device alignment and granularity.
References: <1394474492.31499.177.camel@bobble.lax.corp.google.com>
	<x49wqg0bwb4.fsf@segfault.boston.devel.redhat.com>
	<1394553778.31499.180.camel@bobble.lax.corp.google.com>
	<x491ty71dox.fsf@segfault.boston.devel.redhat.com>
	<1394649562.31499.202.camel@bobble.lax.corp.google.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 12 Mar 2014 15:33:58 -0400
In-Reply-To: <1394649562.31499.202.camel@bobble.lax.corp.google.com> (Frank
	Mayhar's message of "Wed, 12 Mar 2014 11:39:22 -0700")
Message-ID: <x49wqfzyzx5.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frank Mayhar <fmayhar@google.com> writes:

> On Wed, 2014-03-12 at 14:20 -0400, Jeff Moyer wrote:
>> but you managed to read my mind well enough.  The question is how high
>> up the stack do you put the logic for this?  Is it worth it to duplicate
>> the checks in the OS that are already done on the device?  I don't
>> know.  Martin, do you have an opinion on this?
>
> Well, my opinion (and I suspect that Ted agrees with me to at least some
> extent) is that this is where it should be, i.e. in the block layer, in
> the place that already knows about and deals with alignment and
> granularity.  Sure, you could leave it to the device itself but it seems
> reasonable to take care of this here for two reasons:  First, doing this
> means that if a TRIM is issued it will be successful and the intent of

No, TRIM is advisory, even for well-formed TRIMs.  I guess you could
alter the definition of successful and have a correct statement there.

> the discard will be at least partly satisfied.  Second, we're already
> doing most of the computations and making decisions based on the
> alignment and granularity anyway, so the overhead is pretty negligible
> (and if the discard size goes to zero we short-circuit the process and
> never go to the device at all).

Sure, there's no sense getting information from the device and not using
it.  I guess you've talked me into it.

Cheers,
Jeff

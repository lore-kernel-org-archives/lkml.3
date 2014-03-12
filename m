Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051AbaCLSj2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 14:39:28 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:46686 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755894AbaCLSjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 14:39:25 -0400
Message-ID: <1394649562.31499.202.camel@bobble.lax.corp.google.com>
Subject: Re: [PATCH] block:  Force sector and nr_sects to device alignment
 and granularity.
From: Frank Mayhar <fmayhar@google.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel <linux-kernel@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Theodore Tso <tytso@google.com>
Date: Wed, 12 Mar 2014 11:39:22 -0700
In-Reply-To: <x491ty71dox.fsf@segfault.boston.devel.redhat.com>
References: <1394474492.31499.177.camel@bobble.lax.corp.google.com>
	 <x49wqg0bwb4.fsf@segfault.boston.devel.redhat.com>
	 <1394553778.31499.180.camel@bobble.lax.corp.google.com>
	 <x491ty71dox.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-03-12 at 14:20 -0400, Jeff Moyer wrote:
> but you managed to read my mind well enough.  The question is how high
> up the stack do you put the logic for this?  Is it worth it to duplicate
> the checks in the OS that are already done on the device?  I don't
> know.  Martin, do you have an opinion on this?

Well, my opinion (and I suspect that Ted agrees with me to at least some
extent) is that this is where it should be, i.e. in the block layer, in
the place that already knows about and deals with alignment and
granularity.  Sure, you could leave it to the device itself but it seems
reasonable to take care of this here for two reasons:  First, doing this
means that if a TRIM is issued it will be successful and the intent of
the discard will be at least partly satisfied.  Second, we're already
doing most of the computations and making decisions based on the
alignment and granularity anyway, so the overhead is pretty negligible
(and if the discard size goes to zero we short-circuit the process and
never go to the device at all).
-- 
Frank Mayhar
310-460-4042


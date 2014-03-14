Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066AbaCNU0W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 16:26:22 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:16966 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755144AbaCNU0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 16:26:20 -0400
To: Frank Mayhar <fmayhar@google.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jeff Moyer <jmoyer@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Theodore Tso <tytso@google.com>
Subject: Re: [PATCH] block:  Force sector and nr_sects to device alignment and granularity.
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1394474492.31499.177.camel@bobble.lax.corp.google.com>
	<x49wqg0bwb4.fsf@segfault.boston.devel.redhat.com>
	<1394553778.31499.180.camel@bobble.lax.corp.google.com>
	<x491ty71dox.fsf@segfault.boston.devel.redhat.com>
	<yq1d2hq27jk.fsf@sermon.lab.mkp.net>
	<1394817430.31499.216.camel@bobble.lax.corp.google.com>
Date: Fri, 14 Mar 2014 16:26:08 -0400
In-Reply-To: <1394817430.31499.216.camel@bobble.lax.corp.google.com> (Frank
	Mayhar's message of "Fri, 14 Mar 2014 10:17:10 -0700")
Message-ID: <yq1vbvgwmqn.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.130005 (Ma Gnus v0.5) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Frank" == Frank Mayhar <fmayhar@google.com> writes:

Frank,

Frank> Well, in this particular case the driver is filling in the
Frank> relevant information (alignment and granularity) and then
Frank> complaining later that that information has been ignored.  As I
Frank> intimated earlier, it seems a little odd to allow the driver to
Frank> specify the information, only to ignore it completely when it's
Frank> time to actually use it.

Which driver is this?

In T10 SBC these values are performance hints, not hard
requirements. They were never intended as such.

Frank> Further, in my opinion this is less "dropping information" than
Frank> it is keeping information that would be dropped by the driver
Frank> itself; were it not for this adjustment, the driver would get the
Frank> request, complain, and drop it completely.  This way, as much of
Frank> the request as possible is preserved while still honoring the
Frank> constraints given by the driver.

The problem arises if you combine devices with different
granularity. The I/O topology code is then forced to scale the
granularity up.

If you enforce the granularity at the top of the stack it means the
device(s) with lesser granularity will lose information which would
otherwise be valuable to them.

We have previously entertained enforcing the granularity at the bottom
of the stack on a per-device basis. However, I stand by my opinion that
the device behavior is broken. I'd never let a device like that pass
qualification here...

-- 
Martin K. Petersen	Oracle Linux Engineering

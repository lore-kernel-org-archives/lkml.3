Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054AbaCMBsL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 21:48:11 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:39618 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013AbaCMBsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 21:48:09 -0400
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Frank Mayhar <fmayhar@google.com>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] block:  Force sector and nr_sects to device alignment and granularity.
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1394474492.31499.177.camel@bobble.lax.corp.google.com>
	<x49wqg0bwb4.fsf@segfault.boston.devel.redhat.com>
	<1394553778.31499.180.camel@bobble.lax.corp.google.com>
	<x491ty71dox.fsf@segfault.boston.devel.redhat.com>
Date: Wed, 12 Mar 2014 21:47:59 -0400
In-Reply-To: <x491ty71dox.fsf@segfault.boston.devel.redhat.com> (Jeff Moyer's
	message of "Wed, 12 Mar 2014 14:20:30 -0400")
Message-ID: <yq1d2hq27jk.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.130005 (Ma Gnus v0.5) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Jeff" == Jeff Moyer <jmoyer@redhat.com> writes:

>> The case that we were seeing was with an SSD that required TRIM on 8k
>> boundaries and with an 8k granularity.  Since the file system was
>> trying to do discards based on 4k alignment the driver complained
>> mightily.

Jeff> but you managed to read my mind well enough.  The question is how
Jeff> high up the stack do you put the logic for this?  Is it worth it
Jeff> to duplicate the checks in the OS that are already done on the
Jeff> device?  I don't know.  Martin, do you have an opinion on this?

I'm no big fan of dropping information.

My original intent with the discard granularity and alignment was to
allow filesystems to use them to influence block allocation and layout.
Not to affect how we issue commands at runtime.

Since a storage device is free to ignore all or parts of any discard
request I'd consider it somewhat broken if it actually complained.
Especially so since the relevant knobs in the standard that we key off
of are performance recommendations and not requirements that commands
must adhere to.

-- 
Martin K. Petersen	Oracle Linux Engineering

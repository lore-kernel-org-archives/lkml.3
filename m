Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505AbaFLCQm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 22:16:42 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:22079 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449AbaFLCQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 22:16:40 -0400
To: Christoph Hellwig <hch@infradead.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, axboe@fb.com,
        nab@daterainc.com, sagig@dev.mellanox.co.il,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: Re: [PATCH 12/14] block: Add specific data integrity errors
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1401334128-15499-1-git-send-email-martin.petersen@oracle.com>
	<1401334128-15499-13-git-send-email-martin.petersen@oracle.com>
	<20140611165455.GG9511@infradead.org>
Date: Wed, 11 Jun 2014 22:16:01 -0400
In-Reply-To: <20140611165455.GG9511@infradead.org> (Christoph Hellwig's
	message of "Wed, 11 Jun 2014 09:54:55 -0700")
Message-ID: <yq14mzqrhy6.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.130012 (Ma Gnus v0.12) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch@infradead.org> writes:

>> Introduce a set of error codes that can be used by the block
>> integrity subsystem to signal which class of error was encountered by
>> either the I/O controller or the storage device.

Christoph> I'd also love to see something catching these so that they
Christoph> don't leak to userspace.

This patch was really meant as an RFC. But it is absolutely my intent to
expose these to userspace. Albeit only to applications that supply or
request protection information via Darrick's aio extensions.

I also use these errors extensively in my test utilities to verify that
the correct problem gets detected by the correct entity when I inject an
error.

I should add that in the past I had a separate error status inside the
bip that contained the data integrity specific errors. But that involved
all sorts of evil hacks when bios were cloned, split and stacked. After
talking to nab about his needs for target I figured it was better to
just define new error codes and handle them like Hannes did for the
extended SCSI errors.

-- 
Martin K. Petersen	Oracle Linux Engineering

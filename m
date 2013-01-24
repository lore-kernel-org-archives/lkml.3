Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756327Ab3AXWtb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 17:49:31 -0500
Received: from mail-qc0-f178.google.com ([209.85.216.178]:47686 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755982Ab3AXWt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 17:49:28 -0500
Date: Thu, 24 Jan 2013 14:49:21 -0800
From: Tejun Heo <tj@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, pmatouse@redhat.com,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 02/13] sg_io: reorganize list of allowed commands
Message-ID: <20130124224921.GB2373@mtj.dyndns.org>
References: <1359039649-17734-1-git-send-email-pbonzini@redhat.com>
 <1359039649-17734-3-git-send-email-pbonzini@redhat.com>
 <20130124224203.GA2373@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130124224203.GA2373@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2013 at 02:42:03PM -0800, Tejun Heo wrote:
> One other thing is I would much prefer if the table was made static
> const first.  As we only allow compile-time defined tables, there's no
> point in dynamically initializing these and the above can be static
> initializers.

On the similar line of thoughts, wouldn't it be better to have the
table organized by the device type first?  It would be much easier to
comprehend which commands are allowed for each device type that way
and FWIW it would be more cacheline friendly.  e.g. something like,

#define M(opcode)	(1 << opcode)

#define COMMON	\
	M(READ_6) | M(WRITE_6) | ....

static const whatever_type blk_cmd_filter_disk = {
	COMMON				|
	M(CMD_SPECIFIC_TO_THIS_TYPE0)	|
	M(CMD_SPECIFIC_TO_THIS_TYPE2)	|
	...
};

Thanks.

-- 
tejun

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755627AbaH0QFl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 12:05:41 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:47950 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbaH0QFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 12:05:39 -0400
Message-ID: <53FE01D0.1030902@kernel.dk>
Date: Wed, 27 Aug 2014 10:05:36 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Boaz Harrosh <openosd@gmail.com>, Jeff Moyer <jmoyer@redhat.com>
CC: Joe Lawrence <joe.lawrence@stratus.com>, linux-kernel@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>, Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH v3 0/2] block,scsi: fixup blk_get_request dead queue scenarios
References: <1404329718-19367-1-git-send-email-joe.lawrence@stratus.com>	<x49egw36u55.fsf@segfault.boston.devel.redhat.com>	<53FCF9DB.6010501@kernel.dk>	<x49mwar54ca.fsf@segfault.boston.devel.redhat.com>	<53FCFD40.2010903@kernel.dk> <53FCFE01.8080701@kernel.dk> <x49iole6hcc.fsf@segfault.boston.devel.redhat.com> <53FDE621.2050009@kernel.dk> <53FDFE54.6050600@gmail.com>
In-Reply-To: <53FDFE54.6050600@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2014 09:50 AM, Boaz Harrosh wrote:
> On 08/27/2014 05:07 PM, Jens Axboe wrote:
>> On 08/26/2014 04:01 PM, Jeff Moyer wrote:
>>> Jens Axboe <axboe@kernel.dk> writes:
> <>
>> There's also a bug in osd_initiator.c, _init_blk_request(). We jump to
>> 'out' for IS_ERR(req), which attempts to print or->request, which hasn't
>> been assigned yet. 
> 
> You mean this code:
> 	req = _make_request(q, has_out, has_out ? &or->out : &or->in, flags);
> 	if (IS_ERR(req)) {
> 		ret = PTR_ERR(req);
> 		goto out;
> 	}
> 
> 	or->request = req;
> 
> But _make_request used to already return -ENOMEM as a pointer in req
> So if this is a bug it was not introduced by this patch.

Joe brought this up too, I guess it's been there before this patch.

> And it is not a bug at all the print prints the pointer. The all of
> this code assumes osd_request was allocated ZERO set. the print of %p
> is fine with NULLs (and any number for that matter)

If or->request is NULL initialized, it's fine. I didn't track the path
to check if it was garbage or NULL.

> I have reviewed this patch for osd part, it is fine

Thanks!

-- 
Jens Axboe


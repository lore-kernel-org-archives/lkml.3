Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935248AbaH0Puu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 11:50:50 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:33692 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935001AbaH0Put (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 11:50:49 -0400
Message-ID: <53FDFE54.6050600@gmail.com>
Date: Wed, 27 Aug 2014 18:50:44 +0300
From: Boaz Harrosh <openosd@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, Jeff Moyer <jmoyer@redhat.com>
CC: Joe Lawrence <joe.lawrence@stratus.com>, linux-kernel@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>, Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH v3 0/2] block,scsi: fixup blk_get_request dead queue scenarios
References: <1404329718-19367-1-git-send-email-joe.lawrence@stratus.com>	<x49egw36u55.fsf@segfault.boston.devel.redhat.com>	<53FCF9DB.6010501@kernel.dk>	<x49mwar54ca.fsf@segfault.boston.devel.redhat.com>	<53FCFD40.2010903@kernel.dk> <53FCFE01.8080701@kernel.dk> <x49iole6hcc.fsf@segfault.boston.devel.redhat.com> <53FDE621.2050009@kernel.dk>
In-Reply-To: <53FDE621.2050009@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2014 05:07 PM, Jens Axboe wrote:
> On 08/26/2014 04:01 PM, Jeff Moyer wrote:
>> Jens Axboe <axboe@kernel.dk> writes:
<>
> There's also a bug in osd_initiator.c, _init_blk_request(). We jump to
> 'out' for IS_ERR(req), which attempts to print or->request, which hasn't
> been assigned yet. 

You mean this code:
	req = _make_request(q, has_out, has_out ? &or->out : &or->in, flags);
	if (IS_ERR(req)) {
		ret = PTR_ERR(req);
		goto out;
	}

	or->request = req;

But _make_request used to already return -ENOMEM as a pointer in req
So if this is a bug it was not introduced by this patch.

And it is not a bug at all the print prints the pointer. The all of
this code assumes osd_request was allocated ZERO set. the print of %p
is fine with NULLs (and any number for that matter)

> This is my primary concern with this patch, basically
> every single of these call sites must be verified or it will do more
> harm than good. Have they been?
> 

I have reviewed this patch for osd part, it is fine

Thanks
Boaz


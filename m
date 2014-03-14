Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755812AbaCNPgi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 11:36:38 -0400
Received: from mail-qc0-f182.google.com ([209.85.216.182]:44814 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755768AbaCNPgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 11:36:36 -0400
MIME-Version: 1.0
In-Reply-To: <20140314141143.GH12613@htj.dyndns.org>
References: <1392519268-29991-1-git-send-email-r.peniaev@gmail.com>
	<20140218155945.ee2e22e07fa3b4f242b16a7f@linux-foundation.org>
	<CACZ9PQV8RsaefFAOt5b-aL33G3CiD+3+fTuW15io6u1DH3XJ6Q@mail.gmail.com>
	<CACZ9PQUKzsP4mwJSO3c=Z3W2pYr2AME-9j+1Cqg9t8a4T+uQQg@mail.gmail.com>
	<20140313200119.GB504@quack.suse.cz>
	<20140313143456.157404fd7f208638ca70e317@linux-foundation.org>
	<20140314130712.GC12613@htj.dyndns.org>
	<CACZ9PQUQX-sSNo+z0LB0Tefq9pSHFr6GjKg2tWzdAtw3OYYDsg@mail.gmail.com>
	<20140314141143.GH12613@htj.dyndns.org>
Date: Sat, 15 Mar 2014 00:36:35 +0900
Message-ID: <CACZ9PQUupNLYQDcTRVdu3dZRsAvrz1aS1OGD20r=XzyJ_AObqQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] fs/mpage.c: forgotten WRITE_SYNC in case of data
 integrity write
From: Roman Peniaev <r.peniaev@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2014 at 11:11 PM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> On Fri, Mar 14, 2014 at 11:07:04PM +0900, Roman Peniaev wrote:
>> Seems the following message should be better:
>> When data inegrity operation (sync, fsync, fdatasync calls) happens
>> writeback control is set to WB_SYNC_ALL.
>> In that case all write requests are marked with WRITE_SYNC, but on
>> mpage writeback path
>> WRITE_SYNC is missed. This patch fixes this.
>>
>> Is it ok, what do you think?
>
> I think the description should make it clear that WRITE_SYNC is about
> latency, not about integrity and we probably should add comments
> explaining why we're using WRITE_SYNC for WB_SYNC_ALL (because there
> probably is someone waiting).

I sent v2 of the patch where I tried to be more explicit in details.
Please, check.

--
Roman

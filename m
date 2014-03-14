Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755006AbaCNOXr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 10:23:47 -0400
Received: from mail-qc0-f182.google.com ([209.85.216.182]:38094 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754477AbaCNOXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 10:23:45 -0400
MIME-Version: 1.0
In-Reply-To: <20140314141511.GF18583@quack.suse.cz>
References: <1392519268-29991-1-git-send-email-r.peniaev@gmail.com>
	<20140218155945.ee2e22e07fa3b4f242b16a7f@linux-foundation.org>
	<CACZ9PQV8RsaefFAOt5b-aL33G3CiD+3+fTuW15io6u1DH3XJ6Q@mail.gmail.com>
	<CACZ9PQUKzsP4mwJSO3c=Z3W2pYr2AME-9j+1Cqg9t8a4T+uQQg@mail.gmail.com>
	<20140313200119.GB504@quack.suse.cz>
	<20140313143456.157404fd7f208638ca70e317@linux-foundation.org>
	<20140314130712.GC12613@htj.dyndns.org>
	<CACZ9PQUQX-sSNo+z0LB0Tefq9pSHFr6GjKg2tWzdAtw3OYYDsg@mail.gmail.com>
	<20140314141143.GH12613@htj.dyndns.org>
	<20140314141511.GF18583@quack.suse.cz>
Date: Fri, 14 Mar 2014 23:23:45 +0900
Message-ID: <CACZ9PQXNK=z-bk8BJ8rmU9dJiEAcoHBFBoGDK_QoJ0NQFweufQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] fs/mpage.c: forgotten WRITE_SYNC in case of data
 integrity write
From: Roman Peniaev <r.peniaev@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2014 at 11:15 PM, Jan Kara <jack@suse.cz> wrote:
> On Fri 14-03-14 10:11:43, Tejun Heo wrote:
>> > Also, could you please help me do understand how can I guarantee
>> > integrity in case of block device with big volatile
>> > cache and filesystem, which does not support REQ_FLUSH/FUA?
>>
>> If a device has a volatile cache but doesn't support flush, it can't
>> guarantee integrity.  There's no way for its user to determine or
>> force whether certain data is on non-volatile media.  It's an
>> inherently broken device.
>   I think his problem was that the device does support REQ_FLUSH/FUA but
> the filesystem on top of it doesn't issue it properly. That's a filesystem
> problem so fix the filesystem... :) Which one is it?

take any old school, e.g. ext2 or even better: fat :)

--
Roman

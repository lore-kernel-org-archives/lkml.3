Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751674AbaILBtT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 21:49:19 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:42992 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbaILBtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 21:49:18 -0400
Message-ID: <54125116.9050500@oracle.com>
Date: Thu, 11 Sep 2014 21:49:10 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: john@johnmccutchan.com, rlove@rlove.org, eparis@parisplace.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fsnotify: don't put user context if it was never assigned
References: <1406640314-25201-1-git-send-email-sasha.levin@oracle.com> <20140911134355.21bed9dbf5a0c7a8190c748f@linux-foundation.org>
In-Reply-To: <20140911134355.21bed9dbf5a0c7a8190c748f@linux-foundation.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2014 04:43 PM, Andrew Morton wrote:
> On Tue, 29 Jul 2014 09:25:14 -0400 Sasha Levin <sasha.levin@oracle.com> wrote:
> 
>> > On some failure paths we may attempt to free user context even
>> > if it wasn't assigned yet. This will cause a NULL ptr deref
>> > and a kernel BUG.
> Are you able to identify "some failure paths"?  I spent some time
> grepping, but it's a pain.
> 
> Please try to include such info in changelogs because reviewers (ie,
> me) might want to review those callers to decide whether the bug lies
> elsewhere.
> 

Sorry about that.

The path I was looking at is in inotify_new_group():

        oevent = kmalloc(sizeof(struct inotify_event_info), GFP_KERNEL);
        if (unlikely(!oevent)) {
                fsnotify_destroy_group(group);
                return ERR_PTR(-ENOMEM);
        }

fsnotify_destroy_group() would get called here, but group->inotify_data.user
is only getting assigned later:

	group->inotify_data.user = get_current_user();


Thanks,
Sasha

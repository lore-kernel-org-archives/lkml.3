Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751543AbaDUEDY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 00:03:24 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:60106 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231AbaDUEDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 00:03:22 -0400
MIME-Version: 1.0
In-Reply-To: <53546DA3.2080709@cn.fujitsu.com>
References: <1397835565-6411-1-git-send-email-nasa4836@gmail.com> <53546DA3.2080709@cn.fujitsu.com>
From: Jianyu Zhan <nasa4836@gmail.com>
Date: Mon, 21 Apr 2014 12:02:42 +0800
Message-ID: <CAHz2CGWVo9ZXDY7S5_OU-6C1syiMuXX4qCpMUM+YCMkDUcSSZg@mail.gmail.com>
Subject: Re: [PATCH] mm/swap: cleanup *lru_cache_add* functions
To: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
        shli@kernel.org, bob.liu@oracle.com, sjenning@linux.vnet.ibm.com,
        iamjoonsoo.kim@lge.com, aquini@redhat.com,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>, khalid.aziz@oracle.com,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,  Yanfei,

On Mon, Apr 21, 2014 at 9:00 AM, Zhang Yanfei
<zhangyanfei@cn.fujitsu.com> wrote:
> What should be exported?
>
> lru_cache_add()
> lru_cache_add_anon()
> lru_cache_add_file()
>
> It seems you only export lru_cache_add_file() in the patch.

Right, lru_cache_add_anon() is only used by VM code, so it should not
be exported.

lru_cache_add_file() and lru_cache_add() are supposed to be used by
vfs ans fs code.

But  now only lru_cache_add_file() is  used by CIFS and FUSE, which
both could be
built as module, so it must be exported;  and lru_cache_add() has now
no module users,
so as Rik suggests, it is unexported too.


Thanks,
Jianyu Zhan

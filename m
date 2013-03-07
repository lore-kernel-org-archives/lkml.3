Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751385Ab3CGGlg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 01:41:36 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:42739 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084Ab3CGGle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 01:41:34 -0500
Message-ID: <51383699.7060805@gmail.com>
Date: Thu, 07 Mar 2013 14:41:29 +0800
From: Will Huck <will.huckk@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: Greg Thelen <gthelen@google.com>, akpm@linux-foundation.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] tmpfs: fix mempolicy object leaks
References: <1361344302-26565-1-git-send-email-gthelen@google.com> <1361344302-26565-2-git-send-email-gthelen@google.com> <alpine.LNX.2.00.1302201221270.1152@eggly.anvils> <5133E178.90405@gmail.com> <alpine.LNX.2.00.1303051101350.27525@eggly.anvils>
In-Reply-To: <alpine.LNX.2.00.1303051101350.27525@eggly.anvils>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hugh,
On 03/06/2013 03:40 AM, Hugh Dickins wrote:
> On Mon, 4 Mar 2013, Will Huck wrote:
>> Could you explain me why shmem has more relationship with mempolicy? It seems
>> that there are many codes in shmem handle mempolicy, but other components in
>> mm subsystem just have little.
> NUMA mempolicy is mostly handled in mm/mempolicy.c, which services the
> mbind, migrate_pages, set_mempolicy, get_mempolicy system calls: which
> govern how process memory is distributed across NUMA nodes.
>
> mm/shmem.c is affected because it was also found useful to specify
> mempolicy on the shared memory objects which may back process memory:
> that includes SysV SHM and POSIX shared memory and tmpfs.  mm/hugetlb.c
> contains some mempolicy handling for hugetlbfs; fs/ramfs is kept minimal,
> so nothing in there.
>
> Those are the memory-based filesystems, where NUMA mempolicy is most
> natural.  The regular filesystems could support shared mempolicy too,
> but that would raise more awkward design questions.

I found that if mbind several processes to one node and almost exhaust 
memory, processes will just stuck and no processes make progress or be 
killed. Is it normal?

>
> Hugh


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751818AbaDRD47 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 23:56:59 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:42182 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609AbaDRD4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 23:56:45 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.11.1402032014140.29889@eggly.anvils>
References: <000c01cf1b47$ce280170$6a780450$%yang@samsung.com>
	<20140203153628.5e186b0e4e81400773faa7ac@linux-foundation.org>
	<alpine.LSU.2.11.1402032014140.29889@eggly.anvils>
Date: Fri, 18 Apr 2014 11:56:45 +0800
Message-ID: <CAL1ERfO2u838hnY2NVKVd7Tr_=2o=nVpBf_hTKGHms+QFGTFPQ@mail.gmail.com>
Subject: Re: [PATCH 3/8] mm/swap: prevent concurrent swapon on the same
 S_ISBLK blockdev
From: Weijie Yang <weijie.yang.kh@gmail.com>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Weijie Yang <weijie.yang@samsung.com>,
        Minchan Kim <minchan@kernel.org>, shli@kernel.org,
        Bob Liu <bob.liu@oracle.com>, Seth Jennings <sjennings@variantweb.net>,
        Heesub Shin <heesub.shin@samsung.com>, mquzik@redhat.com,
        Linux-MM <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 4, 2014 at 12:20 PM, Hugh Dickins <hughd@google.com> wrote:
> On Mon, 3 Feb 2014, Andrew Morton wrote:
>> On Mon, 27 Jan 2014 18:03:04 +0800 Weijie Yang <weijie.yang@samsung.com> wrote:
>>
>> > When swapon the same S_ISBLK blockdev concurrent, the allocated two
>> > swap_info could hold the same block_device, because claim_swapfile()
>> > allow the same holder(here, it is sys_swapon function).
>> >
>> > To prevent this situation, This patch adds swap_lock protect to ensure
>> > we can find this situation and return -EBUSY for one swapon call.
>> >
>> > As for S_ISREG swapfile, claim_swapfile() already prevent this scenario
>> > by holding inode->i_mutex.
>> >
>> > This patch is just for a rare scenario, aim to correct of code.
>> >
>>
>> hm, OK.  Would it be saner to pass a unique `holder' to
>> claim_swapfile()?  Say, `p'?
>>
>> Truly, I am fed up with silly swapon/swapoff races.  How often does
>> anyone call these things?  Let's slap a huge lock around the whole
>> thing and be done with it?
>
> That answer makes me sad: we can't be bothered to get it right,
> even when Weijie goes to the trouble of presenting a series to do so.
> But I sure don't deserve a vote until I've actually looked through it.
>

Hi,

This is a ping email. Could I get some options about these patch series?

Thanks.

> Hugh

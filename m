Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529Ab3IJQpP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 12:45:15 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:38572 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406Ab3IJQpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 12:45:12 -0400
MIME-Version: 1.0
In-Reply-To: <16357.1378816473@warthog.procyon.org.uk>
References: <alpine.DEB.2.00.1309091042520.18214@cobra.newdream.net>
	<fd69f2052bc16d5a5de0104ca00ccc59478e3569.1378750714.git.milosz@adfin.com>
	<16357.1378816473@warthog.procyon.org.uk>
Date: Tue, 10 Sep 2013 12:45:11 -0400
Message-ID: <CANP1eJFy+dtwEVYbyTtYbH+CeXGfUDbUkaf-_YsJAn_VLvK4pg@mail.gmail.com>
Subject: Re: [PATCH] fscache: check consistency does not decrement refcount
From: Milosz Tanski <milosz@adfin.com>
To: Sage Weil <sage@inktank.com>
Cc: ceph-devel <ceph-devel@vger.kernel.org>,
        "Yan, Zheng" <zheng.z.yan@intel.com>,
        "linux-cachefs@redhat.com" <linux-cachefs@redhat.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sage,

Can you submit to the upstream next in your next round of fixes (with
David's ack).

Thanks,
- Milosz

P.S: Thanks David.

On Tue, Sep 10, 2013 at 8:34 AM, David Howells <dhowells@redhat.com> wrote:
> Milosz Tanski <milosz@adfin.com> wrote:
>
>> __fscache_check_consistency() does not decrement the count of operations
>> active after it finishes in the success case. This leads to a hung tasks on
>> cookie de-registration (commonly in inode eviction).
>>
>> INFO: task kworker/1:2:4214 blocked for more than 120 seconds.
>> kworker/1:2     D ffff880443513fc0     0  4214      2 0x00000000
>> Workqueue: ceph-msgr con_work [libceph]
>>   ...
>> Call Trace:
>>  [<ffffffff81569fc6>] ? _raw_spin_unlock_irqrestore+0x16/0x20
>>  [<ffffffffa0016570>] ? fscache_wait_bit_interruptible+0x30/0x30 [fscache]
>>  [<ffffffff81568d09>] schedule+0x29/0x70
>>  [<ffffffffa001657e>] fscache_wait_atomic_t+0xe/0x20 [fscache]
>>  [<ffffffff815665cf>] out_of_line_wait_on_atomic_t+0x9f/0xe0
>>  [<ffffffff81083560>] ? autoremove_wake_function+0x40/0x40
>>  [<ffffffffa0015a9c>] __fscache_relinquish_cookie+0x15c/0x310 [fscache]
>>  [<ffffffffa00a4fae>] ceph_fscache_unregister_inode_cookie+0x3e/0x50 [ceph]
>>  [<ffffffffa007e373>] ceph_destroy_inode+0x33/0x200 [ceph]
>>  [<ffffffff811c13ae>] ? __fsnotify_inode_delete+0xe/0x10
>>  [<ffffffff8119ba1c>] destroy_inode+0x3c/0x70
>>  [<ffffffff8119bb69>] evict+0x119/0x1b0
>>
>> Signed-off-by: Milosz Tanski <milosz@adfin.com>
>
> Acked-by: David Howells <dhowells@redhat.com>

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759211Ab3BTTYU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 14:24:20 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:21888 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758898Ab3BTTYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 14:24:18 -0500
Message-ID: <512522CF.1020901@oracle.com>
Date: Wed, 20 Feb 2013 14:23:59 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130113 Thunderbird/17.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] idr: prevent NULL deref on lookups before insertions
References: <1361385853-29010-1-git-send-email-sasha.levin@oracle.com> <CAOS58YMT3NS-8zvwx1tNQoLKM1WtKtT-YXBPi=4pAeAMi=rYeA@mail.gmail.com>
In-Reply-To: <CAOS58YMT3NS-8zvwx1tNQoLKM1WtKtT-YXBPi=4pAeAMi=rYeA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2013 01:45 PM, Tejun Heo wrote:
> Hello, Sasha.
> 
> On Wed, Feb 20, 2013 at 10:44 AM, Sasha Levin <sasha.levin@oracle.com> wrote:
>> 'hint' will be NULL if we're looking up before adding anything
>> to the IDR.
>>
>> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
> 
> Andy Shevchenko	already posted fix (and free_layer() needs an update too).

Sorry about that, didn't see one on lkml so I've sent mine.

What about a patch that deals with:

[   67.992946] ------------[ cut here ]------------
[   67.994133] WARNING: at lib/idr.c:669 idr_find_slowpath+0x36/0x170()
[   67.999650] Modules linked in:
[   68.000469] Pid: 7156, comm: trinity Tainted: G        W    3.8.0-next-20130220-sasha-00006-g3d6f01c-dirty #6
[   68.005136] Call Trace:
[   68.005719]  [<ffffffff8110c96b>] warn_slowpath_common+0x8b/0xc0
[   68.011168]  [<ffffffff8110c9b5>] warn_slowpath_null+0x15/0x20
[   68.012488]  [<ffffffff81a23506>] idr_find_slowpath+0x36/0x170
[   68.013805]  [<ffffffff8113bbcf>] __lock_timer+0x12f/0x240
[   68.015686]  [<ffffffff8113baa0>] ? posix_timer_fn+0xd0/0xd0
[   68.016946]  [<ffffffff8113c64c>] sys_timer_delete+0x2c/0x180
[   68.018478]  [<ffffffff83dab0f5>] ? tracesys+0x7e/0xe6
[   68.019647]  [<ffffffff83dab158>] tracesys+0xe1/0xe6
[   68.020941] ---[ end trace 6d02b1896fa2505b ]---


Thanks,
Sasha

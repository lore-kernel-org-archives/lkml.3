Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798AbaKXA1e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 19:27:34 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:9006 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752555AbaKXA1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 19:27:33 -0500
Date: Sun, 23 Nov 2014 19:27:23 -0500
From: Chris Mason <clm@fb.com>
Subject: Re: [GIT PULL] Btrfs deadlock fix
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: <torvalds@linux-foundation.org>, <linux-btrfs@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Message-ID: <1416788843.3019.2@mail.thefacebook.com>
In-Reply-To: <1416788595.4998.5.camel@kernel.crashing.org>
References: <20141123151439.GA16816@ret.masoncoding.com>
	<1416788595.4998.5.camel@kernel.crashing.org>
X-Mailer: geary/0.8.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.28,0.0.0000
 definitions=2014-11-24_01:2014-11-21,2014-11-23,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=4.90931522719819
 compositescore=0.934717001567628 urlsuspect_oldscore=0.934717001567628
 suspectscore=2 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=62764
 rbsscore=0.934717001567628 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1411240002
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, Nov 23, 2014 at 7:23 PM, Benjamin Herrenschmidt 
<benh@kernel.crashing.org> wrote:
> On Sun, 2014-11-23 at 10:14 -0500, Chris Mason wrote:
>>  Hi Linus,
>> 
>>  My for-linus branch:
> 
> Not sure if this is related, but with -rc4, on this ppc64el box, when
> grub updates (it starts trying to mount everything under the sun with
> every filesystem), the box hangs with:
> 
> [  177.344522] INFO: rcu_sched detected stalls on CPUs/tasks: { 8}
> (detected by 9, t=25883 jiffies, g=3642, c=3641, q=5206)
> 
> With xmon I can catch it with this backtrace:
> 
> [link register   ] d00000000ecec3f8 test_check_exists+0x1f8/0x280 
> [btrfs]
> [c000000f0cc63930] d00000000ecec2b0 test_check_exists+0xb0/0x280 
> [btrfs] (unreliable)
> [c000000f0cc63990] d00000000ed2a4b4 
> btrfs_test_free_space_cache+0x774/0x1150 [btrfs]
> [c000000f0cc63a20] d00000000ed30f04 init_btrfs_fs+0x11c/0x210 [btrfs]
> [c000000f0cc63a90] c00000000000b4dc do_one_initcall+0x12c/0x280
> [c000000f0cc63b60] c0000000001628b8 load_module+0x2088/0x2970
> [c000000f0cc63d50] c0000000001633d0 SyS_finit_module+0xc0/0x120
> [c000000f0cc63e30] c00000000000927c syscall_exit+0x0/0x7c
> --- Exception: c01 (System Call) at 00003fff88697184
> 
> Note that afaik there isn't any btrfs partition on any disk on that
> machine... well not that I know of :)

This should be from CONFIG_BTRFS_FS_RUN_SANITY_TESTS=y.  I do test with 
this on here, but I'll look it over for ppc related fun.

The deadlock fix from this pull shouldn't be related.  Just to make 
sure I read your email right, this stall isn't new with rc6 is it?

-chris


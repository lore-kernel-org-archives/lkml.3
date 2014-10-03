Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171AbaJCAqh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 20:46:37 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:61658 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbaJCAqg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 20:46:36 -0400
MIME-Version: 1.0
In-Reply-To: <20140930081412.GF9561@wfg-t540p.sh.intel.com>
References: <20140930081412.GF9561@wfg-t540p.sh.intel.com>
Date: Thu, 2 Oct 2014 17:46:34 -0700
Message-ID: <CAKbGBLhyXOdy9cbyabDRf0RQEinzz5nqqhh7FVfrs9sWDTmu0A@mail.gmail.com>
Subject: Re: [compiler/gcc4] a9f180345f5: -100.0% last_state.is_incomplete_run
From: Steven Noonan <steven@uplinklabs.net>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, lkp@01.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 1:14 AM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> Hi Steven,
>
> FYI, we noticed that your commit a9f180345f5378ac87d80ed0bea55ba421d83859
> ("compiler/gcc4: Make quirk for asm_volatile_goto() unconditional") fixed
> a number of machine boot failures in our LKP test farm. This is really helpful!
> Our gcc version is 4.9.1 (Debian 4.9.1-11).

Hey cool, that's good news!

I rather wish we could find the root cause of the miscompiles, though,
so we could conditionalize the quirk on something again. I'm terrible
at debugging GCC behavior, though, so I'm not the right person for it.

- Steven

>
> 569d6557ab957d6  a9f180345f5378ac87d80ed0b
> ---------------  -------------------------
>      %stddev        %change               %stddev
>             \          |                 /
>          1 ± 0%    -100.0%          0 ± 0%  lkp-st02/dd-write/5m-11HDD-RAID5-cfq-btrfs-100dd
>          1 ± 0%    -100.0%          0 ± 0%  TOTAL dmesg.kernel_BUG_at_fs/nfs/pagelist.c
>
> 569d6557ab957d6  a9f180345f5378ac87d80ed0b
> ---------------  -------------------------
>          1 ± 0%    -100.0%          0 ± 0%  lkp-st02/dd-write/5m-11HDD-RAID5-cfq-btrfs-100dd
>          1 ± 0%    -100.0%          0 ± 0%  TOTAL dmesg.Kernel_panic-not_syncing:Fatal_exception
>
> 569d6557ab957d6  a9f180345f5378ac87d80ed0b
> ---------------  -------------------------
>          1 ± 0%    -100.0%          0 ± 0%  lkp-st02/dd-write/5m-11HDD-RAID5-cfq-btrfs-100dd
>          1 ± 0%    -100.0%          0 ± 0%  TOTAL dmesg.invalid_opcode
>
> 569d6557ab957d6  a9f180345f5378ac87d80ed0b
> ---------------  -------------------------
>          1 ± 0%    -100.0%          0 ± 0%  ivb42/will-it-scale/futex4
>          1 ± 0%    -100.0%          0 ± 0%  ivb44/fsmark/1x-1t-1HDD-xfs-4M-60G-NoSync
>          1 ± 0%    -100.0%          0 ± 0%  ivb44/fsmark/1x-64t-1BRD_48G-btrfs-4M-40G-fsyncBeforeClose
>          1 ± 0%    -100.0%          0 ± 0%  lkp-bdw01/blogbench/1SSD-btrfs
>          1 ± 0%    -100.0%          0 ± 0%  lkp-hsw01/vm-scalability/300s-anon-rx-rand-mt
>          1 ± 0%    -100.0%          0 ± 0%  lkp-sbx04/will-it-scale/futex3
>          1 ± 0%    -100.0%          0 ± 0%  lkp-sbx04/will-it-scale/page_fault3
>          1 ± 0%    -100.0%          0 ± 0%  lkp-st02/dd-write/5m-11HDD-RAID5-cfq-btrfs-100dd
>          8 ± 0%    -100.0%          0 ± 0%  TOTAL last_state.is_incomplete_run
>
> 569d6557ab957d6  a9f180345f5378ac87d80ed0b
> ---------------  -------------------------
>          1 ± 0%    -100.0%          0 ± 0%  ivb42/will-it-scale/futex4
>          1 ± 0%    -100.0%          0 ± 0%  ivb44/fsmark/1x-1t-1HDD-xfs-4M-60G-NoSync
>          1 ± 0%    -100.0%          0 ± 0%  ivb44/fsmark/1x-64t-1BRD_48G-btrfs-4M-40G-fsyncBeforeClose
>          1 ± 0%    -100.0%          0 ± 0%  lkp-bdw01/blogbench/1SSD-btrfs
>          1 ± 0%    -100.0%          0 ± 0%  lkp-hsw01/vm-scalability/300s-anon-rx-rand-mt
>          1 ± 0%    -100.0%          0 ± 0%  lkp-sbx04/will-it-scale/futex3
>          1 ± 0%    -100.0%          0 ± 0%  lkp-sbx04/will-it-scale/page_fault3
>          1 ± 0%    -100.0%          0 ± 0%  lkp-st02/dd-write/5m-11HDD-RAID5-cfq-btrfs-100dd
>          8 ± 0%    -100.0%          0 ± 0%  TOTAL last_state.booting
>
> Thanks,
> Fengguang

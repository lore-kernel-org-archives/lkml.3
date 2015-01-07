Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895AbbAGPYM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 10:24:12 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:40379 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419AbbAGPYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 10:24:11 -0500
Message-ID: <54AD4F98.6070702@kernel.dk>
Date: Wed, 07 Jan 2015 08:24:08 -0700
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: LKML <linux-kernel@vger.kernel.org>, LKP ML <lkp@01.org>
Subject: Re: [LKP] [null_blk] f2298c0403b:
References: <1420598028.6201.70.camel@intel.com>
In-Reply-To: <1420598028.6201.70.camel@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/2015 07:33 PM, Huang Ying wrote:
> FYI, we noticed the below changes on
>
> commit f2298c0403b0dfcaef637eba0c02c4a06d7a25ab ("null_blk: multi queue aware block test driver")
>
>
> testbox/testcase/testparams: vm-kbuild-yocto-i386/boot/1
>
> 320ae51feed5c2f1  f2298c0403b0dfcaef637eba0c
> ----------------  --------------------------
>         fail:runs  %reproduction    fail:runs
>             |             |             |
>             :10         100%          10:10    kmsg.VFS:could_not_find_a_valid_V7_on_nullb1
>             :10         100%          10:10    kmsg.VFS:could_not_find_a_valid_V7_on_nullb0
>            1:10         -10%            :10    kmsg.vm86_32:could_not_access_userspace_vm86_info
>
> vm-kbuild-yocto-i386: qemu-system-i386 -enable-kvm
> Memory: 320M
>
> [    1.971241] mtip32xx Version 1.2.6os3
> [    1.971311] blk-mq: CPU -> queue map
> [    1.971312]   CPU 0 -> Queue 0
> [    1.971314]   CPU 1 -> Queue 0
> [    1.971628]  nullb0: unknown partition table
> [    1.971748] blk-mq: CPU -> queue map
> [    1.971749]   CPU 0 -> Queue 0
> [    1.971751]   CPU 1 -> Queue 0
> [    1.972023]  nullb1: unknown partition table
> [    1.972096] null: module loaded
> [    1.972131] ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
>
> I think this is at least confusing for the end user.

Sorry, not sure I follow at all. If you're expecting the null block 
driver to actually store data, then yes, you are going to have a bad 
time. It's a test tool for storage stack development.

-- 
Jens Axboe


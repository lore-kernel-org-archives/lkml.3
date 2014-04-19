Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751757AbaDSMIX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 08:08:23 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:50802 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328AbaDSMIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 08:08:21 -0400
X-Nat-Received: from [202.181.97.72]:53563 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1397909297.1836
To: miklos@szeredi.hu, linux-security-module@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/11] ext4: add cross rename support
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <CAJfpegv0TgJpd-pXxBj2n0efRUW9_GW_tYtHtfN6drOYA=25QQ@mail.gmail.com>
	<20140116105406.GF24171@tucsk.piliscsaba.szeredi.hu>
	<52D90B93.5010209@gmail.com>
	<20140117144126.GG24171@tucsk.piliscsaba.szeredi.hu>
	<53523D16.9020101@gmail.com>
In-Reply-To: <53523D16.9020101@gmail.com>
Message-Id: <201404192108.JGJ78110.MFOFFHJOOVtLQS@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sat, 19 Apr 2014 21:08:14 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 19042014 #7803165, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Kerrisk (man-pages) wrote:
> Now that renameat2() is in 3.15, I've taken these changes.

What!? I didn't know renameat2() goes to 3.15.

But I assume that renameat2() is not accessible in 3.15, for I can see
"asmlinkage long sys_renameat2(" but don't see "#define __NR_renameat2".

  $ grep -Fr renameat include/
  include/linux/syscalls.h:asmlinkage long sys_renameat(int olddfd, const char __user * oldname,
  include/linux/syscalls.h:asmlinkage long sys_renameat2(int olddfd, const char __user *oldname,
  include/uapi/asm-generic/unistd.h:#define __NR_renameat 38
  include/uapi/asm-generic/unistd.h:__SYSCALL(__NR_renameat, sys_renameat)
  include/asm-generic/audit_dir_write.h:__NR_renameat,
  include/net/9p/client.h:int p9_client_renameat(struct p9_fid *olddirfid, const char *old_name,

If renameat2() is accessible in 3.15, I must consider submitting TOMOYO changes
immediately. But so far I got no response from LSM users regarding the patch
( https://lkml.org/lkml/2014/1/18/26 ) which the TOMOYO changes depend on.

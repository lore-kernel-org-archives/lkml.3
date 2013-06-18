Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756212Ab3FRMjX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 08:39:23 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:56528 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755275Ab3FRMjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 08:39:21 -0400
X-Nat-Received: from [202.181.97.72]:56605 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1371559160.3137
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH 0/4] LSM/TOMOYO: Introduce per a task_struct variables.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201306112211.GBH48909.SOFOFJHMtFQVLO@I-love.SAKURA.ne.jp>
In-Reply-To: <201306112211.GBH48909.SOFOFJHMtFQVLO@I-love.SAKURA.ne.jp>
Message-Id: <201306182139.BFC60977.OFtQSHMLFJOOVF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Tue, 18 Jun 2013 21:39:09 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 18062013 #10354875, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please respond if you have any comments/questions/objections/problems.

Tetsuo Handa wrote:
> This patchset has four patches. Patch 1 and 2 are essentially revival of LSM
> hooks which existed until Linux 2.6.28.
> 
> [PATCH 1/4] LSM: Add security_bprm_aborting_creds() hook.
> [PATCH 2/4] LSM: Revive security_task_alloc() hook.
> [PATCH 3/4] TOMOYO: Remember the proposed domain while in execve() request.
> [PATCH 4/4] TOMOYO: Allow caching policy manager's state until execve() request.
> 
>  b/fs/exec.c                |    1
>  b/include/linux/security.h |   11 +++
>  b/kernel/fork.c            |    7 +
>  b/security/capability.c    |    5 +
>  b/security/security.c      |    5 +
>  b/security/tomoyo/common.c |   22 +++++-
>  b/security/tomoyo/common.h |   34 +++++++++
>  b/security/tomoyo/tomoyo.c |  163 +++++++++++++++++++++++++++++++++++++++++++--
>  include/linux/security.h   |   10 ++
>  security/capability.c      |    6 +
>  security/security.c        |    5 +
>  security/tomoyo/common.h   |    6 +
>  security/tomoyo/tomoyo.c   |   32 ++++++++
>  13 files changed, 298 insertions(+), 9 deletions(-)

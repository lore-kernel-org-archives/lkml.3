Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406Ab3IINWo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 09:22:44 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:61793 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646Ab3IINWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 09:22:41 -0400
X-Nat-Received: from [202.181.97.72]:51957 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1378732945.2558
To: maarten.lankhorst@canonical.com
Cc: imirkin@alum.mit.edu, linux-kernel@vger.kernel.org, daniel.vetter@ffwll.ch,
        robdclark@gmail.com, a.p.zijlstra@chello.nl, mingo@kernel.org
Subject: Re: [3.11-rc1] CONFIG_DEBUG_MUTEXES=y using gcc 3.x makes unbootablekernel.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <522C312A.7050705@canonical.com>
	<201309082053.FDB24195.FVOOJMStFQFLHO@I-love.SAKURA.ne.jp>
	<522CDFC8.9020903@canonical.com>
	<201309092056.GDH56750.OOMJtOHQVFFLSF@I-love.SAKURA.ne.jp>
	<522DBA0C.9030108@canonical.com>
In-Reply-To: <522DBA0C.9030108@canonical.com>
Message-Id: <201309092222.ECH95853.JMSQOtFFLHOVOF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Mon, 9 Sep 2013 22:22:23 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 09092013 #11001181, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maarten Lankhorst wrote:
> Yeah looks ok, did you run the selftests from CONFIG_DEBUG_LOCKING_API_SELFTESTS,
> with/without CONFIG_PROVE_LOCKING and once more with DEBUG_MUTEXES also unset?

Since CONFIG_DEBUG_MUTEXES=n && CONFIG_PROVE_LOCKING=y is impossible, I tested

  CONFIG_DEBUG_MUTEXES=y
  CONFIG_PROVE_LOCKING=y
  CONFIG_DEBUG_LOCKING_API_SELFTESTS=y

  CONFIG_DEBUG_MUTEXES=y
  CONFIG_PROVE_LOCKING=n
  CONFIG_DEBUG_LOCKING_API_SELFTESTS=y

  CONFIG_DEBUG_MUTEXES=n
  CONFIG_PROVE_LOCKING=n
  CONFIG_DEBUG_LOCKING_API_SELFTESTS=y

  CONFIG_DEBUG_MUTEXES=y
  CONFIG_PROVE_LOCKING=y
  CONFIG_DEBUG_LOCKING_API_SELFTESTS=n

  CONFIG_DEBUG_MUTEXES=y
  CONFIG_PROVE_LOCKING=n
  CONFIG_DEBUG_LOCKING_API_SELFTESTS=n

  CONFIG_DEBUG_MUTEXES=n
  CONFIG_PROVE_LOCKING=n
  CONFIG_DEBUG_LOCKING_API_SELFTESTS=n

and all works OK.

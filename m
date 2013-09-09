Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241Ab3IIMHp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 08:07:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55047 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786Ab3IIMHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 08:07:44 -0400
Message-ID: <522DBA0C.9030108@canonical.com>
Date: Mon, 09 Sep 2013 14:07:40 +0200
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
CC: imirkin@alum.mit.edu, linux-kernel@vger.kernel.org, daniel.vetter@ffwll.ch,
        robdclark@gmail.com, a.p.zijlstra@chello.nl, mingo@kernel.org
Subject: Re: [3.11-rc1] CONFIG_DEBUG_MUTEXES=y using gcc 3.x makes unbootablekernel.
References: <CAKb7UvjH1XZ3f-c=149s5=rqxkxVUhG_7-cfUYH3zrwJwr2_MQ@mail.gmail.com> <201309081624.EBJ90176.OJStQOFLHVFFOM@I-love.SAKURA.ne.jp> <522C312A.7050705@canonical.com> <201309082053.FDB24195.FVOOJMStFQFLHO@I-love.SAKURA.ne.jp> <522CDFC8.9020903@canonical.com> <201309092056.GDH56750.OOMJtOHQVFFLSF@I-love.SAKURA.ne.jp>
In-Reply-To: <201309092056.GDH56750.OOMJtOHQVFFLSF@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 09-09-13 13:56, Tetsuo Handa schreef:
> Maarten Lankhorst wrote:
>> Almost correct. I meant passing it as parameter to __mutex_lock_common. Your version will still cause an extra pointless null check in the ww_mutex_lock case.
> Ah, I see.
> ----------
> >From 95f189eb37c25ddf8e48d5dfc2f9f1185c52b6a8 Mon Sep 17 00:00:00 2001
> From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Date: Mon, 9 Sep 2013 20:48:13 +0900
> Subject: [PATCH] mutex: Avoid gcc version dependent __builtin_constant_p() usage.
>
> Commit 040a0a37 "mutex: Add support for wound/wait style locks" used
> "!__builtin_constant_p(p == NULL)" but gcc 3.x cannot handle such expression
> correctly, leading to boot failure when built with CONFIG_DEBUG_MUTEXES=y.
>
> Fix it by explicitly passing a bool which tells whether p != NULL or not.
>
Yeah looks ok, did you run the selftests from CONFIG_DEBUG_LOCKING_API_SELFTESTS,
with/without CONFIG_PROVE_LOCKING and once more with DEBUG_MUTEXES also unset?

~Maarten

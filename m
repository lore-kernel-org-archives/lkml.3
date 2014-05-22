Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753732AbaEVXPz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 19:15:55 -0400
Received: from smtp.outflux.net ([198.145.64.163]:34538 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752696AbaEVXGg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 19:06:36 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>,
        Oleg Nesterov <oleg@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Peter Zijlstra <peterz@infradead.org>,
        James Morris <james.l.morris@oracle.com>,
        Eric Paris <eparis@redhat.com>, Juri Lelli <juri.lelli@gmail.com>,
        John Stultz <john.stultz@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <dborkman@redhat.com>,
        Alex Thorlton <athorlton@sgi.com>, Rik van Riel <riel@redhat.com>,
        Daeseok Youn <daeseok.youn@gmail.com>,
        David Rientjes <rientjes@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Dario Faggioli <raistlin@linux.it>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        liguang <lig.fnst@cn.fujitsu.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>, linux-doc@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: [PATCH v5 0/6] seccomp: add PR_SECCOMP_EXT and SECCOMP_EXT_ACT_TSYNC
Date: Thu, 22 May 2014 16:05:30 -0700
Message-Id: <1400799936-26499-1-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the ability for threads to request seccomp filter
synchronization across their thread group (either at filter attach time
or later). (For example, for Chrome to make sure graphic driver threads
are fully confined after seccomp filters have been attached.)

To support this, seccomp locking on writes is introduced, along with
refactoring of no_new_privs. Races with thread creation are handled via
the tasklist_list.

I think all the concerns raised during the discussion[1] of the first
version of this patch have been addressed. However, the races involved
have tricked me before. :)

Thanks!

-Kees

[1] https://lkml.org/lkml/2014/1/13/795

v5:
 - move includes around (drysdale)
 - drop set_nnp return value (luto)
 - use smp_load_acquire/store_release (luto)
 - merge nnp changes to seccomp always, fewer ifdef (luto)
v4:
 - cleaned up locking further, as noticed by David Drysdale
v3:
 - added SECCOMP_EXT_ACT_FILTER for new filter install options
v2:
 - reworked to avoid clone races


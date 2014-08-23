Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751564AbaHWOpe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 10:45:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63497 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851AbaHWOpd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 10:45:33 -0400
Date: Sat, 23 Aug 2014 16:42:46 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Manfred Spraul <manfred@colorfullife.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Julien Tinnes <jln@google.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] ipc/shm: fix the historical/wrong mm->start_stack check
Message-ID: <20140823144246.GA6281@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23, Oleg Nesterov wrote:
>
> But for what? Ignoring the (I think buggy) check in do_shmat() ->start_stack
> is simply unused, we only report it via /proc/.

Really, I think do_shmat() should not abuse ->start_stack. Not only it is
wrong and unneeded afaics, do_shmat() is the only user of ->start_stack,
this adds more confusion.

Oleg.


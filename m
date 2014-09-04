Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751944AbaIDNoZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 09:44:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63691 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750901AbaIDNoX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 09:44:23 -0400
Date: Thu, 4 Sep 2014 15:41:35 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Denys Vlasenko <dvlasenk@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] x86: reimplement ___preempt_schedule*() using THUNK
	helpers
Message-ID: <20140904134135.GA3309@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter, please consider this (hopefully simple) change for inclusion.

Denys, Andy, could you review?

I guess (I hope ;) Denys is going to resend his entry.S/etc rework, but
this change should not conflict with his work, just preempt.S goes away.

Oleg.

 arch/x86/kernel/Makefile  |    2 --
 arch/x86/kernel/preempt.S |   25 -------------------------
 arch/x86/lib/Makefile     |    2 +-
 arch/x86/lib/thunk_32.S   |   20 ++++++++++++++++----
 arch/x86/lib/thunk_64.S   |    7 +++++++
 5 files changed, 24 insertions(+), 32 deletions(-)


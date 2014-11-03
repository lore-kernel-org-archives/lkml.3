Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753627AbaKCUMt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 15:12:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45364 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752509AbaKCUMs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 15:12:48 -0500
Date: Mon, 3 Nov 2014 21:12:56 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Evan Teran <eteran@alum.rit.edu>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        Pedro Alves <palves@redhat.com>, Roland McGrath <roland@hack.frob.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] ptrace/x86: fix the TIF_FORCED_TF logic in
	handle_signal()
Message-ID: <20141103201256.GA5213@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This is the very old bug initially reported by Evan in 2010, see
https://bugzilla.kernel.org/show_bug.cgi?id=16061
Somehow we forgot to fix it and now Pedro reports it again.

>From the changelog:

    Note: in the longer term we should probably change setup_sigcontext()
    to use get_flags() and then just remove this user_disable_single_step().

Yes, but this needs more changes. Lets start with more simple and
backportable fix. Also because I think that enable_single_step() and
the whole TIF_SINGLESTEP/TIF_FORCED_TF logic need some cleanups, but
I am not sure what we can do.

Oleg.

 arch/x86/kernel/signal.c |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)


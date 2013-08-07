Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933014Ab3HGSLE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 14:11:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33977 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756869Ab3HGSLB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 14:11:01 -0400
Date: Wed, 7 Aug 2013 20:05:30 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Zach Levis <zml@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] audit_alloc: clear TIF_SYSCALL_AUDIT if !audit_context
Message-ID: <20130807180530.GA4916@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even if I am right the problem is really minor, the patch should
be ignored without the authoritative acks.

I am only sending it because I am curious, and I would like to ask
another question about audit.


search_binary_handler()->audit_bprm(bprm) looks a bit strange, and
I can't understand if this is on purpose or not.

It adds the the AUDIT_EXECVE record every time the (recursive)
search_binary_handler() is called for audit_log_exit() which flushes
them all. But probably we only need a single record ?

And it seems that audit_aux_data_execve->envc is not used at all.

Oleg.


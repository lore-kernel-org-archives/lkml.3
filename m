Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965005AbaD2Sj1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 14:39:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14214 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756785AbaD2Sj0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 14:39:26 -0400
Date: Tue, 29 Apr 2014 20:39:15 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Benjamin LaHaise <bcrl@kvack.org>, Kent Overstreet <kmo@daterainc.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-aio@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] aio: change exit_aio() to load mm->ioctx_table once
	and avoid rcu_read_lock()
Message-ID: <20140429183915.GA32513@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Completely untested and I know nothing about aio, thus needs an ack
from maintainers or should be ignored.

But exit_aio() looks "obviously unnecessarily overcomplicated", I was
really puzzled when I looked at this code by accident.

Kent, could you also explain kioctx->dead is atomic_t? This looks
pointless? afaics atomic_ buys nothing in this case.

Oleg.


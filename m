Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965117AbaD2Td4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 15:33:56 -0400
Received: from kanga.kvack.org ([205.233.56.17]:59223 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964811AbaD2Tdz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 15:33:55 -0400
Date: Tue, 29 Apr 2014 15:33:54 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Kent Overstreet <kmo@daterainc.com>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-aio@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] aio: change exit_aio() to load mm->ioctx_table once and avoid rcu_read_lock()
Message-ID: <20140429193354.GM14608@kvack.org>
References: <20140429183915.GA32513@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140429183915.GA32513@redhat.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2014 at 08:39:15PM +0200, Oleg Nesterov wrote:
> Completely untested and I know nothing about aio, thus needs an ack
> from maintainers or should be ignored.
> 
> But exit_aio() looks "obviously unnecessarily overcomplicated", I was
> really puzzled when I looked at this code by accident.
> 
> Kent, could you also explain kioctx->dead is atomic_t? This looks
> pointless? afaics atomic_ buys nothing in this case.

If it wasn't atomic, it would need to be volatile.

		-ben
-- 
"Thought is the essence of where you are now."

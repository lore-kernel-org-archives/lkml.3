Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757583Ab3J1VVo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 17:21:44 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:39573 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475Ab3J1VVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 17:21:43 -0400
Date: Mon, 28 Oct 2013 14:21:40 -0700
From: Kent Overstreet <kmo@daterainc.com>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] percpu_ida: Move waking up waiters out of atomic
 contexts
Message-ID: <20131028212140.GG8153@kmo>
References: <cover.1382950629.git.agordeev@redhat.com>
 <20131028100522.GC5744@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131028100522.GC5744@dhcp-26-207.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 28, 2013 at 11:05:25AM +0100, Alexander Gordeev wrote:
> Currently percpu_ida_free() waikes up waiters always with local
> interrupts disabled and sometimes with pool->lock held. Yet, it
> does not appear there is any reason why it could not be done out
> of these atomic contexts.

This should be a noticable performance boost, nested irqsave/restore is painful.

Acked-by: Kent Overstreet <kmo@daterainc.com>

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965153AbaD2TtM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 15:49:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64037 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751878AbaD2TtL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 15:49:11 -0400
Date: Tue, 29 Apr 2014 21:49:00 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Kent Overstreet <kmo@daterainc.com>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-aio@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] aio: change exit_aio() to load mm->ioctx_table
	once and avoid rcu_read_lock()
Message-ID: <20140429194900.GA2998@redhat.com>
References: <20140429183915.GA32513@redhat.com> <20140429193354.GM14608@kvack.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140429193354.GM14608@kvack.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29, Benjamin LaHaise wrote:
>
> On Tue, Apr 29, 2014 at 08:39:15PM +0200, Oleg Nesterov wrote:
> >
> > Kent, could you also explain kioctx->dead is atomic_t? This looks
> > pointless? afaics atomic_ buys nothing in this case.
>
> If it wasn't atomic, it would need to be volatile.

Then ACCESS_ONCE() in aio_read_events() makes more sense. Although
I can't say I understand why it is needed.

Oleg.


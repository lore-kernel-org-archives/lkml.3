Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965358Ab3E2JTG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 05:19:06 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49344 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965261Ab3E2JTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 05:19:03 -0400
Date: Wed, 29 May 2013 11:18:08 +0200
From: Jens Axboe <axboe@kernel.dk>
To: Kent Overstreet <koverstreet@google.com>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        Zach Brown <zab@redhat.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Asai Thambi S P <asamymuthupa@micron.com>,
        Selvan Mani <smani@micron.com>, Sam Bradshaw <sbradshaw@micron.com>,
        Jeff Moyer <jmoyer@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH] aio: Use call_rcu() instead of synchronize_rcu() in
 kill_ioctx()
Message-ID: <20130529091808.GS22724@kernel.dk>
References: <1369776378-27921-1-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369776378-27921-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 28 2013, Kent Overstreet wrote:
> Just making ioctx shutdown asynchronous so as not to block io_destroy()
> - and percpu refcounts for the ioctx are going to need a RCU barrier in
> the same place anyways.

Works for me, and gets rid of that nasty regression on taking forever to
tear things down. You can add my Tested-by.

-- 
Jens Axboe


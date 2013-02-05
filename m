Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223Ab3BEASv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 19:18:51 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:49764 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755968Ab3BEASu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 19:18:50 -0500
Date: Mon, 4 Feb 2013 16:18:48 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Lin Feng <linfeng@cn.fujitsu.com>, mgorman@suse.de, bcrl@kvack.org,
        viro@zeniv.linux.org.uk, khlebnikov@openvz.org, walken@google.com,
        kamezawa.hiroyu@jp.fujitsu.com, minchan@kernel.org, riel@redhat.com,
        rientjes@google.com, isimatu.yasuaki@jp.fujitsu.com,
        wency@cn.fujitsu.com, laijs@cn.fujitsu.com, jiang.liu@huawei.com,
        linux-mm@kvack.org, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: hotplug: implement non-movable version of
 get_user_pages() called get_user_pages_non_movable()
Message-Id: <20130204161848.bfd36176.akpm@linux-foundation.org>
In-Reply-To: <20130204160624.5c20a8a0.akpm@linux-foundation.org>
References: <1359972248-8722-1-git-send-email-linfeng@cn.fujitsu.com>
	<1359972248-8722-2-git-send-email-linfeng@cn.fujitsu.com>
	<20130204160624.5c20a8a0.akpm@linux-foundation.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Also...

On Mon, 4 Feb 2013 16:06:24 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> > +put_page:
> > +	/* Undo the effects of former get_user_pages(), we won't pin anything */
> > +	for (i = 0; i < ret; i++)
> > +		put_page(pages[i]);

We can use release_pages() here.

release_pages() is designed to be more efficient when we're putting the
final reference to (most of) the pages.  It probably has little if any
benefit when putting still-in-use pages, as we're doing here.

But please consider...

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349AbaCKTbi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 15:31:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44624 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755156AbaCKTbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 15:31:35 -0400
Date: Tue, 11 Mar 2014 12:31:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Randy Dunlap <rdunlap@infradead.org>, mm-commits@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-next@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>, virtio-dev@lists.oasis-open.org,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: mmotm 2014-03-10-15-35 uploaded (virtio_balloon)
Message-Id: <20140311123133.f40adf3154452e82aecb61ca@linux-foundation.org>
In-Reply-To: <20140311192046.GA2686@leaf>
References: <20140310223701.0969C31C2AA@corp2gmr1-1.hot.corp.google.com>
	<531F43F2.1030504@infradead.org>
	<20140311110338.333e1ee691cadb0f20dbb083@linux-foundation.org>
	<20140311192046.GA2686@leaf>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Mar 2014 12:20:46 -0700 Josh Triplett <josh@joshtriplett.org> wrote:

> > > ERROR: "balloon_devinfo_alloc" [drivers/virtio/virtio_balloon.ko] undefined!
> > > ERROR: "balloon_page_enqueue" [drivers/virtio/virtio_balloon.ko] undefined!
> > > ERROR: "balloon_page_dequeue" [drivers/virtio/virtio_balloon.ko] undefined!
> > > 
> > > when loadable module
> > > 
> > > or
> > > 
> > > virtio_balloon.c:(.text+0x1fa26): undefined reference to `balloon_page_enqueue'
> > > virtio_balloon.c:(.text+0x1fb87): undefined reference to `balloon_page_dequeue'
> > > virtio_balloon.c:(.text+0x1fdf1): undefined reference to `balloon_devinfo_alloc'
> > > 
> > > when builtin.
> > 
> > OK, thanks, I'll drop
> > http://ozlabs.org/~akpm/mmots/broken-out/mm-disable-mm-balloon_compactionc-completely-when-config_balloon_compaction.patch
> 
> Sorry about that; I missed that case in my testing.  It always seems
> strange that the dependency goes that way around.
> 
> With virtio-balloon being the one and only user of this API, would it be
> reasonable to just only compile in balloon_compaction.o when
> CONFIG_VIRTIO_BALLOON?

Better to make VIRTIO_BALLOON depend on (or select) BALLOON_COMPACTION.

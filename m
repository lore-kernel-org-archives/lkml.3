Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757932Ab3EGLjX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 07:39:23 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:65050 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756685Ab3EGLjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 07:39:21 -0400
MIME-Version: 1.0
X-Originating-IP: [188.6.195.195]
In-Reply-To: <517ABCF6.5040103@parallels.com>
References: <20130401103749.19027.89833.stgit@maximpc.sw.ru>
	<20130401104250.19027.27795.stgit@maximpc.sw.ru>
	<51793DE6.3000503@parallels.com>
	<CAJfpegv1zc4oeE=YXrQd0jmzVXB8jjvXkz-_4Nv_ELcvfsa74Q@mail.gmail.com>
	<517956ED.7060102@parallels.com>
	<20130425204331.GB16238@tucsk.piliscsaba.szeredi.hu>
	<517A3B98.807@parallels.com>
	<20130426140240.GC16238@tucsk.piliscsaba.szeredi.hu>
	<517ABCF6.5040103@parallels.com>
Date: Tue, 7 May 2013 13:39:19 +0200
Message-ID: <CAJfpegucNfxYsz3G2JwxK5JtDPaYQu-SUR_VGvwCDz_iTGBt5Q@mail.gmail.com>
Subject: Re: [fuse-devel] [PATCH 14/14] mm: Account for WRITEBACK_TEMP in balance_dirty_pages
From: Miklos Szeredi <miklos@szeredi.hu>
To: "Maxim V. Patlasov" <mpatlasov@parallels.com>
Cc: Kirill Korotaev <dev@parallels.com>, Pavel Emelianov <xemul@parallels.com>,
        "fuse-devel@lists.sourceforge.net" <fuse-devel@lists.sourceforge.net>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        James Bottomley <jbottomley@parallels.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, devel@openvz.org,
        Andrew Morton <akpm@linux-foundation.org>, fengguang.wu@intel.com,
        Mel Gorman <mgorman@suse.de>, riel@redhat.com, hughd@google.com,
        gthelen@google.com, linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 26, 2013 at 7:44 PM, Maxim V. Patlasov
<mpatlasov@parallels.com> wrote:
> I'm for accounting NR_WRITEBACK_TEMP because balance_dirty_pages is already
> overcomplicated (imho) and adding new clauses for FUSE makes me sick.

Agreed.

But instead of further complexifying balance_dirty_pages() fuse
specific throttling can be done in fuse_page_mkwrite(), I think.

And at that point NR_WRITEBACK_TEMP really becomes irrelevant to the
dirty balancing logic.

Thanks,
Miklos

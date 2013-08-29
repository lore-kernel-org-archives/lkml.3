Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755142Ab3H2QWD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 12:22:03 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:46095 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754205Ab3H2QWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 12:22:00 -0400
MIME-Version: 1.0
X-Originating-IP: [86.59.245.170]
In-Reply-To: <521F40BE.901@parallels.com>
References: <20130816115057.6492.39356.stgit@maximpc.sw.ru>
	<20130829114650.GA19636@tucsk.piliscsaba.szeredi.hu>
	<521F40BE.901@parallels.com>
Date: Thu, 29 Aug 2013 18:21:59 +0200
Message-ID: <CAJfpeguFcc=TmQDJ6Co1GcCb-_zr226Q+DQ143vYfa0EEyngKg@mail.gmail.com>
Subject: Re: [PATCH] fuse: fix race in fuse_writepages()
From: Miklos Szeredi <miklos@szeredi.hu>
To: Maxim Patlasov <mpatlasov@parallels.com>
Cc: fuse-devel <fuse-devel@lists.sourceforge.net>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>, devel@openvz.org,
        Pavel Emelianov <xemul@parallels.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 29, 2013 at 2:38 PM, Maxim Patlasov <mpatlasov@parallels.com> wrote:

>> Just one nit, why orig_pages? req->pages is already there, so why
>> duplicate it?
>
>
> req->pages is there, but it is already occupied by new pages (allocated by
> fuse_writepages_fill). We can't re-use req->pages for original pages because
> as soon as we put the request to bg_queue (in fuse_writepages_send) and
> released fc->lock, req->pages may be accessed w/o any delay. So we have two
> bunches of pointers to "struct page" to be stashed somewhere : original and
> new one. req->pages is for new pages, orig_pages[] is for original ones.

Yeah.  Applied the original patch.

Thanks,
Miklos

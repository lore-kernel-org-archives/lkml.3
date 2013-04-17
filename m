Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966807Ab3DQUxW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 16:53:22 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:56925 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966783Ab3DQUxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 16:53:20 -0400
MIME-Version: 1.0
X-Originating-IP: [188.6.195.195]
In-Reply-To: <CAJfpegtvfunCV4cjezQuWji3PoJRpXXKWgH+y55tYMi0O+TdkQ@mail.gmail.com>
References: <20121220122702.4101.80042.stgit@maximpc.sw.ru>
	<CAJfpegsD2iyP2=Z3zL-yb_TjjQxipOBKV7yqpdPPTH9oobQ=bA@mail.gmail.com>
	<CAJfpegtvfunCV4cjezQuWji3PoJRpXXKWgH+y55tYMi0O+TdkQ@mail.gmail.com>
Date: Wed, 17 Apr 2013 22:53:18 +0200
Message-ID: <CAJfpegvJGBuOpYi=W3rzzu4Jwa46e_9SxDC4fa-PPmCQs2K3rg@mail.gmail.com>
Subject: Re: [PATCH 0/5] fuse: close file synchronously
From: Miklos Szeredi <miklos@szeredi.hu>
To: Maxim Patlasov <mpatlasov@parallels.com>
Cc: Kirill Korotaev <dev@parallels.com>, Pavel Emelianov <xemul@parallels.com>,
        fuse-devel <fuse-devel@lists.sourceforge.net>,
        Brian Foster <bfoster@redhat.com>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>, devel@openvz.org,
        Anand Avati <anand.avati@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 15, 2013 at 5:30 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> Let's approach it from the other direction:  what if you give back the
> write lease on the first flush?  It will probably work fine for 99% of
> cases, since no other writes are going to happen after the first
> flush.  For the remaining cases you'll just have to reacquire the
> lease when a write happens after the flush.  I guess performance-wise
> that will not be an issue, but I may be wrong.

What about this?

Thanks,
Miklos

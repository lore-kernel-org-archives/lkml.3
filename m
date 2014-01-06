Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326AbaAFQWA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 11:22:00 -0500
Received: from mail-ee0-f53.google.com ([74.125.83.53]:37169 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754557AbaAFQV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 11:21:58 -0500
Date: Mon, 6 Jan 2014 17:22:42 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: Maxim Patlasov <mpatlasov@parallels.com>
Cc: dev@parallels.com, xemul@parallels.com, fuse-devel@lists.sourceforge.net,
        bfoster@redhat.com, linux-kernel@vger.kernel.org,
        jbottomley@parallels.com, linux-fsdevel@vger.kernel.org,
        akpm@linux-foundation.org, fengguang.wu@intel.com, devel@openvz.org
Subject: Re: [PATCH 05/11] fuse: Trust kernel i_mtime only -v2
Message-ID: <20140106162242.GE16230@tucsk.piliscsaba.szeredi.hu>
References: <20131010130718.10089.6736.stgit@dhcp-10-30-17-2.sw.ru>
 <20131010131051.10089.62357.stgit@dhcp-10-30-17-2.sw.ru>
 <20131112165251.GA10813@tucsk.piliscsaba.szeredi.hu>
 <52BC4E35.8040503@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52BC4E35.8040503@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 26, 2013 at 07:41:41PM +0400, Maxim Patlasov wrote:
> >>+
> >>+	if (!err)
> >>+		clear_bit(FUSE_I_MTIME_DIRTY, &fi->state);
> >Doing the test and the clear separately opens a huge race window when i_mtime
> >modifications are bound to get lost.
> 
> No. Because the whole operation is protected by i_mutex (see
> fuse_fsync_common()).

fuse_release_common() doesn't have i_mutex.  It's probably safe to acquire it,
but is that really needed?

Thanks,
Miklos

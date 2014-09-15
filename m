Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759931AbaIOXC6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 19:02:58 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:46352 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755175AbaIOXCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 19:02:55 -0400
X-Original-SENDERIP: 10.177.220.156
X-Original-MAILFROM: minchan@kernel.org
Date: Tue, 16 Sep 2014 08:03:06 +0900
From: Minchan Kim <minchan@kernel.org>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Jerome Marchand <jmarchan@redhat.com>, Nitin Gupta <ngupta@vflare.org>,
        Chao Yu <chao2.yu@samsung.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3] zram: use notify_free to account all free notifications
Message-ID: <20140915230306.GC10912@bbox>
References: <1410792568-31539-1-git-send-email-sergey.senozhatsky@gmail.com>
 <1410792568-31539-2-git-send-email-sergey.senozhatsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1410792568-31539-2-git-send-email-sergey.senozhatsky@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2014 at 11:49:28PM +0900, Sergey Senozhatsky wrote:
> `notify_free' device attribute accounts the number of slot free notifications
> and internally represents the number of zram_free_page() calls. Slot free
> notifications are sent only when device is used as a swap device, hence
> `notify_free' is used only for swap devices. Since f4659d8e620d08 (zram:
> support REQ_DISCARD) ZRAM handles yet another one free notification (also
> via zram_free_page() call) -- REQ_DISCARD requests, which are sent by a
> filesystem, whenever some data blocks are discarded. However, there is no
> way to know the number of notifications in the latter case.
> 
> Use `notify_free' to account the number of pages freed by zram_bio_discard()
> and zram_slot_free_notify(). Depending on usage scenario `notify_free'
> represents:
>  a) the number of pages freed because of slot free notifications, which is
>    equal to the number of swap_slot_free_notify() calls, so there is no
>    behaviour change
> 
>  b) the number of pages freed because of REQ_DISCARD notifications
> 
> Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>

Thanks a lot!

-- 
Kind regards,
Minchan Kim

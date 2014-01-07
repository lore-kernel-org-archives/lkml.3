Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756417AbaAGCEs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 21:04:48 -0500
Received: from mail-ob0-f171.google.com ([209.85.214.171]:37850 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753544AbaAGCEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 21:04:46 -0500
MIME-Version: 1.0
In-Reply-To: <1387415531-10713-1-git-send-email-kmo@daterainc.com>
References: <1387415531-10713-1-git-send-email-kmo@daterainc.com>
From: Mike Snitzer <snitzer@redhat.com>
Date: Mon, 6 Jan 2014 21:04:25 -0500
X-Google-Sender-Auth: VZny_YLWsT_N1DN9ZYPQLliWlL0
Message-ID: <CAMM=eLcGTYcSdYW9vWYWk64dRuwgyY_O90NySb_jR9zQTCBTJg@mail.gmail.com>
Subject: Re: [PATCH] bcache/md: Use raid stripe size
To: Kent Overstreet <kmo@daterainc.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-bcache@vger.kernel.org, Neil Brown <neilb@suse.de>,
        Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 8:12 PM, Kent Overstreet <kmo@daterainc.com> wrote:
> Now that we've got code for raid5/6 stripe awareness, bcache just needs
> to know about the stripes and when writing partial stripes is expensive
> - we probably don't want to enable this optimization for raid1 or 10,
> even though they have stripes. So add a flag to queue_limits.
>
> Signed-off-by: Kent Overstreet <kmo@daterainc.com>
> ---
> This is in my pile of bcache stuff queued up for 3.14 - if no one objects it'll
> be in my bcache pull request:
>
>  drivers/md/bcache/super.c | 6 ++++++
>  drivers/md/raid5.c        | 1 +
>  include/linux/blkdev.h    | 1 +
>  3 files changed, 8 insertions(+)

Hi Kent,

> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 02cb6f0ea7..0375654adb 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -291,6 +291,7 @@ struct queue_limits {
>         unsigned char           discard_misaligned;
>         unsigned char           cluster;
>         unsigned char           discard_zeroes_data;
> +       unsigned char           raid_partial_stripes_expensive;
>  };
>
>  struct request_queue {

If you add a new member to queue_limits you need to update
blk_stack_limits() so that it propagates as you stack devices.

You probably also want to update blk_set_default_limits.

Mike

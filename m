Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932115Ab3CDRnl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 12:43:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53970 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758417Ab3CDRnj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 12:43:39 -0500
Date: Mon, 4 Mar 2013 17:42:54 +0000
From: Alasdair G Kergon <agk@redhat.com>
To: Paul Taysom <taysom@chromium.org>
Cc: agk@redhat.com, dm-devel@redhat.com, neilb@suse.de,
        linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        msb@chromium.org, mpatocka@redhat.com, olofj@chromium.org
Subject: Re: [PATCH] md: dm-verity: Fix to avoid a deadlock in dm-bufio
Message-ID: <20130304174254.GF8913@agk.fab.redhat.com>
Mail-Followup-To: Paul Taysom <taysom@chromium.org>, agk@redhat.com,
	dm-devel@redhat.com, neilb@suse.de, linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org, msb@chromium.org, mpatocka@redhat.com,
	olofj@chromium.org
References: <1362415549-18653-1-git-send-email-taysom@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362415549-18653-1-git-send-email-taysom@chromium.org>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 03798903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 04, 2013 at 08:45:48AM -0800, Paul Taysom wrote:
> @@ -449,8 +468,14 @@ static void verity_prefetch_io(struct dm_verity *v, struct dm_verity_io *io)
>  				hash_block_end = v->hash_blocks - 1;
>  		}
>  no_prefetch_cluster:
> -		dm_bufio_prefetch(v->bufio, hash_block_start,
> -				  hash_block_end - hash_block_start + 1);
> +		vw = kmalloc(sizeof(*vw), GFP_KERNEL);

kmalloc?  mempool? ...

Alasdair


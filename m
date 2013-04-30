Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096Ab3D3GId (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 02:08:33 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:52704
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752680Ab3D3GIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 02:08:32 -0400
Date: Tue, 30 Apr 2013 08:08:29 +0200
From: Jens Axboe <axboe@kernel.dk>
To: remaper <yp.fangdong@gmail.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: generic_make_request not locked
Message-ID: <20130430060829.GF9563@kernel.dk>
References: <tencent_0BD3EAC403C9DFE43143959B@qq.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_0BD3EAC403C9DFE43143959B@qq.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 30 2013, remaper wrote:
> /*
>  * We only want one ->make_request_fn to be active at a time,
>  * else stack usage with stacked devices could be a problem.
>  * So use current->bio_list to keep a list of requests
>  * submited by a make_request_fn function.
>  * current->bio_list is also used as a flag to say if
>  * generic_make_request is currently active in this task or not.
>  * If it is NULL, then no make_request is active.  If it is non-NULL,
>  * then a make_request is active, and new requests should be added
>  * at the tail
>  */
> void generic_make_request(struct bio *bio)
> {
> ...
>     if (current->bio_list) {
>         /* make_request is active */
>         bio_list_add(current->bio_list, bio);
>         return;
>     }
> ...
> }
> 
> current->bio_list is a global variable, and generic_make_request would
> run on multithread environment, so, i don't understand why here(
> bio_list_add ) not lock?  thx everybody.

'current' refers to the task currently executing task. So
current->bio_list isn't shared, hence there's no need for any locking.

-- 
Jens Axboe


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526AbaFXPl6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 11:41:58 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:47128 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186AbaFXPl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 11:41:57 -0400
MIME-Version: 1.0
In-Reply-To: <20140623144831.83abcda7446956e8d7502f09@linux-foundation.org>
References: <1400958369-3588-1-git-send-email-ddstreet@ieee.org>
 <1401747586-11861-1-git-send-email-ddstreet@ieee.org> <1401747586-11861-7-git-send-email-ddstreet@ieee.org>
 <20140623144831.83abcda7446956e8d7502f09@linux-foundation.org>
From: Dan Streetman <ddstreet@ieee.org>
Date: Tue, 24 Jun 2014 11:41:33 -0400
X-Google-Sender-Auth: TWL7OPabrGOEoogojL1VNgD0LpE
Message-ID: <CALZtONBra8HJxP-KM5FtMZThfJXe-M0TNqmFq7rJJUzUKA=KEg@mail.gmail.com>
Subject: Re: [PATCHv2 6/6] mm/zpool: prevent zbud/zsmalloc from unloading when used
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Seth Jennings <sjennings@variantweb.net>, Minchan Kim <minchan@kernel.org>,
        Weijie Yang <weijie.yang@samsung.com>, Nitin Gupta <ngupta@vflare.org>,
        Bob Liu <bob.liu@oracle.com>, Hugh Dickins <hughd@google.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Linux-MM <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2014 at 5:48 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Mon,  2 Jun 2014 18:19:46 -0400 Dan Streetman <ddstreet@ieee.org> wrote:
>
>> Add try_module_get() to zpool_create_pool(), and module_put() to
>> zpool_destroy_pool().  Without module usage counting, the driver module(s)
>> could be unloaded while their pool(s) were active, resulting in an oops
>> when zpool tried to access them.
>
> Was wondering about that ;)  We may as well fold
> this fix into "mm/zpool: implement common zpool api to zbud/zsmalloc"?

Yes.  Sorry, I had this pulled out of that because I was trying to
keep the patches logically separated.  But they do need to be
together, to be safe ;-)

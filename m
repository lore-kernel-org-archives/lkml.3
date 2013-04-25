Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758950Ab3DYPuE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 11:50:04 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:34878 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758820Ab3DYPuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 11:50:00 -0400
MIME-Version: 1.0
X-Originating-IP: [188.6.195.195]
In-Reply-To: <51793DE6.3000503@parallels.com>
References: <20130401103749.19027.89833.stgit@maximpc.sw.ru>
	<20130401104250.19027.27795.stgit@maximpc.sw.ru>
	<51793DE6.3000503@parallels.com>
Date: Thu, 25 Apr 2013 17:49:58 +0200
Message-ID: <CAJfpegv1zc4oeE=YXrQd0jmzVXB8jjvXkz-_4Nv_ELcvfsa74Q@mail.gmail.com>
Subject: Re: [fuse-devel] [PATCH 14/14] mm: Account for WRITEBACK_TEMP in balance_dirty_pages
From: Miklos Szeredi <miklos@szeredi.hu>
To: "Maxim V. Patlasov" <mpatlasov@parallels.com>
Cc: Kirill Korotaev <dev@parallels.com>, Pavel Emelianov <xemul@parallels.com>,
        "fuse-devel@lists.sourceforge.net" <fuse-devel@lists.sourceforge.net>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        James Bottomley <jbottomley@parallels.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, devel@openvz.org,
        Andrew Morton <akpm@linux-foundation.org>, fengguang.wu@intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 25, 2013 at 4:29 PM, Maxim V. Patlasov
<mpatlasov@parallels.com> wrote:
>> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
>> index 0713bfb..c47bcd4 100644
>> --- a/mm/page-writeback.c
>> +++ b/mm/page-writeback.c
>> @@ -1235,7 +1235,8 @@ static void balance_dirty_pages(struct address_space
>> *mapping,
>>                  */
>>                 nr_reclaimable = global_page_state(NR_FILE_DIRTY) +
>>
>> global_page_state(NR_UNSTABLE_NFS);
>> -               nr_dirty = nr_reclaimable +
>> global_page_state(NR_WRITEBACK);
>> +               nr_dirty = nr_reclaimable +
>> global_page_state(NR_WRITEBACK) +
>> +                       global_page_state(NR_WRITEBACK_TEMP);
>>                 global_dirty_limits(&background_thresh, &dirty_thresh);
>
>
> Please drop this patch. As we discussed in LSF/MM, the fix above is correct,
> but it's not enough: we also need to ensure disregard of NR_WRITEBACK_TEMP
> when balance_dirty_pages() is called from fuse daemon. I'll send a separate
> patch-set soon.

Please elaborate.  From a technical perspective "fuse daemon" is very
hard to define, so anything that relies on whether something came from
the fuse daemon or not is conceptually broken.

Thanks,
Miklos

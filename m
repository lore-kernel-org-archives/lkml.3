Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247Ab3CRL2u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 07:28:50 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:54862 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158Ab3CRL2q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 07:28:46 -0400
MIME-Version: 1.0
In-Reply-To: <1363601594.14386.72.camel@kjgkr>
References: <1363586028-8617-1-git-send-email-jaegeuk.kim@samsung.com>
	<CAKYAXd92_Lxp9A3QCzwhWdctMz=AMVUwzOEqxcbRppLH5dn+hQ@mail.gmail.com>
	<1363601594.14386.72.camel@kjgkr>
Date: Mon, 18 Mar 2013 20:28:45 +0900
Message-ID: <CAKYAXd9GvTga8pEFzA=s_FWoiCzco8i8AUt+b=Xf5SUOhOd-Jw@mail.gmail.com>
Subject: Re: [PATCH] f2fs: fix not to allocate max_nid
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/3/18, Jaegeuk Kim <jaegeuk.kim@samsung.com>:
> 2013-03-18 (월), 18:29 +0900, Namjae Jeon:
>> 2013/3/18, Jaegeuk Kim <jaegeuk.kim@samsung.com>:
>> > The build_free_nid should not add free nids over nm_i->max_nid.
>> > But, there was a hole that invalid free nid was added by the following
>> > scenario.
>> >
>> > Let's suppose nm_i->max_nid = 150 and the last NAT page has 100 ~ 200
>> > nids.
>> >
>> > build_free_nids
>> >   - get_current_nat_page loads the last NAT page
>> >   - scan_nat_page can add 100 ~ 200 nids
>> >     -> Bug here!
>> > So, when scanning an NAT page, we should check each candidate whether it
>> > is
>> > over max_nid or not.
>> >
>> > Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
>> > ---
>> >  fs/f2fs/node.c | 2 ++
>> >  1 file changed, 2 insertions(+)
>> >
>> > diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
>> > index c60919f..3fb6dfe 100644
>> > --- a/fs/f2fs/node.c
>> > +++ b/fs/f2fs/node.c
>> > @@ -1270,6 +1270,8 @@ static int scan_nat_page(struct f2fs_nm_info
>> > *nm_i,
>> >  	i = start_nid % NAT_ENTRY_PER_BLOCK;
>> >
>> >  	for (; i < NAT_ENTRY_PER_BLOCK; i++, start_nid++) {
>> > +		if (start_nid >= nm_i->max_nid)
>> > +			return fcnt;
>> Hi Jaegeuk.
>> How about use "break;" instread of "return fcnt" ?
>> I think that break is better because there is no extra condition before
>> return.
>
> Ok, thanks. :)
Okay, you can add
Reviewed-by: Namjae Jeon <namjae.jeon@samsung.com>
Thanks.

>
>>
>> Thanks.
>> >  		blk_addr  = le32_to_cpu(nat_blk->entries[i].block_addr);
>> >  		BUG_ON(blk_addr == NEW_ADDR);
>> >  		if (blk_addr == NULL_ADDR)
>> > --
>> > 1.8.1.3.566.gaa39828
>> >
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-fsdevel"
>> > in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> >
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel"
>> in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
> --
> Jaegeuk Kim
> Samsung
>

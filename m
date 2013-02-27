Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759677Ab3B0BlW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 20:41:22 -0500
Received: from mail-oa0-f50.google.com ([209.85.219.50]:62715 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754541Ab3B0BlU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 20:41:20 -0500
MIME-Version: 1.0
In-Reply-To: <1361927080.31428.25.camel@kjgkr>
References: <1361857068-31613-1-git-send-email-jaegeuk.kim@samsung.com>
	<1361857068-31613-2-git-send-email-jaegeuk.kim@samsung.com>
	<CAKYAXd-8cJaE8Ry1biTyM1utWs4J8gppBLadz36LMcny+W5EBA@mail.gmail.com>
	<1361927080.31428.25.camel@kjgkr>
Date: Wed, 27 Feb 2013 10:41:19 +0900
Message-ID: <CAKYAXd_bMFDuuNzdvsDLC7EviAzp_zu7rK2pgoakjur+Xa-NQg@mail.gmail.com>
Subject: Re: [PATCH 2/2] f2fs: introduce readahead mode of node pages
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/2/27, Jaegeuk Kim <jaegeuk.kim@samsung.com>:
> 2013-02-26 (화), 20:52 +0900, Namjae Jeon:
>> > @@ -434,7 +434,7 @@ int get_dnode_of_data(struct dnode_of_data *dn,
>> > pgoff_t
>> > index, int ro)
>> >  			alloc_nid_done(sbi, nids[i]);
>> >  			mutex_unlock_op(sbi, NODE_NEW);
>> >  			done = true;
>> > -		} else if (ro && i == level && level > 1) {
>> > +		} else if (mode == LOOKUP_NODE_RA && i == level && level > 1) {
>> >  			npage[i] = get_node_page_ra(parent, offset[i - 1]);
>> >  			if (IS_ERR(npage[i])) {
>> >  				err = PTR_ERR(npage[i]);
>>
>> Hi Jaegeuk.
>> There is no LOOKUP_NODE usage in this patch.
>> I think that we can use LOOKUP_NODE flag instead of done(bool)  like
>> this.
>>  if (mode == LOOKUP_NODE)
>
> Hi.
> In order to do that, we should check additional conditions like i and
> level together with mode == LOOKUP_NODE.
> So, I'm not sure how much it makes clearer by using LOOKUP_NODE
> explicitly.
> It seems fine to me, since we can just use LOOKUP_NODE to distinguish it
> from the other modes.
> Any thought?
I agree. And It does really need additional condition.
So Rather, It can make more complicated If using LOOKUP_NODE.
Looks reasonable to me on current change.

Reviewed-by: Namjae Jeon <namjae.jeon@samsung.com>

Thanks!
>
> --
> Jaegeuk Kim
> Samsung
>

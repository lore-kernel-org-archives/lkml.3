Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751621AbaBSBIl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 20:08:41 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:42670 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbaBSBIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 20:08:39 -0500
MIME-Version: 1.0
In-Reply-To: <20140218143005.GO26580@thunk.org>
References: <1391319874-3203-1-git-send-email-linkinjeon@gmail.com>
	<alpine.LFD.2.00.1402111209450.2225@localhost.localdomain>
	<CAKYAXd-bD6ZZgpc9E8V1kD9Dj2wrCkbi1i6drNBdUAwsMiv5gg@mail.gmail.com>
	<alpine.LFD.2.00.1402181001530.2216@localhost.localdomain>
	<CAKYAXd_xpWg-=T_1PghL_u9wDKTX_Ey5mJxbgVVKth8NoexQQg@mail.gmail.com>
	<20140218143005.GO26580@thunk.org>
Date: Wed, 19 Feb 2014 10:08:39 +0900
Message-ID: <CAKYAXd9E41d2Kt+Sz-d3toUFUrTLtjrOYqq32NQViM_abRWTxg@mail.gmail.com>
Subject: Re: [PATCH RESEND 3/10] ext4: Add support FALLOC_FL_COLLAPSE_RANGE
 for fallocate
From: Namjae Jeon <linkinjeon@gmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Namjae Jeon <linkinjeon@gmail.com>,
        =?UTF-8?B?THVrw6HFoSBDemVybmVy?= <lczerner@redhat.com>,
        viro@zeniv.linux.org.uk, david@fromorbit.com, bpm@sgi.com,
        adilger.kernel@dilger.ca, jack@suse.cz, mtk.manpages@gmail.com,
        linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ashish Sangwan <a.sangwan@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-02-18 23:30 GMT+09:00, Theodore Ts'o <tytso@mit.edu>:
> Namjae,
Hi Ted.
>
> Did you respond to Matthew Wilcox's comments/question from Feb. 2nd?
Sorry, I didn't catch about this.
I just replied from Matthew's mail.
Thanks for your remind.
>
>> > What if the file is mmaped at the time somebody issues this command?
>> > Seems to me we should drop pagecache pages that overlap with the
>> > removed blocks.  If the removed range is not a multiple of PAGE_SIZE,
>> > then we should also drop any pagecache pages after the removed range.
>>
>> Oops, forgot to add "and if it is a multiple of page size, then we need
>> to update the offsets of any pages after the removed page".
>
> Dave responded that XFS does the right thing when doing a punch hole
> operation, but it wasn't obvious to me whether FL_COLLAPSE_RANGE does
> the right thing with ext4.
>
> Thanks,
>
> 					- Ted
>

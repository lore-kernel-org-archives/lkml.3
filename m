Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759396Ab3DAT1Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 15:27:24 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:40595 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753696Ab3DAT1X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 15:27:23 -0400
Subject: Re: mkfs.f2fs gets stuck with "blk_update_request: bio idx 0 >= vcnt 0" on 3.8
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Vyacheslav Dubeyko <slava@dubeyko.com>
In-Reply-To: <CAMo8BfLusS_vT4LWU93iCXpVSgN_Uvi1mBvLUVx+892V67X1JQ@mail.gmail.com>
Date: Mon, 1 Apr 2013 23:27:10 +0400
Cc: LKML <linux-kernel@vger.kernel.org>, Jaegeuk Kim <jaegeuk.kim@samsung.com>,
        Jens Axboe <axboe@kernel.dk>
Content-Transfer-Encoding: 8BIT
Message-Id: <254789F5-7950-4239-AB7B-2DB9DC73565F@dubeyko.com>
References: <CAMo8BfLusS_vT4LWU93iCXpVSgN_Uvi1mBvLUVx+892V67X1JQ@mail.gmail.com>
To: Max Filippov <jcmvbkbc@gmail.com>
X-Mailer: Apple Mail (2.1085)
X-Identified-User: {2172:host202.hostmonster.com:dubeykoc:dubeyko.com} {sentby:smtp auth 46.39.244.28 authed with slava@dubeyko.com}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 1, 2013, at 9:19 PM, Max Filippov wrote:

> Hi,
> 
> I'm trying to create f2fs filesystem on SD card on pandaboard using
> f2fs-tools v1.0.0.
> It works fine on Linus' v3.6, but fails on both v3.8 and stable v3.8.5:
> 
> # mkfs.f2fs /dev/mmcblk0p3
> Info: sector size = 512
> Info: total sectors = 11370496 (in 512bytes)
> Info: zone aligned segment0 blkaddr: 512
> [  257.789764] blk_update_request: bio idx 0 >= vcnt 0
> 
> mkfs process gets stuck in D state and I see the following in the dmesg:
> 
> [  257.789733] __end_that: dev mmcblk0: type=1, flags=122c8081
> [  257.789764]   sector 4194304, nr/cnr 2981888/4294959104
> [  257.789764]   bio df3840c0, biotail df3848c0, buffer   (null), len 1526726656
> [  257.789764] blk_update_request: bio idx 0 >= vcnt 0
> [  257.794921] request botched: dev mmcblk0: type=1, flags=122c8081
> [  257.794921]   sector 4194304, nr/cnr 2981888/4294959104
> [  257.794921]   bio df3840c0, biotail df3848c0, buffer   (null), len 1526726656
> 
> I'd appreciate any suggestion on what to try before I try to bisect it.
> 

Could you share "cat /proc/partitions" and "strace mkfs.f2fs /dev/mmcblk0p3" outputs? I think that these outputs can be very useful for issue analysis.

By the way, can you reproduce the issue on another SD-card? Do you reproduce the issue only under pandaboard?

Thanks,
Vyacheslav Dubeyko.

> -- 
> Thanks.
> -- Max
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


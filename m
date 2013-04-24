Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105Ab3DXOXO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 10:23:14 -0400
Received: from mx2.parallels.com ([199.115.105.18]:57910 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421Ab3DXOXN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 10:23:13 -0400
From: James Bottomley <jbottomley@parallels.com>
To: Namjae Jeon <linkinjeon@gmail.com>
CC: "axboe@kernel.dk" <axboe@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] block: fix max discard sectors limit
Thread-Topic: [PATCH] block: fix max discard sectors limit
Thread-Index: AQHOQPNjOY9PP2kNxE+HkpJoT/qqgpjl4e6A
Date: Wed, 24 Apr 2013 14:23:09 +0000
Message-ID: <1366813389.1971.1.camel@dabdike>
References: <1366811721-2478-1-git-send-email-linkinjeon@gmail.com>
In-Reply-To: <1366811721-2478-1-git-send-email-linkinjeon@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [24.18.112.117]
Content-Type: text/plain; charset=US-ASCII
Content-ID: <F103A0573AD49B4AB9E8464EE7BC6BBC@sw.swsoft.com>
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-04-24 at 22:55 +0900, Namjae Jeon wrote:
> From: James Bottomley <JBottomley@Parallels.com>
> 
> linux-v3.8-rc1 and later support for plug for blkdev_issue_discard with
> commit 0cfbcafcae8b7364b5fa96c2b26ccde7a3a296a9
> (block: add plug for blkdev_issue_discard )
> 
> For example,
> 1) DISCARD rq-1 with size size 4GB
> 2) DISCARD rq-2 with size size 1GB
> 
> If these 2 discard requests get merged, final request size will be 5GB.
> 
> In this case, request's __data_len field may overflow as it can store
> max 4GB(unsigned int).
> 
> This issue was observed while doing mkfs.f2fs on 5GB SD card:
> https://lkml.org/lkml/2013/4/1/292
> 
> Info: sector size = 512
> Info: total sectors = 11370496 (in 512bytes)
> Info: zone aligned segment0 blkaddr: 512
> [  257.789764] blk_update_request: bio idx 0 >= vcnt 0
> 
> mkfs process gets stuck in D state and I see the following in the dmesg:
> 
> [  257.789733] __end_that: dev mmcblk0: type=1, flags=122c8081
> [  257.789764]   sector 4194304, nr/cnr 2981888/4294959104
> [  257.789764]   bio df3840c0, biotail df3848c0, buffer   (null), len
> 1526726656
> [  257.789764] blk_update_request: bio idx 0 >= vcnt 0
> [  257.794921] request botched: dev mmcblk0: type=1, flags=122c8081
> [  257.794921]   sector 4194304, nr/cnr 2981888/4294959104
> [  257.794921]   bio df3840c0, biotail df3848c0, buffer   (null), len
> 1526726656
> 
> This patch fixes this issue.
> 
> Reported-by: Max Filippov <jcmvbkbc@gmail.com>
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: James Bottomley <JBottomley@Parallels.com>
> Tested-by: Max Filippov <jcmvbkbc@gmail.com>
> Cc: <stable@vger.kernel.org>

The two signoffs need to be reversed (they follow the chain of
transmission from the author into the kernel), but other than that, this
looks great.  I assume Jens can just hand edit this one issue.

Thanks,

James


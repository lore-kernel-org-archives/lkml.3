Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021Ab3DXO3d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 10:29:33 -0400
Received: from mx2.parallels.com ([199.115.105.18]:36104 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755456Ab3DXO3a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 10:29:30 -0400
From: James Bottomley <jbottomley@parallels.com>
To: Jens Axboe <axboe@kernel.dk>
CC: Namjae Jeon <linkinjeon@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] block: fix max discard sectors limit
Thread-Topic: [PATCH] block: fix max discard sectors limit
Thread-Index: AQHOQPNjOY9PP2kNxE+HkpJoT/qqgpjl4goAgAABqAA=
Date: Wed, 24 Apr 2013 14:29:29 +0000
Message-ID: <1366813768.1971.2.camel@dabdike>
References: <1366811721-2478-1-git-send-email-linkinjeon@gmail.com>
	 <20130424142332.GD2759@kernel.dk>
In-Reply-To: <20130424142332.GD2759@kernel.dk>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [24.18.112.117]
Content-Type: text/plain; charset=US-ASCII
Content-ID: <FBE76C8955900848AE7552020E2C418E@sw.swsoft.com>
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-04-24 at 08:23 -0600, Jens Axboe wrote:
> On Wed, Apr 24 2013, Namjae Jeon wrote:
> > From: James Bottomley <JBottomley@Parallels.com>
> > 
> > linux-v3.8-rc1 and later support for plug for blkdev_issue_discard with
> > commit 0cfbcafcae8b7364b5fa96c2b26ccde7a3a296a9
> > (block: add plug for blkdev_issue_discard )
> > 
> > For example,
> > 1) DISCARD rq-1 with size size 4GB
> > 2) DISCARD rq-2 with size size 1GB
> > 
> > If these 2 discard requests get merged, final request size will be 5GB.
> > 
> > In this case, request's __data_len field may overflow as it can store
> > max 4GB(unsigned int).
> > 
> > This issue was observed while doing mkfs.f2fs on 5GB SD card:
> > https://lkml.org/lkml/2013/4/1/292
> > 
> > Info: sector size = 512
> > Info: total sectors = 11370496 (in 512bytes)
> > Info: zone aligned segment0 blkaddr: 512
> > [  257.789764] blk_update_request: bio idx 0 >= vcnt 0
> > 
> > mkfs process gets stuck in D state and I see the following in the dmesg:
> > 
> > [  257.789733] __end_that: dev mmcblk0: type=1, flags=122c8081
> > [  257.789764]   sector 4194304, nr/cnr 2981888/4294959104
> > [  257.789764]   bio df3840c0, biotail df3848c0, buffer   (null), len
> > 1526726656
> > [  257.789764] blk_update_request: bio idx 0 >= vcnt 0
> > [  257.794921] request botched: dev mmcblk0: type=1, flags=122c8081
> > [  257.794921]   sector 4194304, nr/cnr 2981888/4294959104
> > [  257.794921]   bio df3840c0, biotail df3848c0, buffer   (null), len
> > 1526726656
> > 
> > This patch fixes this issue.
> > 
> > Reported-by: Max Filippov <jcmvbkbc@gmail.com>
> > Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> > Signed-off-by: James Bottomley <JBottomley@Parallels.com>
> > Tested-by: Max Filippov <jcmvbkbc@gmail.com>
> > Cc: <stable@vger.kernel.org>
> 
> Thanks! One minor nit - I don't think James signed off on the patch when
> he sent it in. James?

I didn't, but silence is really acquiescence in this game. However, now
you have my positive confirmation that I'm good with the signoff.

James


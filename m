Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538Ab3C0OFE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 10:05:04 -0400
Received: from server506f.appriver.com ([50.56.144.36]:55036 "EHLO
	server506.appriver.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752033Ab3C0OFC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 10:05:02 -0400
X-Note-AR-ScanTimeLocal: 3/27/2013 9:05:01 AM
X-Policy: GLOBAL - coraid.com
X-Policy: GLOBAL - coraid.com
X-Policy: GLOBAL - coraid.com
X-Primary: ecashin@coraid.com
X-Note: This Email was scanned by AppRiver SecureTide
X-ALLOW: @coraid.com ALLOWED
X-Virus-Scan: V-
X-Note: Spam Tests Failed: 
X-Country-Path: UNKNOWN->PRIVATE->UNITED STATES
X-Note-Sending-IP: 10.242.229.139
X-Note-Reverse-DNS: 
X-Note-Return-Path: ecashin@coraid.com
X-Note: User Rule Hits: 
X-Note: Global Rule Hits: G328 G329 G330 G331 G335 G336 G347 G443 
X-Note: Encrypt Rule Hits: 
X-Note: Mail Class: ALLOWEDSENDER
X-Note: Headers Injected
From: Ed Cashin <ecashin@coraid.com>
To: Chen Gang <gang.chen@asianux.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [Suggestion] drivers/block/aoe: using uninitialized variable.
Thread-Topic: [Suggestion] drivers/block/aoe: using uninitialized variable.
Thread-Index: AQHOKrq/+51OPSjrp0muP43GcxZuEZi55n0A
Date: Wed, 27 Mar 2013 14:04:58 +0000
Message-ID: <D32F8009-1A9F-43C5-9A0B-2849FB06AE87@coraid.com>
References: <51529C39.7050207@asianux.com>
In-Reply-To: <51529C39.7050207@asianux.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [50.56.144.246]
x-rerouted-by-exchange: 
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <9B025FC57D392B40B67B2B1907E6BD3C@fwd6.exghost.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks.  Jens Axboe said about it to Dan Carpenter that ...

> It was fixed up yesterday, it was a merge error in the for-next branch.

On Mar 27, 2013, at 3:14 AM, Chen Gang wrote:

> Hello Ed L. Cashin
> 
>  when compiling with EXTRA_CFLAGS=-W
> 
>  get the warning:
>    drivers/block/aoe/aoecmd.c:931:20: warning: ‘bv’ is used uninitialized in this function [-Wuninitialized]
> 
>  bv is really not initialized.
>    (and it seems only set "buf->bv_resid = 0" is not enough).
> 
>  thanks.
> 
> gchen.
> 
> 919 static void
> 920 bufinit(struct buf *buf, struct request *rq, struct bio *bio)
> 921 {
> 922         struct bio_vec *bv;
> 923 
> 924         memset(buf, 0, sizeof(*buf));
> 925         buf->rq = rq;
> 926         buf->bio = bio;
> 927         buf->resid = bio->bi_size;
> 928         buf->sector = bio->bi_sector;
> 929         bio_pageinc(bio);
> 930         buf->bv = bio_iovec(bio);
> 931         buf->bv_resid = bv->bv_len;
> 932         WARN_ON(buf->bv_resid == 0);
> 933 }
> 
> 

-- 
  Ed Cashin
  ecashin@coraid.com



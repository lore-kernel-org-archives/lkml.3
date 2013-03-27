Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004Ab3C0HOd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 03:14:33 -0400
Received: from intranet.asianux.com ([58.214.24.6]:14234 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755659Ab3C0HOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 03:14:32 -0400
X-Spam-Score: -100.8
Message-ID: <51529C39.7050207@asianux.com>
Date: Wed, 27 Mar 2013 15:14:01 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: ecashin@coraid.com
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [Suggestion] drivers/block/aoe: using uninitialized variable.
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ed L. Cashin

  when compiling with EXTRA_CFLAGS=-W

  get the warning:
    drivers/block/aoe/aoecmd.c:931:20: warning: ‘bv’ is used uninitialized in this function [-Wuninitialized]

  bv is really not initialized.
    (and it seems only set "buf->bv_resid = 0" is not enough).

  thanks.

gchen.

 919 static void
 920 bufinit(struct buf *buf, struct request *rq, struct bio *bio)
 921 {
 922         struct bio_vec *bv;
 923 
 924         memset(buf, 0, sizeof(*buf));
 925         buf->rq = rq;
 926         buf->bio = bio;
 927         buf->resid = bio->bi_size;
 928         buf->sector = bio->bi_sector;
 929         bio_pageinc(bio);
 930         buf->bv = bio_iovec(bio);
 931         buf->bv_resid = bv->bv_len;
 932         WARN_ON(buf->bv_resid == 0);
 933 }



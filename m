Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751367AbaHUFow (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 01:44:52 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:33118 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbaHUFov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 01:44:51 -0400
MIME-Version: 1.0
In-Reply-To: <53F3B89D.6070703@kernel.dk>
References: <1408031441-31156-1-git-send-email-ming.lei@canonical.com>
	<1408031441-31156-6-git-send-email-ming.lei@canonical.com>
	<20140815163111.GA16652@infradead.org>
	<53EE370D.1060106@kernel.dk>
	<53EE3966.60609@kernel.dk>
	<CACVXFVO+3SHy0=zESJqG3ZB68AZaeK5_QK2CVmZWzZ7oBWDGwg@mail.gmail.com>
	<53F0EAEC.9040505@kernel.dk>
	<CACVXFVO3CrD2CoHiBOZ8GNMXrT2pJ=t2BzmAHksqRTmgrpsaaQ@mail.gmail.com>
	<CACVXFVN6W-AAQ6g4LXHOyvMzU+EAmj_YYBEuYRnoSB+VqCJg8A@mail.gmail.com>
	<53F3B89D.6070703@kernel.dk>
Date: Thu, 21 Aug 2014 13:44:48 +0800
Message-ID: <CACVXFVOR0mzMWo+iPtU8jUvYgH+non=hQ0XaP0Z1Fu0qiSbJNA@mail.gmail.com>
Subject: Re: [PATCH v1 5/9] block: loop: convert to blk-mq
From: Ming Lei <ming.lei@canonical.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Kleikamp <dave.kleikamp@oracle.com>, Zach Brown <zab@zabbo.net>,
        Benjamin LaHaise <bcrl@kvack.org>, Kent Overstreet <kmo@daterainc.com>,
        "open list:AIO <linux-aio@kvack.org>, Linux FS Devel
	<linux-fsdevel@vger.kernel.org>, Dave Chinner" <david@fromorbit.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2014 at 4:50 AM, Jens Axboe <axboe@kernel.dk> wrote:

>
>
> Reworked a bit more:
>
> http://git.kernel.dk/?p=linux-block.git;a=commit;h=a323185a761b9a54dc340d383695b4205ea258b6

One big problem of the commit is that it is basically a serialized workqueue
because of single &hctx->run_work, and per-req work_struct has to be
used for concurrent implementation.  So looks the approach isn't flexible
enough compared with doing that in driver, or any idea about how to fix
that?


Thanks

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862AbaDSDRZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 23:17:25 -0400
Received: from mail-ve0-f182.google.com ([209.85.128.182]:49599 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550AbaDSDRW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 23:17:22 -0400
MIME-Version: 1.0
In-Reply-To: <53517BC5.7090002@web.de>
References: <1397749778-14485-1-git-send-email-tom.leiming@gmail.com>
	<1397749778-14485-4-git-send-email-tom.leiming@gmail.com>
	<5350257A.30107@web.de>
	<CACVXFVMFuiHpM-bVjyutP7fH621Gt0bo2+HLwRbk_aGsiZ+1Vw@mail.gmail.com>
	<53517BC5.7090002@web.de>
Date: Sat, 19 Apr 2014 11:17:21 +0800
Message-ID: <CACVXFVMZ0LmpkYk5+-4yyosapzUp+te4txFq3iO09PpGKEXWRA@mail.gmail.com>
Subject: Re: [PATCH next 3/4] blk-mq: user (1 << order) to implement order_to_size()
From: Ming Lei <tom.leiming@gmail.com>
To: =?UTF-8?B?SsO2cmctVm9sa2VyIFBlZXR6?= <jvpeetz@web.de>
Cc: Jens Axboe <axboe@kernel.dk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 19, 2014 at 3:23 AM, Jörg-Volker Peetz <jvpeetz@web.de> wrote:
>
> Testing this with gcc 4.8.2 with order > 30 confirms that the automatic casting
> is done operator-wise and the explicit casting is necessary.

My gcc 4.8.2 doesn't complain the change, see below:

ming@ming:~/ming/linux$ gcc --version
gcc (Ubuntu/Linaro 4.8.2-19ubuntu1) 4.8.2

ming@ming:~/ming/linux$
ming@ming:~/ming/linux$ vim block/blk-mq.c
ming@ming:~/ming/linux$ ./build
  CHK     include/config/kernel.release
  CHK     include/generated/uapi/linux/version.h
  CHK     include/generated/utsrelease.h
  CALL    scripts/checksyscalls.sh
  CHK     include/generated/compile.h
  CC      block/blk-mq.o
  CHK     kernel/config_data.h
  LD      block/built-in.o
  LINK    vmlinux
  LD      vmlinux.o
  MODPOST vmlinux.o



Thanks,
-- 
Ming Lei

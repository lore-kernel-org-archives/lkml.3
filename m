Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751617AbbAAACI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 19:02:08 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:46704 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548AbbAAABz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 19:01:55 -0500
MIME-Version: 1.0
In-Reply-To: <CA+icZUU=FPioz0SbMA+GYTcsz41ADfE1oCq5zFB3SGrvZyCc6A@mail.gmail.com>
References: <CA+icZUXCCopMw4ZUyUYPT0seMVT4W0GuNhn3Z5Erte+LMhxzkQ@mail.gmail.com>
	<CA+icZUXcpmFhCJ0=eiVe=XMbVFRCSLxUpaNNh2E7vEStMwjg=A@mail.gmail.com>
	<CA+icZUU=FPioz0SbMA+GYTcsz41ADfE1oCq5zFB3SGrvZyCc6A@mail.gmail.com>
Date: Thu, 1 Jan 2015 08:01:54 +0800
Message-ID: <CACVXFVMR=-CGq=EWWCorD-DBge=stygvrgY1kuR7rBh_96mA=A@mail.gmail.com>
Subject: Re: [PATCH v3 0/5] block: loop: convert to blk-mq
From: Ming Lei <tom.leiming@gmail.com>
To: sedat.dilek@gmail.com
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sedat,

On Thu, Jan 1, 2015 at 6:32 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> Forgot to CC LKML and linux-fsdevel.
>
> - Sedat -

>
> OK, I have installed fio (1.59-1) and libaio1 (0.3.109-2ubuntu1) here.
>
> You say in [1]:
>
> "In the following test:
> - base: v3.19-rc2-2041231
> - loop over file in ext4 file system on SSD disk
> - bs: 4k, libaio, io depth: 64, O_DIRECT, num of jobs: 1
> - throughput: IOPS"
>
> I tried to reproduce that inspired by [2]...
>
> root# fio --name=randread --rw=randread --bs=4k --ioengine=libaio
> --iodepth=64 --direct=1 --numjobs=1 --size=1G
>
> ...you had no size given (here: 1GiB) - fio requires that parameter to run.
>
> This results in 165 VS. 515 IOPS here.

Thanks for your test.

Also if your disk is quick enough, you will observe improvement on
read test too.

> # grep "iops=" test-*
> test-1-next20141231.txt:  read : io=1024.0MB, bw=678578 B/s, iops=165
> , runt=1582340msec
> test-2-next20141231-block-mq-v3.txt:  read : io=1024.0MB,
> bw=2063.4KB/s, iops=515 , runt=508182msec
>
> Full fio-logs and some other useful configs/logs/patches attached.
>
> - Sedat -
>
> [1] http://marc.info/?l=linux-kernel&m=142003220301459&w=2
> [2] http://wiki.mikejung.biz/Benchmarking#Fio_Random_Write_Test_using_libaio_and_direct_flags



Thanks,
Ming Lei

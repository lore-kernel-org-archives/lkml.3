Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750954AbaFIEfx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 00:35:53 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:56380 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbaFIEfu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 00:35:50 -0400
MIME-Version: 1.0
In-Reply-To: <1402057225-7312-2-git-send-email-m@bjorling.me>
References: <1402057225-7312-1-git-send-email-m@bjorling.me>
	<1402057225-7312-2-git-send-email-m@bjorling.me>
Date: Mon, 9 Jun 2014 12:35:48 +0800
Message-ID: <CACVXFVOieM2cT4FFJhD9MecfCLBtE3AwjCpOeGGRUcmWnN=B=A@mail.gmail.com>
Subject: Re: [PATCH v6] NVMe: conversion to blk-mq
From: Ming Lei <tom.leiming@gmail.com>
To: =?UTF-8?Q?Matias_Bj=C3=B8rling?= <m@bjorling.me>
Cc: willy@linux.intel.com, keith.busch@intel.com, sbradshaw@micron.com,
        axboe@fb.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-nvme@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 6, 2014 at 8:20 PM, Matias Bjørling <m@bjorling.me> wrote:
> This converts the current NVMe driver to utilize the blk-mq layer.

Looks it can't be applied cleanly against 3.15-rc8 + Jens's for-linux
branch, when I fix the conflict manually, below failure is triggered:

[  487.696057] nvme 0000:00:07.0: Cancelling I/O 202 QID 1
[  487.699005] nvme 0000:00:07.0: Aborting I/O 202 QID 1
[  487.704074] nvme 0000:00:07.0: Cancelling I/O 202 QID 1
[  487.717881] nvme 0000:00:07.0: Aborting I/O 202 QID 1
[  487.736093] end_request: I/O error, dev nvme0n1, sector 91532352
[  487.747378] nvme 0000:00:07.0: completed id 0 twice on queue 0


when running fio randread(libaio, iodepth:64) with more than 3 jobs.

And looks no such failure when jobs is 1 or 2.

Thanks,
--
Ming Lei

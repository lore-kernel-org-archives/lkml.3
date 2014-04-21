Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651AbaDUU67 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 16:58:59 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:33769 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754502AbaDUU6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 16:58:54 -0400
MIME-Version: 1.0
Date: Mon, 21 Apr 2014 22:58:53 +0200
Message-ID: <CAHuzUScfp19c_th_pfsZs05+yDz34MuEH-P1f+FF1dcivfH=5Q@mail.gmail.com>
Subject: rm -f * on large files very slow on XFS + MD RAID 6 volume of 15x 4TB
 of HDDs (52TB)
From: Speedy Milan <speedy.milan@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ivan Pantovic <gyro.ivan@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I want to report very slow deletion of 24 50GB files (in total 12 TB),
all present in the same folder.

OS is CentOS 6.4, with upgraded kernel 3.13.1.

The hardware is a Supermicro server with 15x 4TB WD Se drives in MD
RAID 6, totalling 52TB of free space.

XFS is formated directly on the RAID volume, without LVM layers.

Deletion was done with rm -f * command, and it took upwards of 1 hour
to delete the files.

File system was filled completely prior to deletion.

rm was mostly waiting (D state), probably for kworker threads, and
iostat was showing big HDD utilization numbers and very low throughput
so it looked like a random HDD workload was in effect.

rm was the only IO task at the moment.

I found it strange that deleting large files should take such a long
time, so I thought it would be wise to report.

Thanks,
Milan

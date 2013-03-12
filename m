Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933161Ab3CLRtM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 13:49:12 -0400
Received: from mout.web.de ([212.227.17.11]:62026 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932454Ab3CLRtL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 13:49:11 -0400
From: Markus <M4rkusXXL@web.de>
To: lkml <linux-kernel@vger.kernel.org>
Subject: hybrid raid1 with trim support
Date: Tue, 12 Mar 2013 18:49:03 +0100
Message-ID: <3387108.NX1Tlx8b5x@f209>
User-Agent: KMail/4.9.5 (Linux/3.8.2-gentoo; KDE/4.9.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:9eYNkHnCioQ+Kau8bLFSQMrZDSYbUv4TrGU5xZQ2lrO
 XjmaNy50q5vJ5UOVYTb1MTDyXpO1CD1NgdZ9/8guDr6KH4T0pO
 w9p0P5p2OVoLeEhuuE2FYYg5Jhyoop0jR42jiK47zbQCGxE4cd
 1eEnkqZL3YZHO9Ro0qfVE7CaZi7I5Bkt8TeoIziUVn6r50oyo4
 2yrBPj2riYAPCTtabevKQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

I created a hybrid raid1 with one ssd and one hdd. Used writemostly and writebehind and put ext4 with discard enabled on it.
This setup worked quite well for the last months (last kernel was 3.7.6). But now as I booted 3.8.2 the hdd was dropped from the raid with:
> md/raid1:md2: Disk failure on sdb1, disabling device.
> md/raid1:md2: Operation continuing on 1 devices.

Re-adding this drive it will try to resync but the hdd will be dropped short time after. Now I remounted the device without the discard flag and the resync and usage works as before.
After remounting it again with discard enabled the hdd is dropped again. So I think this is the culprit as the hdd does obviously not support TRIM...

As it worked fine before, I think this is a regression? Or is this an intended change?


Thanks,
Markus

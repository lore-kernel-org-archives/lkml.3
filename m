Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197Ab3CXJWa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 05:22:30 -0400
Received: from mout.web.de ([212.227.15.4]:61532 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752668Ab3CXJW2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 05:22:28 -0400
From: Markus <M4rkusXXL@web.de>
To: lkml <linux-kernel@vger.kernel.org>
Subject: Re: hybrid raid1 with trim support
Date: Sun, 24 Mar 2013 10:21:05 +0100
Message-ID: <3642314.Bs77jRSGfY@f209>
User-Agent: KMail/4.9.5 (Linux/3.8.4-gentoo; KDE/4.9.5; x86_64; ; )
In-Reply-To: <3387108.NX1Tlx8b5x@f209>
References: <3387108.NX1Tlx8b5x@f209>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:eIwXgkyBEQHkw8wlptwFH+ZL1POoaTyrj98oDFhBxH9
 SzeMVWHijsdVg88LD0MQYEJxbYen0f5xIDVIau39Rx6u+AICQ7
 JhU8IWWxhCaVUNcctfC2ucIFGfZC6IpDqoBP6+i8uLtmiDhQpq
 wFz4uLha/14oXtlB0dll0pOjk8G+vlq4iyEai8OkWYrONVGaaS
 xWYwyb0LfgjaF5pqhEuZw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Still the same with 3.8.4 ... anybody?

Best regards,
Markus

Markus schrieb am 12.03.2013:
> Hello!
> 
> I created a hybrid raid1 with one ssd and one hdd. Used writemostly and writebehind and put ext4 with discard enabled on it.
> This setup worked quite well for the last months (last kernel was 3.7.6). But now as I booted 3.8.2 the hdd was dropped from the raid with:
> > md/raid1:md2: Disk failure on sdb1, disabling device.
> > md/raid1:md2: Operation continuing on 1 devices.
> 
> Re-adding this drive it will try to resync but the hdd will be dropped short time after. Now I remounted the device without the discard flag and the resync and usage works as before.
> After remounting it again with discard enabled the hdd is dropped again. So I think this is the culprit as the hdd does obviously not support TRIM...
> 
> As it worked fine before, I think this is a regression? Or is this an intended change?
> 
> 
> Thanks,
> Markus

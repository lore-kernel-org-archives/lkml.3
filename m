Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051Ab3D0Q3z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Apr 2013 12:29:55 -0400
Received: from mout.web.de ([212.227.15.3]:49983 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753513Ab3D0Q3x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Apr 2013 12:29:53 -0400
From: Markus <M4rkusXXL@web.de>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@kernel.dk>
Subject: Re: hybrid raid1 with trim support [REGRESSION]
Date: Sat, 27 Apr 2013 18:29:49 +0200
Message-ID: <1533550.VmvE7tiNM7@f209>
User-Agent: KMail/4.10.1 (Linux/3.8.10-gentoo; KDE/4.10.1; x86_64; ; )
In-Reply-To: <3642314.Bs77jRSGfY@f209>
References: <3387108.NX1Tlx8b5x@f209> <3642314.Bs77jRSGfY@f209>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:igTibQso1JbU/W5at58NAmBp5z6vTiL+VWnKXNI+M6i
 M6L8cVYyZU+m8uiyjA2OC0v6V14PR6QfHSPtEx14EJyR3Rurah
 oIrmj0o0pUMHdsMJlOBEddD+YYhe5djhSQ8cWa/DCeWgFFI7v1
 30r2Bws23EDyGd1guL/rQg6b+XbmwWZFOoIgSzKD+yJv6+cyU6
 Il7iVZciOcd+E07HtKKOw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Now I had the time to bisect, started with 3.7 as good and 3.8 as bad.
0cfbcafcae8b7364b5fa96c2b26ccde7a3a296a9 is the bad commit. [1]
block: add plug for blkdev_issue_discard

While 3.8.10 was still bad, the same kernel with the reverted patch applied is fine.


I found another report. [2]


Thanks,
Markus

[1] https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=0cfbcafcae8b7364b5fa96c2b26ccde7a3a296a9
[2] http://www.spinics.net/lists/raid/msg42758.html

Markus schrieb am 24.03.2013:
> Hi!
> 
> Still the same with 3.8.4 ... anybody?
> 
> Best regards,
> Markus
> 
> Markus schrieb am 12.03.2013:
> > Hello!
> > 
> > I created a hybrid raid1 with one ssd and one hdd. Used writemostly and writebehind and put ext4 with discard enabled on it.
> > This setup worked quite well for the last months (last kernel was 3.7.6). But now as I booted 3.8.2 the hdd was dropped from the raid with:
> > > md/raid1:md2: Disk failure on sdb1, disabling device.
> > > md/raid1:md2: Operation continuing on 1 devices.
> > 
> > Re-adding this drive it will try to resync but the hdd will be dropped short time after. Now I remounted the device without the discard flag and the resync and usage works as before.
> > After remounting it again with discard enabled the hdd is dropped again. So I think this is the culprit as the hdd does obviously not support TRIM...
> > 
> > As it worked fine before, I think this is a regression? Or is this an intended change?
> > 
> > 
> > Thanks,
> > Markus

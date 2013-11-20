Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752328Ab3KTMTe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 07:19:34 -0500
Received: from mail-ph.de-nserver.de ([85.158.179.214]:43835 "EHLO
	mail-ph.de-nserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353Ab3KTMTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 07:19:30 -0500
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Nov 2013 07:19:30 EST
X-Fcrdns: No
Message-ID: <528CA73B.9070604@profihost.ag>
Date: Wed, 20 Nov 2013 13:12:43 +0100
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: linux-fsdevel@vger.kernel.org
CC: viro@zeniv.linux.org.uk, LKML <linux-kernel@vger.kernel.org>,
        matthew@wil.cx
Subject: Why is O_DSYNC on linux so slow / what's wrong with my SSD?
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-User-Auth: Auth by hostmaster@profihost.com through 85.158.179.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

while struggling about an application beeing so slow on my SSD and
having high I/O Waits while the app is using the raw block device i've
detected that this is caused by open the block device with O_DSYNC.

I've used dd and fio with oflags=direct,dsync / --direct=1 and --sync=1

and got these "strange" results:

fio --sync=1:
WRITE: io=1694.0MB, aggrb=57806KB/s, minb=57806KB/s, maxb=57806KB/s,
mint=30008msec, maxt=30008msec

fio --sync=0:
WRITE: io=5978.0MB, aggrb=204021KB/s, minb=204021KB/s, maxb=204021KB/s,
mint=30004msec, maxt=30004msec

I get the same results on a crucial m4 as on my intel 530 ssd.

I also tried the same under FreeBSD 9.1 which shows around the same
results for sync=0 as sync=1:

sync=0:
WRITE: io=5984.0MB, aggrb=204185KB/s, minb=204185KB/s, maxb=204185KB/s,
mint=30010msec, maxt=30010msec

sync=1:
WRITE: io=5843.0MB, aggrb=199414KB/s, minb=199414KB/s, maxb=199414KB/s,
mint=30004msec, maxt=30004msec

Can anyone explain to me why O_DSYNC for my app on linux is so slow?

used kernel is vanilla 3.10.19

Thanks!


Greets Stefan

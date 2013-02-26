Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759979Ab3BZVIs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 16:08:48 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:10275 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759958Ab3BZVIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 16:08:44 -0500
X-AuditID: cbfee68e-b7fa46d00000627e-4f-512d245b698b
Date: Tue, 26 Feb 2013 21:08:43 +0000 (GMT)
From: =?euc-kr?B?vNvAurrA?= <eunb.song@samsung.com>
Subject: I2C: Fix i2c fail problem when a process is terminated by a signal on
 octeon in 3.8
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
Reply-to: eunb.song@samsung.com
MIME-version: 1.0
X-MTR: 20130226210722347@eunb.song
Msgkey: 20130226210722347@eunb.song
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20130226210722347@eunb.song
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <16202598.147281361912922998.JavaMail.weblogic@epml02>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjleLIzCtJLcpLzFFi42I5/e+Zlm60im6gwfXfXBaXd81hc2D0+LxJ
	LoAxissmJTUnsyy1SN8ugSvj0q5uxoJD3BWvFixna2Ccwd3FyMkhJKAi0fL/OyOILSFgIrHt
	cTc7hC0mceHeerYuRi6gmmWMErO/NDJ3MXKAFV34HQsRn88oMXPbKTaQBhYBVYllS7+zgNhs
	QDUbfkxgB6kXFoiROLlNECQsIlAj0fptKiPEXnmJyacvg+3iFRCUODnzCQvEXiWJ1l8zWSDi
	yhIXP2+DiktIzJp+gRXC5pWY0f4UKi4nMe3rGmYIW1ri/KwNjDD3L/7+GCrOL3Hs9g4miPN5
	JZ7cD4YZs3vzFzYIW0Bi6pmDUK3qEsvaN0O18kmsWfiWBWbMrlPLmWF672+ZywRiMwsoSkzp
	fsgOYWtJfPmxjw3dW7wCThIL33xgBAWbhMBUDomPJzazT2BUmoWkbhaSWbOQzEJWs4CRZRWj
	aGpBckFxUnqRkV5xYm5xaV66XnJ+7iZGSFro28F484D1IcZkYJRMZJYSTc4HppW8knhDYwNj
	Q0NLQzNTS1MD0oSVxHnlL8kECgmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamBcvfucYOK/WWrG
	31mnvk7kWvPnpm72FIvQhn5564N7Pv38ktmb9fjIvOk/OZk4306a6uMsr33lxpvYIyuN41+9
	PWcb4L5Mee6shaKz99hMfOCdrLxr4u847iqbhljBQ8nHjrbY5d5rbBAKMJh44/fqZT6P39lu
	2h2wYIdPzLrkz7OzN9zSY/NcosRSnJFoqMVcVJwIAG5aGVghAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCKsWRmVeSWpSXmKPExsVy+t/t6brRKrqBBnPPs1pc3jWHzYHR4/Mm
	uQDGqAybjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCh
	SgpliTmlQKGAxOJiJX07m6L80pJUhYz84hJbpWgjA2M9I1MTPSNjAz0Tg1grQwMDI1OgqoSM
	jEu7uhkLDnFXvFqwnK2BcQZ3FyMnh5CAikTL/++MXYwcHBICJhIXfseChCUExCQu3FvP1sXI
	BVQyn1Fi5rZTbCAJFgFViWVLv7OA2GxA9Rt+TGAH6RUWiJE4uU0QJCwiUCPR+m0qI8R4eYnJ
	py+zg9i8AoISJ2c+YYGYryTR+msmC0RcWeLi521QcQmJWdMvsELYvBIz2p9CxeUkpn1dwwxh
	S0ucn7WBEebOxd8fQ8X5JY7d3sEE8QqvxJP7wTBjdm/+wgZhC0hMPXMQqlVdYln7ZqhWPok1
	C9+ywIzZdWo5M0zv/S1zmUBsZgFFiSndD9khbC2JLz/2saF7i1fASWLhmw+MExhlZyFJzULS
	PgtJO7KaBYwsqxhFUwuSC4qT0itM9IoTc4tL89L1kvNzNzGC09CzJTsYGy5YH2IU4GBU4uFd
	cEknUIg1say4MvcQowQHs5II78cDQCHelMTKqtSi/Pii0pzU4kOMycA4m8gsJZqcD0yReSXx
	hsYGxoaGluYGpoZGFqQJK4nzHrJRDxQSSE8sSc1OTS1ILYLZwsTBKdXAaCidWyKveunEqR2f
	ykIM2+rY3vlU/WHO+HOpb69CLtOdCQ9nhdycyCA8bc5Vz30vvLpsb8eV5L4PN3TeK3H6hJ3O
	t3tS52qiMg9tlmOWSJhZcvnFQ8eaY+yXwsNjErfPOv2p2dlZvKPbu/3Q2fVXWeV/u2xbm3VA
	vmjV+rO7l4V+OO5yYj8PoxJLcUaioRZzUXEiAKYMpo+HAwAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r1QL8rVI000708


I've been debugging the abnormal operation of i2c on octeon. 
If a process is terminated by signal in the middle of i2c operation, 
next i2c read operation which is done by another process was failed.
So i changed to ignore signal in the middle of i2c operation. 
After that the problem was not reproduced.

 

Signed-off-by: EunBong Song <eunb.song@samsung.com>

diff -up drivers/i2c/busses/i2c-octeon.c{.orig,}
--- drivers/i2c/busses/i2c-octeon.c.orig 2013-02-21 08:09:03.168018843 -0800
+++ drivers/i2c/busses/i2c-octeon.c 2013-02-21 08:09:38.344018898 -0800
@@ -183,7 +183,7 @@ static irqreturn_t octeon_i2c_isr(int ir
  struct octeon_i2c *i2c = dev_id;
 
  octeon_i2c_int_disable(i2c);
- wake_up_interruptible(&i2c->queue);
+ wake_up(&i2c->queue);
 
  return IRQ_HANDLED;
 }
@@ -206,7 +206,7 @@ static int octeon_i2c_wait(struct octeon
 
  octeon_i2c_int_enable(i2c);
 
- result = wait_event_interruptible_timeout(i2c->queue,
+ result = wait_event_timeout(i2c->queue,
         octeon_i2c_test_iflg(i2c),
         i2c->adap.timeout);

ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•

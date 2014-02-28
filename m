Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725AbaB1PJP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 10:09:15 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:23435 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898AbaB1PJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 10:09:13 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-ef-5310a6978a8a
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: linux-security-module@vger.kernel.org, zohar@linux.vnet.ibm.com
Cc: jmorris@namei.org, linux-kernel@vger.kernel.org, casey.schaufler@intel.com,
        dmitry.kasatkin@gmail.com, Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [RFC 0/2] integrity: asynchronous hash support
Date: Fri, 28 Feb 2014 17:07:08 +0200
Message-id: <cover.1393599653.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.8.3.2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEJMWRmVeSWpSXmKPExsVy+t/xy7rTlwkEG3z4rWlxY8UCJotbf/cy
	W3xZWmexbv1iJovLu+awWXzoecRm8WnFJGYHdo+ds+6yeyze85LJ48GhzSwePd+TPfq2rGL0
	+LxJLoAtissmJTUnsyy1SN8ugStj6pGn7AWL2CuuP3zL3MD4j7WLkZNDQsBEYtaVu4wQtpjE
	hXvr2boYuTiEBJYyStxachfK6WSSODp5LTtIFZuAnsSG5h9gtoiAs8SiW+2sIEXMAlMZJV7d
	msYCkhAWMJe4uv0YWBGLgKpE965ONhCbV8BS4tv2Lqh1ChLLvqxlnsDIvYCRYRWjaGppckFx
	UnquoV5xYm5xaV66XnJ+7iZGSLh82cG4+JjVIUYBDkYlHl6JRQLBQqyJZcWVuYcYJTiYlUR4
	Ly0GCvGmJFZWpRblxxeV5qQWH2Jk4uCUamAM+LZJarmpO/e0e+HcH85tY9IqttmvKTtpzdmw
	oGMnLTSXalaprK3VTJHOs5U5vFPeUlJs/TFufl2TlT9erky89HjK39C+k1NaiqTWfZq+j/HJ
	2V/3Pxrn1Dl5CYVNf8F7KGYbC89uL+ULzH0MNe8e+9+Ks6pSsHB4+/CQ3OnAfff79QKal/kq
	sRRnJBpqMRcVJwIAfS/OwfUBAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HW accelerated hash calculation is available only via ahash API.

First patch introduces usage of ahash API for file hash calculation.
It allows to offload hash calculation to HW accelerator and release CPU
time to do other usefull job. It might speedup hash calculation but also
reduce power consumption on battery powered devices.

'ima_use_ahash' kernel parameter allows to select between synchronous
and asynchronous hash calculation methods. It allows to measure performance
differences between methods.

Second patch introduces usage of double buffering what allows perform
file IO simulteneously with hash calculation.

- Dmitry

Dmitry Kasatkin (2):
  ima: use ahash API for file hash calculation
  ima: provide double buffering for hash calculation

 security/integrity/ima/ima_crypto.c | 269 +++++++++++++++++++++++++++++++++++-
 1 file changed, 266 insertions(+), 3 deletions(-)

-- 
1.8.3.2


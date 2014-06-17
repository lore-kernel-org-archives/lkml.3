Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932443AbaFQI5t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 04:57:49 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:32433 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753641AbaFQI5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 04:57:46 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-0e-53a00307e690
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, dhowells@redhat.com, jwboyer@redhat.com,
        keyrings@linux-nfs.org, linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH v2 0/3] KEYS: validate certificate trust with selected owner or
 builtin key
Date: Tue, 17 Jun 2014 11:56:56 +0300
Message-id: <cover.1402994752.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPJMWRmVeSWpSXmKPExsVy+t/xy7rszAuCDS49ULa49Xcvs8W7pt8s
	FgfePWGxmL3rIYvF5V1z2Cw+9Dxis/i0YhKzA7vHtBPLWDweHNrM4vF+31U2j74tqxg9Pm+S
	C2CN4rJJSc3JLEst0rdL4Mo4d+owW8FNjooZbz8yNzC+YOti5OSQEDCRWH9yEjuELSZx4d56
	oDgXh5DAUkaJjTO3skM4nUwS7+f8AqtiE9CT2ND8AywhItDGKNG29RnYKGYBL4mTf7+BFQkL
	xEr8fTydEcRmEVCVuL9mKyuIzStgKXHjZSMTxDo5iZPHJrNOYORewMiwilE0tTS5oDgpPddQ
	rzgxt7g0L10vOT93EyMkUL7sYFx8zOoQowAHoxIPb8Sl+cFCrIllxZW5hxglOJiVRHiFXgGF
	eFMSK6tSi/Lji0pzUosPMTJxcEo1MK7yibqkY73unxhbY654/LUVRefyLWdbLNuRdHzO2gaX
	2IqSQuuzurx+v0X7pv7O3CT4IJef9W3ZVT3HV9JL3ue9mF1m5s51InAe64/Xabwa1VrmPWxX
	3zC+Se2p2XSz3/9aoDt7wiTb+cuY3jS7RF6SmbT03wP37+bH9pdriYWu/BC81evaeSWW4oxE
	Qy3mouJEABcrHr3yAQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of allowing public keys, with certificates signed by any key on
the system trusted keyring, to be added to a trusted keyring, this patch
set further restricts the certificates to those signed by a particular key
or builtin keys on the system keyring.

This patch defines a new kernel parameter 'keys_ownerid={id: | builtin}'
to use specific key or any builtin key.

Changes to v1:
* key id matching code from asymmetric_type.c is reused in the patch

Thanks,
Dmitry


Dmitry Kasatkin (3):
  KEYS: make key id matching as a dedicated function
  KEYS: validate certificate trust only with selected owner key
  KEYS: validate certificate trust only with builtin keys

 Documentation/kernel-parameters.txt      |  5 ++++
 crypto/asymmetric_keys/asymmetric_keys.h |  2 ++
 crypto/asymmetric_keys/asymmetric_type.c | 50 ++++++++++++++++++++------------
 crypto/asymmetric_keys/x509_public_key.c | 26 +++++++++++++++--
 include/linux/key.h                      |  1 +
 kernel/system_keyring.c                  |  1 +
 6 files changed, 64 insertions(+), 21 deletions(-)

-- 
1.9.1


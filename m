Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964989AbaESRjE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 13:39:04 -0400
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:40935 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932670AbaESRi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 13:38:58 -0400
Date: Mon, 19 May 2014 19:38:51 +0200 (CEST)
From: Sebastian Ott <sebott@linux.vnet.ibm.com>
X-X-Sender: sebott@denkbrett
To: Anatol Pomozov <anatol.pomozov@gmail.com>,
        Benjamin LaHaise <bcrl@kvack.org>
cc: linux-aio@kvack.org, linux-kernel@vger.kernel.org
Subject: hanging aio process
Message-ID: <alpine.LFD.2.11.1405191908450.1847@denkbrett>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
Organization: =?ISO-8859-15?Q?=22IBM_Deutschland_Research_&_Development_GmbH_=2F_Vorsitzende_des_Aufsichtsrats=3A_Martina_Koederitz_Gesch=E4ftsf=FChrung=3A_Dirk_Wittkopp_Sitz_der_Gesellschaft=3A_B=F6blingen_=2F_Registergericht?=
 =?ISO-8859-15?Q?=3A_Amtsgericht_Stuttgart=2C_HRB_243294=22?=
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463784958-477581573-1400521132=:1847"
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14051917-8372-0000-0000-000009BD5612
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463784958-477581573-1400521132=:1847
Content-Type: TEXT/PLAIN; charset=US-ASCII

Hello,

on the latest kernel a fio job with 4 workers using libaio hangs.

git bisect points to:
	commit e02ba72aabfade4c9cd6e3263e9b57bf890ad25c
	Author: Anatol Pomozov <anatol.pomozov@gmail.com>
	Date:   Tue Apr 15 11:31:33 2014 -0700

	    aio: block io_destroy() until all context requests are completed


The fio workers are on the wait_for_completion in sys_io_destroy.

Regards,
Sebastian
---1463784958-477581573-1400521132=:1847
Content-Type: TEXT/PLAIN; charset=US-ASCII; name=fio.job
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.LFD.2.11.1405191938510.1847@denkbrett>
Content-Description: 
Content-Disposition: attachment; filename=fio.job

W2dsb2JhbF0NCmJsb2Nrc2l6ZT00Sw0Kc2l6ZT0yNTZNDQpydz1yYW5kcncN
CnZlcmlmeT1tZDUNCmlvZGVwdGg9MzINCmlvZW5naW5lPWxpYmFpbw0KZGly
ZWN0PTENCmVuZF9mc3luYz0xDQoNCltmaWxlMV0NCmZpbGVuYW1lPS9kZXYv
c2NtYQ0KDQpbZmlsZTJdDQpmaWxlbmFtZT0vZGV2L3NjbWJ3DQoNCltmaWxl
M10NCmZpbGVuYW1lPS9kZXYvc2NtYw0KDQpbZmlsZTRdDQpmaWxlbmFtZT0v
ZGV2L3NjbXgNCg==

---1463784958-477581573-1400521132=:1847--


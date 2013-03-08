Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933454Ab3CHKWi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 05:22:38 -0500
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:28450 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172Ab3CHKW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 05:22:26 -0500
From: "Perla, Sathya" <Sathya.Perla@Emulex.Com>
To: CAI Qian <caiqian@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC: Ivan Vecera <ivecera@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: RE: be2net failed to initialize regression
Thread-Topic: be2net failed to initialize regression
Thread-Index: AQHOG9w0zWEciruSLEiAyLWgoqK/JpiblY7g
Date: Fri, 8 Mar 2013 10:22:24 +0000
Message-ID: <CF9D1877D81D214CB0CA0669EFAE020C0F259965@CMEXMB1.ad.emulex.com>
References: <1306201826.11289096.1362733530172.JavaMail.root@redhat.com>
In-Reply-To: <1306201826.11289096.1362733530172.JavaMail.root@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [138.239.140.182]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r28AMcYi027999

> -----Original Message-----
> From: netdev-owner@vger.kernel.org [mailto:netdev-owner@vger.kernel.org]
> On Behalf Of CAI Qian
> 
> Emulex CNA card failed to initialize using 3.8 and the latest upstream kernel,
> 
> [   87.479859] be2net 0000:04:00.0: POST timeout; stage=0xc911
> [   87.515978] be2net 0000:04:00.0: Emulex OneConnect initialization failed
> [   87.557130] be2net: probe of 0000:04:00.0 failed with error -1
> 
> lspci output,
> 
> 04:00.0 Ethernet controller: Emulex Corporation OneConnect 10Gb NIC (rev 02)
> 04:00.1 Ethernet controller: Emulex Corporation OneConnect 10Gb NIC (rev 02)
> 
> 04:00.1 Ethernet controller: Emulex Corporation OneConnect 10Gb NIC (rev 02)
>         Subsystem: Hewlett-Packard Company NC551i Dual Port FlexFabric 10Gb
> Adapter
> 
> Confirmed no such problem using 3.7 kernel. Reproduced every time and still
> bisecting. Just want to give an early head-up to see if anyone saw sometime
> obvious.

Could you give me the FW version (ethtool -i) of the adapter (after be2net successfully
probes in a 3.7 kernel.)

If the FW version is as old as 2.x, then the culprit commit that broke compatibility with old FW versions
on some (BE2) chips I is:
commit 1bc8e7e4f36c0c19dd7dea29e7c248b7c6ef3a15
be2net: fix access to SEMAPHORE reg

The fix for this is (still on David's net tree I guess):
commit c5b3ad4c67989c778e4753be4f91dc7193a04d21
be2net: use CSR-BAR SEMAPHORE reg for BE2/BE3

Dave, can these 2 commits be queued for stable too:
commit1: c5b3ad4c67989c778e4753be4f91dc7193a04d21
commit2: 1bc8e7e4f36c0c19dd7dea29e7c248b7c6ef3a15

thanks,
-Sathya
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

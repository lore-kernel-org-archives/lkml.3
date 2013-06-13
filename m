Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932345Ab3FMC21 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 22:28:27 -0400
Received: from MAIL4.TENCENT.COM ([119.147.32.46]:59455 "EHLO
	mail4.tencent.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756681Ab3FMC20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 22:28:26 -0400
X-Greylist: delayed 593 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Jun 2013 22:28:26 EDT
From: =?gb2312?B?c2FtdWVsbGlhbyjBzsn6w+cp?= <samuelliao@tencent.com>
To: Yinghai Lu <yinghai@kernel.org>, Shan Wei <shanwei88@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Lin Feng <linfeng@cn.fujitsu.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Kernel-Maillist <linux-kernel@vger.kernel.org>,
        =?gb2312?B?ZGF2aWRzaGFuKLWlzsAp?= <davidshan@tencent.com>
Subject: Re: [PATCH buf-fix] kernel, range: fix broken mtrr_cleanup(Internet
 mail)
Thread-Topic: [PATCH buf-fix] kernel, range: fix broken
 mtrr_cleanup(Internet mail)
Thread-Index: AQHOZPWo5v+oeJKacUaifSBEAKM5NJktYiOAgAWK2GA=
Date: Thu, 13 Jun 2013 02:18:29 +0000
Message-ID: <A98DEB4ACFCFC841976D4371742E02E07623124C@EXMBX-SZ003.tencent.com>
In-Reply-To: <CAE9FiQWtJhubmrgwGjLjOHDJF+Vkt-Y4y2uHuXc6pZg1XUDRxg@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.30.9.38]
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r5D2SecI025409

I forget change final_start/final_end to start/end.  The old code add empty range in following case:

Before mtrr cleanup:
1. got initial MTRR range: 0-3G.
2. MTRR code try to merge 0-1M
3. result is 0-0, 0-3G,  total 2 range count

After cleanup:
1. got final MTRR range: 0-3G, total 1 range count

the cleanup code failed, because range count mismatch.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

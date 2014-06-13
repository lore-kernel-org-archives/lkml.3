Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354AbaFMScn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 14:32:43 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:49297 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751345AbaFMScm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 14:32:42 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Johannes Berg <johannes@sipsolutions.net>,
        Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Fri, 13 Jun 2014 11:28:54 -0700
Subject: RE: [patch V2] wireless: mwifiex: Use the proper interfaces
Thread-Topic: [patch V2] wireless: mwifiex: Use the proper interfaces
Thread-Index: Ac+GGccwB7jMi1iDRCibrr1wXjoDVQBGknMg
Message-ID: <477F20668A386D41ADCC57781B1F70430FE1F8BB11@SC-VEXCH1.marvell.com>
References: <20140611234024.103571777@linutronix.de>
	 <20140611234607.607201623@linutronix.de>
	 <477F20668A386D41ADCC57781B1F70430FE1F8B507@SC-VEXCH1.marvell.com>
	 <alpine.DEB.2.10.1406121029530.5170@nanos>
	 (sfid-20140612_103227_131521_9EAF500A)
 <1402562338.8095.4.camel@jlt4.sipsolutions.net>
In-Reply-To: <1402562338.8095.4.camel@jlt4.sipsolutions.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-06-13_07:2014-06-13,2014-06-13,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1406130198
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s5DIWmYe016073


> > +	u32 queue_delay = ktime_to_ms(net_timedelta(skb->tstamp));
> 
> FWIW, I think the same as patch 12 applies here. net_timedelta() doesn't
> really seem to be a good way to calculate time deltas.

Shall we change net_timedelta to ktime_sub() using ktime_get()?

+	u32 queue_delay = ktime_to_ms(ktime_sub(ktime_get(), skb->tstamp));

Thanks,
Bing

> 
> And yes - I've seen situations where this matters, e.g. when running
> ntpdate after system startup.
> 
> johannes
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

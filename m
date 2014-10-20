Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715AbaJTHk6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 03:40:58 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:34844 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751493AbaJTHk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 03:40:57 -0400
From: Neil Zhang <zhangwm@marvell.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 20 Oct 2014 00:40:48 -0700
Subject: RE: [PATCH] drivers: base: update cpu offline info when do hotplug
Thread-Topic: [PATCH] drivers: base: update cpu offline info when do hotplug
Thread-Index: Ac/sMgXhFfe7zufuRMiLPJjsVwlNVAABMN5A
Message-ID: <9034CBD80F070943B59700D7F8149ED9024EB81CC6@SC-VEXCH4.marvell.com>
References: <1413775748-22478-1-git-send-email-zhangwm@marvell.com>
 <20141020044340.GA9589@kroah.com>
 <9034CBD80F070943B59700D7F8149ED9024EB81CAF@SC-VEXCH4.marvell.com>
 <20141020064826.GA4064@kroah.com>
In-Reply-To: <20141020064826.GA4064@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-10-19_03:2014-10-17,2014-10-19,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1410200082
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id s9K7fAmf022796

Greg,


-----Original Message-----
From: Greg KH [mailto:gregkh@linuxfoundation.org] 
Sent: 2014Äê10ÔÂ20ÈÕ 14:48
To: Neil Zhang
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: base: update cpu offline info when do hotplug

On Sun, Oct 19, 2014 at 11:39:23PM -0700, Neil Zhang wrote:
>> How much noise is this going to cause on a big/little system that 
>> constantly hot unplug/plugs processors all of the time?
> 
> Can you explain more what kind of noise will be introduced on a big/little system?

Have you tested this on such a machine?

I didn't have such kind of machine on hand.
Can anyone has such machine to verify it?
Thanks!

> As I know IKS on arm will use cpu_suspend way to power down a core.

Are you sure that it also doesn't use that same functionality to drop a processor to save power?

As I know it use cpu_suspend to switch out a processor in IKS and there is no cpu hotplug notifier in this procedure.


Why do you need/want this notification?  What are you going to do with this information that you don't already have?

The offline won't be updated if an in kernel hotplug governor plug in / out a core which cause the sysfs interface report a wrong status.


thanks,

greg k-h


Best Regards,
Neil Zhang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

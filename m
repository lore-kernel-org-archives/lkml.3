Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751930AbaB0JM2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 04:12:28 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:41147 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750965AbaB0JMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 04:12:23 -0500
From: Neil Zhang <zhangwm@marvell.com>
To: "balbi@ti.com" <balbi@ti.com>
CC: Peter Chen <Peter.Chen@freescale.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Date: Thu, 27 Feb 2014 01:12:10 -0800
Subject: RE: [PATCH 2/6] usb: gadget: mv_udc: disable HW zlt for ep0
Thread-Topic: [PATCH 2/6] usb: gadget: mv_udc: disable HW zlt for ep0
Thread-Index: Ac8zBpkmGOD9cgN1TDODqguqNxuDeQAlSdLg
Message-ID: <175CCF5F49938B4D99B2E3EF7F558EBE54EC413C73@SC-VEXCH4.marvell.com>
References: <1393228996-14787-1-git-send-email-zhangwm@marvell.com>
 <1393228996-14787-3-git-send-email-zhangwm@marvell.com>
 <20140225011839.GD7540@shlinux1.ap.freescale.net>
 <175CCF5F49938B4D99B2E3EF7F558EBE54EC413563@SC-VEXCH4.marvell.com>
 <6ad74d797ecc473f922ffdb58c3e9c70@BN1PR03MB235.namprd03.prod.outlook.com>
 <175CCF5F49938B4D99B2E3EF7F558EBE54EC4135A5@SC-VEXCH4.marvell.com>
 <bce87beb86d34377ac3dae0645622edf@BN1PR03MB235.namprd03.prod.outlook.com>
 <20140225181234.GF23275@saruman.home>
 <175CCF5F49938B4D99B2E3EF7F558EBE54EC413885@SC-VEXCH4.marvell.com>
 <20140226151913.GF30028@saruman.home>
In-Reply-To: <20140226151913.GF30028@saruman.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-02-27_03:2014-02-26,2014-02-27,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1402270009
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s1R9CcEe005430


> -----Original Message-----
> From: Felipe Balbi [mailto:balbi@ti.com]
> Sent: 2014Äê2ÔÂ26ÈÕ 23:19
> To: Neil Zhang
> Cc: balbi@ti.com; Peter Chen; gregkh@linuxfoundation.org;
> linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org; Alexander Shishkin
> Subject: Re: [PATCH 2/6] usb: gadget: mv_udc: disable HW zlt for ep0
> 
> Hi,
> 
> On Tue, Feb 25, 2014 at 05:48:17PM -0800, Neil Zhang wrote:
> > > > > > > > > Hardware zlt will try to send the zero length packet
> > > > > > > > > automatically when the data transferd is multiple times
> > > > > > > > > of max packet, this will cause issues on Windows.
> > > > > > > > > So let's disable HW zlt by default.
> > > > > > > >
> > > > > > > > Would you have description that what kinds of issue on
> > > > > > > > Windows if zlt is is selected?
> > > > > > > >
> > > > > > >
> > > > > > > Enumeration will fail.
> > > > > > >
> > > > > >
> > > > > > What causes enumeration fail, why it does not occur before?
> > > > > >
> > > > > A unexpected zero packet cause enumeration fail.
> > > > > It's not easy that the descriptor is actually 1024 bytes, so not
> > > > > easy to be found.
> > > > >
> > > >
> > > > Chipidea bug too? Does it follow ch 8.5.3.2 Variable-length Data
> > > > Stage, USB
> > > 2.0 spec?
> > >
> > > wait, this is a chipidea core ? Why aren't you guys using the
> > > chipidea driver yet ? You need to switch over to that driver dude,
> > > we can't have duplicated code in the tree.
> > >
> > > I'm sorry, but I won't be taking this series, please use chipidea
> > > driver, it should be very simple to add a glue layer for your core to the
> chipidea driver.
> > >
> >
> > Yes, it use chipidea IP.
> > But the driver is earlier than the chipidea one and we use it for our
> > products.
> > So it may be not that easy to switch to chipidea driver due to the
> > stability.
> 
> that's nonsense, the average chipidea glue layer is ~80 LOCs. You can write
> that in less than 2 hours and give it a try. We cannot have duplicate drivers in
> the tree and development effort *must* be shared.
> 
> If you guys use the same IP, why wouldn't you use the same chipidea driver ?
> 
> sorry, you didn't convince me.

It's too sad!
Anyway we will estimate the chipidea driver to see whether it meets our requirement.

> 
> --
> Balbi

Best Regards,
Neil Zhang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

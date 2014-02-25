Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900AbaBYEOS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 23:14:18 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:34144 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752767AbaBYENm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 23:13:42 -0500
From: Neil Zhang <zhangwm@marvell.com>
To: Peter Chen <peter.chen@freescale.com>
CC: "balbi@ti.com" <balbi@ti.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 24 Feb 2014 20:13:34 -0800
Subject: RE: [PATCH 2/6] usb: gadget: mv_udc: disable HW zlt for ep0
Thread-Topic: [PATCH 2/6] usb: gadget: mv_udc: disable HW zlt for ep0
Thread-Index: Ac8xzzV7+gQ4C3tATQ2PzDbpbbQvGwAEKlPQ
Message-ID: <175CCF5F49938B4D99B2E3EF7F558EBE54EC413563@SC-VEXCH4.marvell.com>
References: <1393228996-14787-1-git-send-email-zhangwm@marvell.com>
 <1393228996-14787-3-git-send-email-zhangwm@marvell.com>
 <20140225011839.GD7540@shlinux1.ap.freescale.net>
In-Reply-To: <20140225011839.GD7540@shlinux1.ap.freescale.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-02-25_01:2014-02-21,2014-02-25,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1402240189
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s1P4Ejug019857




> -----Original Message-----
> From: Peter Chen [mailto:peter.chen@freescale.com]
> Sent: 2014Äê2ÔÂ25ÈÕ 9:19
> To: Neil Zhang
> Cc: balbi@ti.com; gregkh@linuxfoundation.org; linux-usb@vger.kernel.org;
> linux-kernel@vger.kernel.org
> Subject: Re: [PATCH 2/6] usb: gadget: mv_udc: disable HW zlt for ep0
> 
> On Mon, Feb 24, 2014 at 04:03:12PM +0800, Neil Zhang wrote:
> > Hardware zlt will try to send the zero length packet automatically
> > when the data transferd is multiple times of max packet, this will
> > cause issues on Windows.
> > So let's disable HW zlt by default.
> 
> Would you have description that what kinds of issue on Windows if zlt is is
> selected?
> 

Enumeration will fail.

> Peter
> 
> >
> > Signed-off-by: Neil Zhang <zhangwm@marvell.com>
> > ---
> >  drivers/usb/gadget/mv_udc_core.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/usb/gadget/mv_udc_core.c
> > b/drivers/usb/gadget/mv_udc_core.c
> > index ebc0dfd..657ac5c 100644
> > --- a/drivers/usb/gadget/mv_udc_core.c
> > +++ b/drivers/usb/gadget/mv_udc_core.c
> > @@ -89,7 +89,7 @@ static void ep0_reset(struct mv_udc *udc)
> >  		/* configure ep0 endpoint capabilities in dQH */
> >  		ep->dqh->max_packet_length =
> >  			(EP0_MAX_PKT_SIZE << EP_QUEUE_HEAD_MAX_PKT_LEN_POS)
> > -			| EP_QUEUE_HEAD_IOS;
> > +			| EP_QUEUE_HEAD_IOS | EP_QUEUE_HEAD_ZLT_SEL;
> >
> >  		ep->dqh->next_dtd_ptr = EP_QUEUE_HEAD_NEXT_TERMINATE;
> >
> > --
> > 1.7.9.5
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-usb"
> > in the body of a message to majordomo@vger.kernel.org More majordomo
> > info at  http://vger.kernel.org/majordomo-info.html
> >
> >
> 
> --
> 
> Best Regards,
> Peter Chen


Best Regards,
Neil Zhang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205AbaKDLG5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 06:06:57 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:48749 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750727AbaKDLGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 06:06:53 -0500
From: Neil Zhang <zhangwm@marvell.com>
To: Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "balbi@ti.com" <balbi@ti.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Date: Tue, 4 Nov 2014 03:05:57 -0800
Subject: RE: [PATCH] usb: gadget: don't create new string_container if
 already exist
Thread-Topic: [PATCH] usb: gadget: don't create new string_container if
 already exist
Thread-Index: Ac/ysJH16QdLMBGdS3WNFlh6N+PB6QFbXF3g
Message-ID: <9034CBD80F070943B59700D7F8149ED9024ED2A5B7@SC-VEXCH4.marvell.com>
References: <1414496039-5655-1-git-send-email-zhangwm@marvell.com>
 <544F95C3.2080306@samsung.com>
In-Reply-To: <544F95C3.2080306@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-11-04_05:2014-11-03,2014-11-04,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1411040108
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sA4B739A015988


> -----Original Message-----
> From: Andrzej Pietrasiewicz [mailto:andrzej.p@samsung.com]
> Sent: 2014Äê10ÔÂ28ÈÕ 21:10
> To: Neil Zhang; linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org
> Cc: balbi@ti.com; gregkh@linuxfoundation.org
> Subject: Re: [PATCH] usb: gadget: don't create new string_container if already
> exist
> 
> Hi,
> 
> W dniu 28.10.2014 o 12:33, Neil Zhang pisze:
> > Don't create new usb_gadget_string_container if the current strings
> > are already exist in the usb_composite_dev.
> > Otherwise the ids_tab will overflow soon if we bind / unbind usb
> > functions frequently like android does.
> 
> The problem you are describing does not exist in mainline kernel, where
> functions are always unbound as part of the whole gadget's unbind - regardless
> of whether it is a legacy gadget or configfs-composed gadget. When the whole
> gadget is unbound, composite_dev_cleanup() is called which zeroes cdev-
> >next_string_id and frees all gadget strings containers.
> 

Yes, you are right that the current mainline won't suffer this issue.
But it will be needed if we want to implement similar features like android do.
It will only remove config rather than whole gadget driver.


> >
> > Signed-off-by: Neil Zhang <zhangwm@marvell.com>
> > ---
> >   drivers/usb/gadget/composite.c |    6 ++++++
> >   1 file changed, 6 insertions(+)
> >
> > diff --git a/drivers/usb/gadget/composite.c
> > b/drivers/usb/gadget/composite.c index a8c18df..6fe3c6b 100644
> > --- a/drivers/usb/gadget/composite.c
> > +++ b/drivers/usb/gadget/composite.c
> > @@ -1183,6 +1183,12 @@ struct usb_string *usb_gstrings_attach(struct
> usb_composite_dev *cdev,
> >   	if (!n_gstrings)
> >   		return ERR_PTR(-EINVAL);
> >
> > +	list_for_each_entry(uc, &cdev->gstrings, list) {
> > +		n_gs = get_containers_gs(uc);
> > +		if (!strcmp(n_gs[0]->strings[0].s, sp[0]->strings[0].s))
> 
> To me it looks like it is a big assumption that if the first string matches,
> the rest are the same, too. Isn't it?
> 
> Anyway, this solution looks more like pushing the moment when cdev-
> >next_string_id becomes 254 to a later time rather than preventing such a
> situation.
> 
> If usb_gstrings_attach() happens at function bind time, perhaps there should
> be some usb_gstrings_detach() called at function unbind?
> 
> AP


Best Regards,
Neil Zhang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

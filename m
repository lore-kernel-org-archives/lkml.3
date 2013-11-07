Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612Ab3KGCiB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 21:38:01 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:26877 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751777Ab3KGCh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 21:37:58 -0500
Date: Thu, 7 Nov 2013 10:36:07 +0800
From: Jisheng Zhang <jszhang@marvell.com>
To: Shawn Guo <shawn.guo@linaro.org>
CC: "balbi@ti.com" <balbi@ti.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: phy: phy-mxs-usb: set the correct platform drvdata
Message-ID: <20131107103607.53489c5d@xhacker>
In-Reply-To: <20131107023446.GC5994@S2101-09.ap.freescale.net>
References: <1383791180-3579-1-git-send-email-jszhang@marvell.com>
	<20131107023446.GC5994@S2101-09.ap.freescale.net>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-11-07_01:2013-11-06,2013-11-07,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1311060253
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Nov 2013 18:34:47 -0800
Shawn Guo <shawn.guo@linaro.org> wrote:

> On Thu, Nov 07, 2013 at 10:26:20AM +0800, Jisheng Zhang wrote:
> > We need to set mxs_phy rather as the platform drvdata so that we can get
> > the correct mxs_phy in mxs_phy_remove().
> > 
> > Change-Id: I6e1753cc978e2ed3fbb3d1865be0c54031d337d2
> > Signed-off-by: Jisheng Zhang <jszhang@marvell.com>
> 
> Acked-by: Shawn Guo <shawn.guo@linaro.org>
> 
> Change-Id should be dropped though.

OOPs, sorry, I should take care of that. I'll remind myself every time.

Thank you for your pointing out

Jisheng
> 
> Shawn
> 
> > ---
> >  drivers/usb/phy/phy-mxs-usb.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/usb/phy/phy-mxs-usb.c b/drivers/usb/phy/phy-mxs-usb.c
> > index fdd33b4..545844b 100644
> > --- a/drivers/usb/phy/phy-mxs-usb.c
> > +++ b/drivers/usb/phy/phy-mxs-usb.c
> > @@ -164,7 +164,7 @@ static int mxs_phy_probe(struct platform_device *pdev)
> >  
> >  	mxs_phy->clk = clk;
> >  
> > -	platform_set_drvdata(pdev, &mxs_phy->phy);
> > +	platform_set_drvdata(pdev, mxs_phy);
> >  
> >  	ret = usb_add_phy_dev(&mxs_phy->phy);
> >  	if (ret)
> > -- 
> > 1.8.4.2
> > 
> 


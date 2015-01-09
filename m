Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490AbbAIG15 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 01:27:57 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:39559 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750928AbbAIG14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 01:27:56 -0500
Date: Fri, 9 Jan 2015 14:24:44 +0800
From: Jisheng Zhang <jszhang@marvell.com>
To: Felipe Balbi <balbi@ti.com>
CC: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC] usb: dwc3: add DWC3_SKIP_USB3PHY and DWC3_SKIP_USB2_PHY
 quirks
Message-ID: <20150109142444.49e0ff2f@xhacker>
In-Reply-To: <20150108170815.GJ31926@saruman>
References: <20141208213551.38860f81@xhacker>
	<20150108170815.GJ31926@saruman>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2015-01-09_03:2015-01-07,2015-01-09,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1501090053
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

On Thu, 8 Jan 2015 09:08:15 -0800
Felipe Balbi <balbi@ti.com> wrote:

> Hi,
> 
> On Mon, Dec 08, 2014 at 09:35:51PM +0800, Jisheng Zhang wrote:
> > On platforms which has native usb hosts/phys and pci-dwc3 controller,
> > the dwc3 core may get the wrong usb2_phy and usb3_phy by
> > devm_usb_get_phy(). It depends on which usb phy driver is initialized
> > firstly, the usb_phy_generic or the native/real usb phy driver.
> 
> why are you initializing generic PHY if you have a real PHY ?

we have two kind of usb hosts: the native usb hosts which can be probed via. DT
and the usb hosts from pci-dwc3. The former has real phy and the latter doesn't.

> 
> > Before all old USB phy library usage removed, the solution I can have
> > is to add DWC3_SKIP_USB3PHY and DWC3_SKIP_USB2_PHY quirks and set them
> > in dwc3-pci.
> > Could such modification can be accepted? If not, could you please give
> > alternative suggestions?
> 
> we will not accept a quirk to skip PHYs, sorry. A better way of handling
> this needs to be found.
> 

OK, Got your points. It seems we need to deprecate old usb phy library usage
early.

Thanks,
Jisheng

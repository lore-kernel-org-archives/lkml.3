Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502AbaLHNiz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 08:38:55 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:26138 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750908AbaLHNiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 08:38:52 -0500
Date: Mon, 8 Dec 2014 21:35:51 +0800
From: Jisheng Zhang <jszhang@marvell.com>
To: <balbi@ti.com>
CC: <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: [RFC] usb: dwc3: add DWC3_SKIP_USB3PHY and DWC3_SKIP_USB2_PHY
 quirks
Message-ID: <20141208213551.38860f81@xhacker>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2014-12-08_01:2014-12-08,2014-12-07,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=1 spamscore=1 suspectscore=1
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1412080135
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi list,

On platforms which has native usb hosts/phys and pci-dwc3 controller, the dwc3
core may get the wrong usb2_phy and usb3_phy by devm_usb_get_phy(). It depends
on which usb phy driver is initialized firstly, the usb_phy_generic or the
native/real usb phy driver.

Before all old USB phy library usage removed, the solution I can have is to
add DWC3_SKIP_USB3PHY and DWC3_SKIP_USB2_PHY quirks and set them in dwc3-pci.
Could such modification can be accepted? If not, could you please give alternative
suggestions?

Thanks,
Jisheng

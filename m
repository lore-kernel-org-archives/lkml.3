Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751396AbaLBJOI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 04:14:08 -0500
Received: from mout.kundenserver.de ([212.227.17.13]:56125 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbaLBJOF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 04:14:05 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: =?ISO-8859-1?Q?S=F6ren?= Brinkmann <soren.brinkmann@xilinx.com>
Cc: linux-arm-kernel@lists.infradead.org,
        Michal Simek <michal.simek@xilinx.com>, devicetree@vger.kernel.org,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        linux-kernel@vger.kernel.org,
        Andreas =?ISO-8859-1?Q?F=E4rber?= <afaerber@suse.de>
Subject: Re: [PATCH] ARM: zynq: DT: Add USB to device tree
Date: Tue, 02 Dec 2014 10:13:30 +0100
Message-ID: <2598972.HWjIWPLUn8@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <71b9e172438946a5ba74efb430d1418c@BN1AFFO11FD060.protection.gbl>
References: <1417459352-23401-1-git-send-email-soren.brinkmann@xilinx.com> <7088901.UGmPabvHQ0@wuerfel> <71b9e172438946a5ba74efb430d1418c@BN1AFFO11FD060.protection.gbl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
X-Provags-ID: V02:K0:ODrfMN3GBw5RM/tVN5pL/RlZqMVg8jqUb0jr42y6WaL
 5SaYDZo0qeTeAv2HPFoSNiANJJR7FrVbbXjZWgcJEJS3QWhjxW
 DcmkrWK4Vwl9MVyHdwX3fxYDYw2QW5gBeOHMLjpCp0km2fAunt
 Edjx3QHOUF+QiEYatVYr4MEfjPGE56iKQ1QYed+/dAAf9ukAnU
 xazGC2Hk+qvUZMQYFHzbGMF76Up4M5EWERI9tEcDobfnLXS/0H
 +PybSQQkE5Qy4SAXLlXIVlhbwaKHVCWSIxV7qXMEskkB6+pokD
 IgrvcbPBydDgy5cdrGgYvNA0LJdjHiDMYDRRZRztv3dqorFIIv
 EDHuPVK60IiuyzEPXJWM=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 December 2014 13:51:26 Sören Brinkmann wrote:
> Hi Arnd,
> 
> On Mon, 2014-12-01 at 10:26PM +0100, Arnd Bergmann wrote:
> > On Monday 01 December 2014 10:42:32 Soren Brinkmann wrote:
> > > +       usb_phy0: usb-phy@0 {
> > > +               compatible = "usb-nop-xceiv";
> > > +               #phy-cells = <0>;
> > > +       };
> > >  };
> > 
> > As discussed in an unrelated thread today, please drop the "@0" in the
> > node name, since the device has no 'reg' property.
> 
> What is the best practice for naming such nodes then? On these boards
> it's not the case, but Zynq has two USB cores. So, there may be DTs that
> will have two phys in there. Would we just do 'usb-phy-0'?
> 
> 

Grant recommended naming them "phy0" and "phy1" in this case.
The recommended node name for a phy is "phy", not "usb-phy" (I didn't
notice that earlier, but it makes sense to change both), and
I would not use a dash for the number there.

	Arnd

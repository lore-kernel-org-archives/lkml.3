Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752385AbaJTFDm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 01:03:42 -0400
Received: from mail1.bemta8.messagelabs.com ([216.82.243.197]:57680 "EHLO
	mail1.bemta8.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751220AbaJTFDk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 01:03:40 -0400
X-Env-Sender: Iwo.Mergler@netcommwireless.com
X-Msg-Ref: server-8.tower-86.messagelabs.com!1413781373!55568939!1
X-Originating-IP: [220.233.131.78]
X-StarScan-Received: 
X-StarScan-Version: 6.12.2; banners=netcommwireless.com,-,-
X-VirusChecked: Checked
From: Iwo Mergler <Iwo.Mergler@netcommwireless.com>
To: Huang Shijie <shijie8@gmail.com>
CC: Boris Brezillon <boris.brezillon@free-electrons.com>,
        Mike Voytovich <mvoytovich@paypal.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        Roy Lee <roylee@paypal.com>,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Mon, 20 Oct 2014 16:02:52 +1100
Subject: RE: [PATCH v3 0/3] mtd: nand: gpmi: add proper raw access support
Thread-Topic: [PATCH v3 0/3] mtd: nand: gpmi: add proper raw access support
Thread-Index: Ac/rQ1GY17+Pth3ET2mqCM6I5f1PDwA3IMUb
Message-ID: <EACD232272DA4849B060F0828564D13B449961CF27@ntcex01.corp.netcomm.com.au>
References: <1411481256-29141-1-git-send-email-boris.brezillon@free-electrons.com>
 <20141008142437.GA9912@localhost.localdomain>
 <20141008171034.1506550f@bbrezillon>
 <20141010144248.GA5107@localhost.localdomain>
 <EACD232272DA4849B060F0828564D13B44955ABE1F@ntcex01.corp.netcomm.com.au>,<20141019022035.GA1412@localhost.localdomain>
In-Reply-To: <20141019022035.GA1412@localhost.localdomain>
Accept-Language: en-US, en-AU
Content-Language: en-AU
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US, en-AU
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 19 Oct 2014 13:20:38 +1100 Huang Shijie <shijie8@gmail.com> wrote:
> On Tue, Oct 14, 2014 at 04:50:27PM +1100, Iwo Mergler wrote:
> > 
> > >
> > > No, it doesn't seem to be correct.
> > > But it's an MLC flash, so you'll most probably need to apply this
> > > patch to nandbiterrs testsuite:
> > >
> > > http://code.bulix.org/f69wuu-87021
> > >
> > > This patch is flashing the block between each bitflip insertion to
> > > avoid multiple write without erasure (which, AFAIK, is not
> > > supported by MLC flashes).
> > 
> > Hi Huang,
> > 
> > 
> > just out of interest, have you tried this on the MLC NAND without
> > the patch?
> > 
> > I'm aware that MLC says you shouldn't write multiple times, but
> > that is with a view towards specified data endurance. I would only
> > expect a few additional bit errors during the test.
> > 
> > Did you try the overwrite test?
> > 
> The following is the test result for overwrite with this MLC patch:
> 
> root@imx6qdlsolo:~# insmod mtd_nandbiterrs.ko dev=1 mode=1
> [  762.534714] 
> [  762.536259] ==================================================
> [  762.542115] mtd_nandbiterrs: MTD device: 1
> [  762.546326] mtd_nandbiterrs: MTD device size 16777216,
> 	eraseblock=2097152, page=8192, oob=744
> 	[  762.554937] mtd_nandbiterrs: Device uses 1 subpages of 8192
> 	bytes
> 	[  762.561059] mtd_nandbiterrs: Using page=0, offset=0,
> 	eraseblock=0
> 	[  762.571333] mtd_nandbiterrs: overwrite biterrors test
> 	[  762.576715] mtd_nandbiterrs: write_page
> 	[  762.590448] mtd_nandbiterrs: error: read failed at 0x0
> 	[  762.595650] mtd_nandbiterrs: Read reported error -74
> 	[  762.600625] mtd_nandbiterrs: Bit error histogram (0
> 			operations total):
> 	[  762.608586] mtd_nandbiterrs: finished successfully.
> 	[  762.613501]
> 	==================================================
> 	insmod: ERROR: could not insert module mtd_nandbiterrs.ko:
> 	Input/output error
> 

Thanks. If I read this correctly, this means that writing the same data twice,
already generates more bit errors than the ECC can fix.


Best regards,

Iwo

______________________________________________________________________
This communication contains information which may be confidential or privileged. The information is intended solely for the use of the individual or entity named above.  If you are not the intended recipient, be aware that any disclosure, copying, distribution or use of the contents of this information is prohibited.  If you have received this communication in error, please notify me by telephone immediately.
______________________________________________________________________

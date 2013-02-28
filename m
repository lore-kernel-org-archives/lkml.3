Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904Ab3B1ENW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 23:13:22 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:43922 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003Ab3B1ENU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 23:13:20 -0500
From: "Philip, Avinash" <avinashphilip@ti.com>
To: Mark Jackson <mpfj-list@mimc.co.uk>,
        Stephen Rothwell <sfr@canb.auug.org.au>
CC: David Woodhouse <dwmw2@infradead.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        lkml <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>
Subject: RE: linux-next: JFFS2 corruption
Thread-Topic: linux-next: JFFS2 corruption
Thread-Index: AQHOFDnRyo9GH7SKiUWkrJcRJE0N5ZiMan4AgAEKcICAATP5UA==
Date: Thu, 28 Feb 2013 04:11:56 +0000
Deferred-Delivery: Thu, 28 Feb 2013 04:11:00 +0000
Message-ID: <518397C60809E147AF5323E0420B992E3EA8EF4A@DBDE01.ent.ti.com>
References: <512CD9BA.3080300@mimc.co.uk>
 <20130227101824.6e18ba21fb99070594420f29@canb.auug.org.au>
 <512E2241.9040705@mimc.co.uk>
In-Reply-To: <512E2241.9040705@mimc.co.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.162.25]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2013 at 20:42:01, Mark Jackson wrote:
> On 26/02/13 23:18, Stephen Rothwell wrote:
> > Hi Mark,
> > 
> > On Tue, 26 Feb 2013 15:50:18 +0000 Mark Jackson <mpfj-list@mimc.co.uk> wrote:
> >>
> >> Just tested the current next-20130226 on a custom AM335X board, and if I mount
> >> our JFFS2 image as read/write, the next reboot shows the image as being corrupt.
> >>
> >> If I reprogram the jffs2 image into NAND and only mount the volume as read-only,
> >> no corruption occurs and the system remains intact.
> >>
> >> I have also tested:-
> >>
> >> (a) reprogram ubifs image into nand
> >> (b) boot the volume as read-only (corrupt -> no)
> >> (c) remount the volume as read/write
> >> (d) rebooting the volume as read-only (corrupt -> yes)
> > 
> > Thanks for all the testing.  Sam questions as in my other email.
> 
> Okay, just tested 3v8 plus:-
> 
> https://patchwork.kernel.org/patch/1931251/
> https://patchwork.kernel.org/patch/1931221/
> https://patchwork.kernel.org/patch/1931201/
> and changed drivers/mtd/nand/elm.c, line 388 "ti,am33xx-elm" to "ti,am3352-elm"
> 
> This produces an identical corruption.
> 
> I have also tested next-20130225 and next-20130227, and both cause the same corruption.

JFFS2 is not supported in am335x with BCH8 ecc scheme because of ECC layout constraints.
Reasons for disabling JFFS2 support documented in the wiki
http://processors.wiki.ti.com/index.php/AM335x_JFFS2_Support_Guide#Reasons_for_disabling_JFFS2_support


Thanks
Avinash
> 
> Regards
> Mark J.
> 
> ______________________________________________________
> Linux MTD discussion mailing list
> http://lists.infradead.org/mailman/listinfo/linux-mtd/
> 


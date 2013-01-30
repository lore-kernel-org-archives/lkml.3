Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106Ab3A3N3p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 08:29:45 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:40235 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753146Ab3A3N3n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 08:29:43 -0500
From: "Bedia, Vaibhav" <vaibhav.bedia@ti.com>
To: Pantelis Antoniou <panto@antoniou-consulting.com>
CC: "N, Mugunthan V" <mugunthanvnm@ti.com>,
        Richard Cochran <richardcochran@gmail.com>,
        "Porter, Matt" <mporter@ti.com>, "Maupin, Chase" <chase.maupin@ti.com>,
        "Kridner, Jason" <jdk@ti.com>, Tony Lindgren <tony@atomide.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] cpsw: Fix interrupt storm among other things
Thread-Topic: [PATCH] cpsw: Fix interrupt storm among other things
Thread-Index: AQHN/VkLC7cBWM1SeUOPLhpObgalgphf1VUAgAFdd4CAAAeFAIAACU4AgAAWMICAAAOoAIAAc54A//+nHQCAAGgloA==
Date: Wed, 30 Jan 2013 13:29:36 +0000
Message-ID: <B5906170F1614E41A8A28DE3B8D121433ED04134@DBDE01.ent.ti.com>
References: <1359378668-26536-1-git-send-email-panto@antoniou-consulting.com>
 <5107B650.5090901@ti.com>
 <3DE2C638-6AE8-4BC9-AD68-3AAA40CD6233@antoniou-consulting.com>
 <5108E1C6.9020201@ti.com>
 <0FB10FF4-6639-472E-943C-61CEDB0336E0@antoniou-consulting.com>
 <5108FC31.3000507@ti.com>
 <27A3106E-3FDB-43DB-AAC9-DC2DA768AF9E@antoniou-consulting.com>
 <B5906170F1614E41A8A28DE3B8D121433ED03FE1@DBDE01.ent.ti.com>
 <0422CC2C-3D0D-4BB5-A90D-D3D337E44DD0@antoniou-consulting.com>
In-Reply-To: <0422CC2C-3D0D-4BB5-A90D-D3D337E44DD0@antoniou-consulting.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.133.119]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2013 at 18:14:30, Pantelis Antoniou wrote:
> Hi Vaibhav,
> 
> On Jan 30, 2013, at 2:38 PM, Bedia, Vaibhav wrote:
> 
> > On Wed, Jan 30, 2013 at 16:38:50, Pantelis Antoniou wrote:
> > [...]
> >> 
> >> TBH I haven't found a simple way to print out the silicon revision number.
> >> Anyone on the list know a quick and dirty method? 
> >> 
> > 
> > You can dump the DEVICE_ID register @ 0x44e10600.
> > Bits 31:28 should be 0 for PG1.0 and 1 for PG2.0.
> > 
> 
> Thanks this works perfectly:
> 
> original-bone:
> root@beaglebone:~# devmem2 0x44e10600 w
> Read at address  0x44E10600 (0xb6ff4600): 0x0B94402E
> 
> bone-black:
> root@beaglebone:~# devmem2 0x44e10600 w
> Read at address  0x44E10600 (0xb6fcc600): 0x1B94402E
> 

I just re-read the mail-chain and I am confused here.
So the patch in question is meant for Bone-A4 which has
PG1.0?

Regards,
Vaibhav

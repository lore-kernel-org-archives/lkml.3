Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300Ab3EQHQe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 03:16:34 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:60769 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754466Ab3EQHQd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 03:16:33 -0400
From: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
To: "Stehle, Vincent" <v-stehle@ti.com>
CC: =?iso-8859-1?Q?Vincent_Stehl=E9?= <vincent.stehle@laposte.net>,
        "Tony Lindgren" <tony@atomide.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] ARM: OMAP5: select SCU
Thread-Topic: [PATCH] ARM: OMAP5: select SCU
Thread-Index: AQHOUMRJeb+OHGWzKEikdwH8wgrFopkGBlSAgAE/gICAABX5gIABnz9t
Date: Fri, 17 May 2013 07:16:23 +0000
Message-ID: <448912EABC71F84BBCADFD3C67C4BE527C6D42@DBDE04.ent.ti.com>
References: <1368550638-2046-1-git-send-email-vincent.stehle@laposte.net>
 <51938169.4060109@ti.com> <5194DAC5.9080203@ti.com>,<5194ED33.7050502@ti.com>
In-Reply-To: <5194ED33.7050502@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.154]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for top posting. Can you just add static inlines functions in header file and #ifdef it for OMAP5.

Regards,
Santosh
________________________________________
From: Stehle, Vincent
Sent: Thursday, May 16, 2013 7:59 PM
To: Shilimkar, Santosh
Cc: Vincent Stehlé; Tony Lindgren; linux-omap@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: OMAP5: select SCU

So the exact commit breaking OMAP5 link for me is:

  883a106 ARM: default machine descriptor for multiplatform

The breakage seems to be a side effect of not selecting ARCH_VEXPRESS
any more, which causes HAVE_ARM_SCU to not be selected any more, too,
when compiling only for OMAP5. IMHO this only reveals a deeper issue.

Probably the ideal fix would be to remove all references to the scu_
functions for OMAP5, but those seem to exist in files and functions,
common to OMAP4 and 5 (sleep44xx.S, omap-smp.c).

How would you deal with that, please?

Best regards,

V.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751417AbaC1IGr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 04:06:47 -0400
Received: from [207.46.163.210] ([207.46.163.210]:4510 "EHLO
	na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751173AbaC1IGk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 04:06:40 -0400
From: Insop Song <Insop.Song@gainspeed.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "insop.song@gmail.com" <insop.song@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: RE: [PATCH] Remove warning printk
Thread-Topic: [PATCH] Remove warning printk
Thread-Index: AQHPSjmFMn1Otz1SPUCBG7+7zlX2mpr2D0QAgAAUAuI=
Date: Fri, 28 Mar 2014 08:05:23 +0000
Message-ID: <e575184bc64e46b9b5e229cec5338030@BY2PR07MB011.namprd07.prod.outlook.com>
References: <1395978883-18723-1-git-send-email-insop.song@gainspeed.com>
 <1395978883-18723-2-git-send-email-insop.song@gainspeed.com>,<20140328064926.GB13510@kroah.com>
In-Reply-To: <20140328064926.GB13510@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [76.218.13.253]
x-forefront-prvs: 01644DCF4A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(51704005)(199002)(189002)(377454003)(24454002)(87266001)(93516002)(56816005)(87936001)(93136001)(85306002)(90146001)(98676001)(81542001)(2656002)(74502001)(63696002)(47446002)(74662001)(77982001)(94316002)(59766001)(94946001)(85852003)(86362001)(69226001)(65816001)(66066001)(97186001)(20776003)(31966008)(80022001)(19580405001)(81686001)(83322001)(74366001)(54316002)(56776001)(19580395003)(51856001)(97336001)(95666003)(54356001)(76576001)(81342001)(76796001)(76786001)(53806001)(74876001)(74316001)(49866001)(92566001)(47976001)(81816001)(77096001)(95416001)(74706001)(33646001)(79102001)(47736001)(50986001)(83072002)(80976001)(4396001)(46102001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR07MB010;H:BY2PR07MB011.namprd07.prod.outlook.com;FPR:88C4F929.9CE39D9A.B4DDB5F3.4458DAA3.202EB;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: gainspeed.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Will send out a new patch mail with single patch shortly.

I have not yet find a good way to reply mail and add patch yet with my mailing server/client.

That's why I send out a separate email instead of replying to Arnd.

Below is his email and it has his signed-off, that's why I put that in my patch you got.

I took that out from a new patch to make it clear on your end.

Regards,

ISS

Here is Arnd's original email 
________________________________________
From: Arnd Bergmann <arnd@arndb.de>
Sent: Tuesday, March 25, 2014 8:48 AM
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org; Insop Song
Subject: [PATCH] staging: gs_fpgaboot: remove __TIMESTAMP__ macro

We specifically build the kernel with -Werror=date-time to detect
such macros, which gives us this error:

gs_fpgaboot/gs_fpgaboot.c:376:44: error: macro "__TIMESTAMP__" might prevent reproducible builds [-Werror=date-time]
  pr_info("built at %s UTC\n", __TIMESTAMP__);

The obvious fix is to remove the printk output line.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/drivers/staging/gs_fpgaboot/gs_fpgaboot.c b/drivers/staging/gs_fpgaboot/gs_fpgaboot.c
index 89bc84d..7506900 100644
--- a/drivers/staging/gs_fpgaboot/gs_fpgaboot.c
+++ b/drivers/staging/gs_fpgaboot/gs_fpgaboot.c
@@ -373,7 +373,6 @@ static int __init gs_fpgaboot_init(void)
        r = -1;

        pr_info("FPGA DOWNLOAD --->\n");
-       pr_info("built at %s UTC\n", __TIMESTAMP__);

        pr_info("FPGA image file name: %s\n", file);



________________________________________
From: Greg KH <gregkh@linuxfoundation.org>
Sent: Thursday, March 27, 2014 11:49 PM
To: Insop Song
Cc: insop.song@gmail.com; linux-kernel@vger.kernel.org; Arnd Bergmann
Subject: Re: [PATCH] Remove warning printk

On Thu, Mar 27, 2014 at 08:54:43PM -0700, Insop Song wrote:
> Found from build with option -Werror=date-time
>
> Signed-off-by: Insop Song <insop.song@gainspeed.com>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Did Arnd really sign off on this?

And what is with the "odd" subject, your first email should have been
the subject of this one.  We don't need a "cover letter" for a one-patch
email sequence.

Care to fix this up and resend?

thanks,

greg k-h

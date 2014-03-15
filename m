Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216AbaCODaT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 23:30:19 -0400
Received: from nm27-vm3.bullet.mail.gq1.yahoo.com ([98.136.216.146]:20506 "EHLO
	nm27-vm3.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754680AbaCODaR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 23:30:17 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 243564.51175.bm@omp1095.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=kMDJ40IETT3TnGiEWRdV7HF5YXY/a76GdBhVF8cU4RBVp2wkQsf8WnEfAyEwtH5h3CKxwesAjnxbu+2NI7E/IZX87FavDKXYAlPWD1AaGDt0XdjYY//veNMaA0/MMQpMOaygePXFEvtABMZ4+T8JYk3xlJnrRsUtDBMinH5gCz4=;
X-YMail-OSG: Ruo.ylMVM1meDUuFBWJSvzqsO3L5MRCiNqUk7GZS_HHJq5f
 pYYK2q1.72B.tk7VlJwyDpYdGdsht6Cugv5HWWN4ZMLMU1woXER32P9ftJJV
 ika4wWQzqfFxSFX0k1lWwEqrWr0I5Bt2HUY0EVCG91VlIfplXGB.Vh1PERJC
 G9hnMY0AhC.fh4rlGJmCUOrFJBiWA8oEvholdEKlUnVNouE1X.yvkw1jKfTD
 rigObyhOIr7fy0mJq4WsWt4_vfa7xokcfTJkw8rbW50p1AUOazAuqG.SISLy
 3At0ls.aW3bTOM8KyjKNdOKXAH8zs8MS9hvGrIMU._UnAtF4BSAMW6G6VgDi
 xULVA.YePvn0OwOtg5sN9NrIgc5QK1GCcgiiDpl3fSiYBlwQ2dt7PzbX8EVk
 TAk2vFkPuqL5AJx.8eEWszUuCEFRBrSjyA2KduABvLdcRoLapteI_uHKl3Xj
 y_dz_J.cv7vVi60V26KfhLDfA1MlaGkbQa694ONI2I259UP9Uz53rYSzIfmX
 dMOHyq3g9dA0EX38-
X-Rocket-MIMEInfo: 002.001,Pk9uIEZyaWRheSwgTWFyY2ggMTQsIDIwMTQgMTE6NDcgQU0sIExldmVudGUgS3VydXNhIDxsZXZleEBsaW51eC5jb20.IHdyb3RlOgoKPkNhbGwga2ZyZWUoKSBvbiBiZGV2LiBUaGUgdmFyaWFibGUgaXMgb3RoZXJ3aXNlIGxlYWtlZC4KPgo.U2lnbmVkLW9mZi1ieTogTGV2ZW50ZSBLdXJ1c2EgPGxldmV4QGxpbnV4LmNvbT4KPi0tLQo.ZHJpdmVycy9zdGFnaW5nL2NvbWVkaS9kcml2ZXJzL2NvbWVkaV9ib25kLmMgfCAxICsKPjEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKQo.Cj5kaWZmIC0tZ2l0IGEBMAEBAQE-
X-Mailer: YahooMailWebService/0.8.178.641
References: <1394813775-12363-1-git-send-email-levex@linux.com>
Message-ID: <1394854216.83246.YahooMailNeo@web164002.mail.gq1.yahoo.com>
Date: Fri, 14 Mar 2014 20:30:16 -0700 (PDT)
From: Chase Southwood <chase.southwood@yahoo.com>
Reply-To: Chase Southwood <chase.southwood@yahoo.com>
Subject: Re: [PATCH] staging: comedi: fix memory leak
To: Levente Kurusa <levex@linux.com>, Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        OSUOSL Drivers <devel@driverdev.osuosl.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1394813775-12363-1-git-send-email-levex@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>On Friday, March 14, 2014 11:47 AM, Levente Kurusa <levex@linux.com> wrote:

>Call kfree() on bdev. The variable is otherwise leaked.
>
>Signed-off-by: Levente Kurusa <levex@linux.com>
>---
>drivers/staging/comedi/drivers/comedi_bond.c | 1 +
>1 file changed, 1 insertion(+)
>
>diff --git a/drivers/staging/comedi/drivers/comedi_bond.c >b/drivers/staging/comedi/drivers/comedi_bond.c
>index 51a59e5..406aedb 100644
>--- a/drivers/staging/comedi/drivers/comedi_bond.c
>+++ b/drivers/staging/comedi/drivers/comedi_bond.c
>@@ -254,6 +254,7 @@ static int do_dev_config(struct comedi_device *dev, struct comedi_devconfig *it)
>            if (!devs) {
>                dev_err(dev->class_dev,
>                    "Could not allocate memory. Out of memory?\n");
>+                kfree(bdev);
>                return -ENOMEM;
>            }
>            devpriv->devs = devs;
>-- 
>1.8.3.1
>


Levente,

This change has already been made in staging-next (by me, actually :) ).  In
order to avoid re-doing work which has already been done, please make sure to base
all of your patches off of linux-next (or for staging, staging-next).

Thanks,
Chase

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512AbaDCWFR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 18:05:17 -0400
Received: from nm29-vm6.bullet.mail.gq1.yahoo.com ([98.136.216.181]:33409 "EHLO
	nm29-vm6.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751577AbaDCWFM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 18:05:12 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 740582.8830.bm@omp1075.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=mVeK/yFf6bPNzYvkZ1+rsC3Pu82Z4dlpqNpAjN2m3P3n25ZaMbgTgDpTMsUQs8RUJthZo8++vmVpWo7m0IxEobUue5LnT+WKnzvDtEbWXh+0nBb8V2YG13izY+S6zCWitGXM94P0CyzCl30J1sk6/3fCM9fSPV2eCrBR7fvNC8U=;
X-YMail-OSG: 9FLPoMgVM1nsGw0ntrE5LEoyKOhftBVYYf.MFOEoXij_afr
 KXAP6byXQHfiZA9rZrQQHxWFpNNANet26GJEaF0C1fyerlB56WHQ6u29V5F9
 tfH6Kd5e8bab8wCj.lYXFHxt1imqRuwmQJHhewEx4J.F3LG_ZomckG7N48Nm
 fNppxRs5xsiwpmBM4MkQVR_UichmuPxmyngE8aujifKkCQSajJdj8nU0q3QS
 3nILUi7JHLnJPb4sWNJPd2TkfONMpp4.p95lBOtljDVc__vsD2ZrA6HOAzPD
 Yt3fGEIdamg73ttY2Ch3AEcWSkKzdAsTKT73UB9zwkbOEXgaRAaTtsiRj4GA
 giy0_jlIceco3saXntpCVfDnygvBApKO4kOFFer8Ly.gcP_Inwu2WRprxo_C
 SSTf9Aa2Sr9Kd.KQK1Xv5nqchl8U2bEgZRiQJI1yqphG87sVbwmjs8k3iNSq
 s_J4TQnjjiLJX0zL9H7C6lpfRNQS2e_.zjz5Md0YtTA9npC3oR3dO.Q6eVeT
 7f0k-
X-Rocket-MIMEInfo: 002.001,Pk9uIFRodXJzZGF5LCBBcHJpbCAzLCAyMDE0IDM6MzggQU0sIERhbiBDYXJwZW50ZXIgPGRhbi5jYXJwZW50ZXJAb3JhY2xlLmNvbT4gd3JvdGU6Cgo.Pk9uIFR1ZSwgTWFyIDI1LCAyMDE0IGF0IDEwOjQzOjU4UE0gLTA1MDAsIENoYXNlIFNvdXRod29vZCB3cm90ZToKPj5UaGVyZSB3ZXJlIGp1c3QgYSBoYW5kZnVsIG9mIG1vcmUgd2hpbGUgbG9vcHMgaW4gdGhpcyBmaWxlIHRoYXQgbmVlZGVkCj4.dGltZW91dHMsIGFuZCB0aGlzIHBhdGNoIHRha2VzIGNhcmUgb2YgdGhlbS7CoCBPbmUgbmV3IGNhbGxiYWMBMAEBAQE-
X-Mailer: YahooMailWebService/0.8.182.648
References: <1395724172-30183-1-git-send-email-chase.southwood@yahoo.com> <1395805438-12259-1-git-send-email-chase.southwood@yahoo.com> <20140403083804.GB6991@mwanda>
Message-ID: <1396562710.31479.YahooMailNeo@web164006.mail.gq1.yahoo.com>
Date: Thu, 3 Apr 2014 15:05:10 -0700 (PDT)
From: Chase Southwood <chase.southwood@yahoo.com>
Reply-To: Chase Southwood <chase.southwood@yahoo.com>
Subject: Re: [PATCH v2] staging: comedi: s626: use comedi_timeout() on remaining loops
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "abbotti@mev.co.uk" <abbotti@mev.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20140403083804.GB6991@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>On Thursday, April 3, 2014 3:38 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:

>>On Tue, Mar 25, 2014 at 10:43:58PM -0500, Chase Southwood wrote:
>>There were just a handful of more while loops in this file that needed
>>timeouts, and this patch takes care of them.  One new callback is
>>introduced, and all of the proper comedi_timeout() calls are then used.
>>
>>Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
>>---
>>2: s626_i2c_handshake_eoc() can be used in s626_initialize() as noted by
>>Ian.  So, s626_initialize_eoc() has been removed, and its uses swapped
>>for s626_i2c_handshake_eoc().
>>
>> drivers/staging/comedi/drivers/s626.c | 34 ++++++++++++++++++++++++++--------
>> 1 file changed, 26 insertions(+), 8 deletions(-)
>>
>>diff --git a/drivers/staging/comedi/drivers/s626.c b/drivers/staging/comedi/drivers/s626.c
>>index 95fadf3..865cf93 100644
>>--- a/drivers/staging/comedi/drivers/s626.c
>>+++ b/drivers/staging/comedi/drivers/s626.c
>>@@ -295,10 +295,24 @@ static void s626_debi_replace(struct comedi_device *dev, unsigned int addr,
>> 
>> /* **************  EEPROM ACCESS FUNCTIONS  ************** */
>> 
>>+static int s626_i2c_handshake_eoc(struct comedi_device *dev,
>>+                 struct comedi_subdevice *s,
>>+                 struct comedi_insn *insn,
>>+                 unsigned long context)
>>+{
>>+    unsigned int status;
>
>This should probably be bool.
>

Oh, whoops...yeah s626_mc_test() definitely returns bool...I'll fix this up.

>>+
>>+    status = s626_mc_test(dev, S626_MC2_UPLD_IIC, S626_P_MC2);
>>+    if (status)
>>+        return 0;
>>+    return -EBUSY;
>>+}
>>+
>> static uint32_t s626_i2c_handshake(struct comedi_device *dev, uint32_t val)
>> {
>>     struct s626_private *devpriv = dev->private;
>>     unsigned int ctrl;
>>+    uint32_t ret;
>
>This should be int.  I get really suspicious when people start using
>uint32_t types.  Why does it have to be 32 bits?  Unsigned is wrong as
>well.

Yeah...I originally did that to conform to the current return type of the function,
not sure how I didn't manage to see that trying to return a negative error code as
an unsigned int is clearly a bug.  Sorry, I'll fix this up as well.

Thanks for the review, Dan.

Chase

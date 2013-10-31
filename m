Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750976Ab3JaEHp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 00:07:45 -0400
Received: from mailout.micron.com ([137.201.242.129]:23864 "EHLO
	mailout.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712Ab3JaEHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 00:07:43 -0400
From: =?utf-8?B?UWkgV2FuZyDnjovotbcgKHFpd2FuZyk=?= <qiwang@micron.com>
To: "dedekind1@gmail.com" <dedekind1@gmail.com>
CC: "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "Adrian Hunter" <adrian.hunter@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/1]  MTD: UBI:  try to avoid program data to NOR flash
 after erasure interrupted
Thread-Topic: [PATCH 1/1]  MTD: UBI:  try to avoid program data to NOR flash
 after erasure interrupted
Thread-Index: AQHO1LohJ4btsOLy+UGZvSz+R+JMF5oOJsqA
Date: Thu, 31 Oct 2013 04:07:10 +0000
Message-ID: <71CF8D7F32C5C24C9CD1D0E02D52498A770B220C@NTXXIAMBX02.xacn.micron.com>
References: <71CF8D7F32C5C24C9CD1D0E02D52498A77082AC5@NTXXIAMBX02.xacn.micron.com>
	 <71CF8D7F32C5C24C9CD1D0E02D52498A77082DDB@NTXXIAMBX02.xacn.micron.com>
	 <71CF8D7F32C5C24C9CD1D0E02D52498A770AED11@NTXXIAMBX02.xacn.micron.com>
	 <71CF8D7F32C5C24C9CD1D0E02D52498A770AED44@NTXXIAMBX02.xacn.micron.com>
	 <71CF8D7F32C5C24C9CD1D0E02D52498A770AED67@NTXXIAMBX02.xacn.micron.com>
	 <1382779164.5901.1.camel@karhu.quadriga.com>
	  <71CF8D7F32C5C24C9CD1D0E02D52498A770B1B97@NTXXIAMBX02.xacn.micron.com>
 <1383059901.29619.52.camel@sauron.fi.intel.com>
In-Reply-To: <1383059901.29619.52.camel@sauron.fi.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-hashedpuzzle: B6Of Dek1 NUJW O5fy Qdzs RZoI afK4 cTwH c4ML fZ4z gure
 i+xB jUjS l/wm plGm
 puFo;4;YQBkAHIAaQBhAG4ALgBoAHUAbgB0AGUAcgBAAGkAbgB0AGUAbAAuAGMAbwBtADsAZABlAGQAZQBrAGkAbgBkADEAQABnAG0AYQBpAGwALgBjAG8AbQA7AGwAaQBuAHUAeAAtAGsAZQByAG4AZQBsAEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcAOwBsAGkAbgB1AHgALQBtAHQAZABAAGwAaQBzAHQAcwAuAGkAbgBmAHIAYQBkAGUAYQBkAC4AbwByAGcA;Sosha1_v1;7;{7F9ECB1D-5C39-4D07-A0B8-93A3FD3F8DC1};cQBpAHcAYQBuAGcAQABtAGkAYwByAG8AbgAuAGMAbwBtAA==;Thu,
 31 Oct 2013 04:06:59
 GMT;UgBFADoAIABbAFAAQQBUAEMASAAgADEALwAxAF0AIAAgAE0AVABEADoAIABVAEIASQA6ACAAIAB0AHIAeQAgAHQAbwAgAGEAdgBvAGkAZAAgAHAAcgBvAGcAcgBhAG0AIABkAGEAdABhACAAdABvACAATgBPAFIAIABmAGwAYQBzAGgAIABhAGYAdABlAHIAIABlAHIAYQBzAHUAcgBlACAAaQBuAHQAZQByAHIAdQBwAHQAZQBkAA==
x-cr-puzzleid: {7F9ECB1D-5C39-4D07-A0B8-93A3FD3F8DC1}
x-originating-ip: [10.167.84.5]
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-7.000.1014-20258.004
X-TM-AS-Result: No--31.751200-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
x-mt-checkinternalsenderrule: True
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r9V487L8024600

On Tue, 2013-10-29 at 11:19 +0000, Artem Bityutskiy wrote:
> On Mon, 2013-10-28 at 04:54 +0000, Qi Wang ÁéãËµ∑ (qiwang) wrote:
> > On Sa, 2013-10-26 at 05:19 +0000, Artem Bityutskiy wrote:
> > > On Thu, 2013-10-10 at 08:28 +0000, Qi Wang ÁéãËµ∑ (qiwang) wrote:
> > > > But I want to say the potential risk is if low level driver program data to 
> > > > this block, it will get ‚Äútimeout error‚Äù. And the timeout period could be very 
> > > > long(almost several minutes), during this period, any operation on NOR flash 
> > > > cannot be accept. so program data to a erasure interrupted block isn‚Äôt a 
> > > > sensible action. in order to avoid program a erasure interrupted block, 
> > > > I suggest UBIFS can read this block before program data. the code changing as below:
> > > 
> > > Yes, reading first sounds like a good idea. Would you please send a
> > > patch implementing it?
> > 
> > From: Qi Wang <qiwang@micron.com>
> > 
> > nor_erase_prepare() will be called before erase a NOR flash, it will program '0'
> > into a block to mark this block. But program data into a erasure interrupted block
> > can cause program timtout(several minutes at most) error, could impact other 
> > operation on NOR flash. So UBIFS can read this block first to avoid unneeded 
> > program operation. 
> > 
> > This patch try to put read operation at at head of write operation in 
> > nor_erase_prepare(), read out the data. 
> > If the data is already corrupt, then no need to program any data into this block, 
> > just go to erase this block.
> > 
> > Signed-off-by: Qi Wang <qiwang@qiwang@micron.com>
> > ---
> > diff --git a/drivers/mtd/ubi/io.c b/drivers/mtd/ubi/io.c
> > index bf79def..be6ab56 100644
> > --- a/drivers/mtd/ubi/io.c
> > +++ b/drivers/mtd/ubi/io.c
> > @@ -509,26 +509,10 @@ static int nor_erase_prepare(struct ubi_device *ubi, int pnum)
> >  	struct ubi_vid_hdr vid_hdr;
> >  
> >  	/*
> > -	 * It is important to first invalidate the EC header, and then the VID
> > -	 * header. Otherwise a power cut may lead to valid EC header and
> > -	 * invalid VID header, in which case UBI will treat this PEB as
> > -	 * corrupted and will try to preserve it, and print scary warnings.
> > -	 */
> > -	addr = (loff_t)pnum * ubi->peb_size;
> > -	err = mtd_write(ubi->mtd, addr, 4, &written, (void *)&data);
> > -	if (!err) {
> > -		addr += ubi->vid_hdr_aloffset;
> > -		err = mtd_write(ubi->mtd, addr, 4, &written, (void *)&data);
> > -		if (!err)
> > -			return 0;
> > -	}
> 
> How about structuring the code this way:
> 
> if (EC header is good)
>      invalidate EC header()
> if (VID header is good)
>      invalidate VID header()
> 
> Then you'll handle the case when only one of the headers is already
> corrupted.
>
> -- 
> Best Regards,
> Artem Bityutskiy


Hi Artem:
Please check below patch. 

From: Qi Wang <qiwang@micron.com>

nor_erase_prepare() will be called before erase a NOR flash, it will program '0'
into a block to mark this block. But program data into a erasure interrupted block
can cause program timtout(several minutes at most) error, could impact other 
operation on NOR flash. So UBIFS can read this block first to avoid unneeded 
program operation. 
 
This patch try to put read operation at at head of write operation in 
nor_erase_prepare(), read out the data. 
If the data is already corrupt, then no need to program any data into this block, 
just go to erase this block.

Signed-off-by: Qi Wang <qiwang@qiwang@micron.com>
---
diff --git a/drivers/mtd/ubi/io.c b/drivers/mtd/ubi/io.c
index bf79def..0fdaca9 100644
--- a/drivers/mtd/ubi/io.c
+++ b/drivers/mtd/ubi/io.c
@@ -499,59 +499,44 @@ static int nor_erase_prepare(struct ubi_device *ubi, int pnum)
 	size_t written;
 	loff_t addr;
 	uint32_t data = 0;
-	/*
-	 * Note, we cannot generally define VID header buffers on stack,
-	 * because of the way we deal with these buffers (see the header
-	 * comment in this file). But we know this is a NOR-specific piece of
-	 * code, so we can do this. But yes, this is error-prone and we should
-	 * (pre-)allocate VID header buffer instead.
-	 */
 	struct ubi_vid_hdr vid_hdr;
+	struct ubi_ec_hdr ec_hdr;
+
+	addr = (loff_t)pnum * ubi->peb_size;
 
 	/*
+	 * If VID or EC is valid, need to corrupt it before erase operation.  
 	 * It is important to first invalidate the EC header, and then the VID
 	 * header. Otherwise a power cut may lead to valid EC header and
 	 * invalid VID header, in which case UBI will treat this PEB as
 	 * corrupted and will try to preserve it, and print scary warnings.
 	 */
-	addr = (loff_t)pnum * ubi->peb_size;
-	err = mtd_write(ubi->mtd, addr, 4, &written, (void *)&data);
-	if (!err) {
-		addr += ubi->vid_hdr_aloffset;
-		err = mtd_write(ubi->mtd, addr, 4, &written, (void *)&data);
-		if (!err)
-			return 0;
+	err = ubi_io_read_ec_hdr(ubi, pnum, &ec_hdr, 0);
+	if (err != UBI_IO_BAD_HDR_EBADMSG && err != UBI_IO_BAD_HDR &&
+	    err != UBI_IO_FF){
+		err1 = mtd_write(ubi->mtd, addr, 4, &written, (void *)&data);
+		if(err1)
+			goto error;
 	}
 
-	/*
-	 * We failed to write to the media. This was observed with Spansion
-	 * S29GL512N NOR flash. Most probably the previously eraseblock erasure
-	 * was interrupted at a very inappropriate moment, so it became
-	 * unwritable. In this case we probably anyway have garbage in this
-	 * PEB.
-	 */
-	err1 = ubi_io_read_vid_hdr(ubi, pnum, &vid_hdr, 0);
-	if (err1 == UBI_IO_BAD_HDR_EBADMSG || err1 == UBI_IO_BAD_HDR ||
-	    err1 == UBI_IO_FF) {
-		struct ubi_ec_hdr ec_hdr;
-
-		err1 = ubi_io_read_ec_hdr(ubi, pnum, &ec_hdr, 0);
-		if (err1 == UBI_IO_BAD_HDR_EBADMSG || err1 == UBI_IO_BAD_HDR ||
-		    err1 == UBI_IO_FF)
-			/*
-			 * Both VID and EC headers are corrupted, so we can
-			 * safely erase this PEB and not afraid that it will be
-			 * treated as a valid PEB in case of an unclean reboot.
-			 */
-			return 0;
+	err = ubi_io_read_vid_hdr(ubi, pnum, &vid_hdr, 0);
+	if (err != UBI_IO_BAD_HDR_EBADMSG && err != UBI_IO_BAD_HDR &&
+	    err != UBI_IO_FF){
+	    	addr += ubi->vid_hdr_aloffset;
+		err1 = mtd_write(ubi->mtd, addr, 4, &written, (void *)&data);
+		if (err1)
+			goto error;	
 	}
 
+	return 0;
+	
+error:
 	/*
-	 * The PEB contains a valid VID header, but we cannot invalidate it.
+	 * The PEB contains a valid VID or EC header, but we cannot invalidate it.
 	 * Supposedly the flash media or the driver is screwed up, so return an
 	 * error.
 	 */
-	ubi_err("cannot invalidate PEB %d, write returned %d read returned %d",
+	ubi_err("cannot invalidate PEB %d, read returned %d write returned %d ",
 		pnum, err, err1);
 	ubi_dump_flash(ubi, pnum, 0, ubi->peb_size);
 	return -EIO;
---

My Comments for above changing:
1. 
	-	/*
	-	 * Note, we cannot generally define VID header buffers on stack,
	-	 * because of the way we deal with these buffers (see the header
	-	 * comment in this file). But we know this is a NOR-specific piece of
	-	 * code, so we can do this. But yes, this is error-prone and we should
	-	 * (pre-)allocate VID header buffer instead.
	-	 */
	I remove above comment, because I pre-allocate VID header and EC header together. 
	So I think no need to emphasize VID header buffers cannot be on stack.
	(Maybe my understanding about this comment is error, if so, please correct me)

2.
	why use
	"if (err != UBI_IO_BAD_HDR_EBADMSG && err != UBI_IO_BAD_HDR && err != UBI_IO_FF)"
	but not 
	"if (!err)" 
	to judge if need to program '0' to invalid this block.

	In case err == UBI_IO_FF_BITFLIPS, err == UBI_IO_BITFLIPS or unexpected value return
	from read function, I think UBI still need to invalid this block for above mentioned 
	condition. So I use
	"if (err != UBI_IO_BAD_HDR_EBADMSG && err != UBI_IO_BAD_HDR && err != UBI_IO_FF)"
	to judge.  


Please make me known if my understanding isn't right. 
Thanks



ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751118Ab3JTJHN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 05:07:13 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:38978 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824Ab3JTJHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 05:07:10 -0400
Message-ID: <1382260018.11008.5.camel@fishsauce>
Subject: Re: [tpmdd-devel] TPM patches for 2.13
From: Ashley Lai <adlai@linux.vnet.ibm.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Ashley Lai <ashley@ashleylai.com>,
        Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, Rajiv Andrade <mail@srajiv.net>,
        tpmdd-devel@lists.sourceforge.net, Peter H?we <PeterHuewe@gmx.de>,
        Sirrix AG <tpmdd@sirrix.com>
Date: Sun, 20 Oct 2013 04:06:58 -0500
In-Reply-To: <20131017145724.GA6528@obsidianresearch.com>
References: <20131006193120.GA26137@obsidianresearch.com>
	 <20131017145724.GA6528@obsidianresearch.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13102009-1344-0000-0000-0000029AAC95
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-10-17 at 08:57 -0600, Jason Gunthorpe wrote:
> On Sun, Oct 06, 2013 at 01:31:20PM -0600, Jason Gunthorpe wrote:
> > I've prepared this branch:
> > 
> > https://github.com/jgunthorpe/linux/commits/for-tpm
> > dd783708a8c6fd713c784be68fcbcb7000c43c49
> > 
> > Jason Gunthorpe (11):
> >       tpm: ibmvtpm: Use %zd formatting for size_t format arguments
> >       tpm atmel: Call request_region with the correct base
> >       tpm: Store devname in the tpm_chip
> >       tpm: Use container_of to locate the tpm_chip in tpm_open
> >       tpm: Remove redundant dev_set_drvdata
> >       tpm: st33: Remove chip->data_buffer access from this driver
> >       tpm: Remove tpm_show_caps_1_2
> >       tpm: Rename tpm.c to tpm-interface.c
> >       tpm: Merge the tpm-bios module with tpm.o
> >       tpm: Add support for the Nuvoton NPCT501 I2C TPM
> >       tpm: Add support for Atmel I2C TPMs
> > 
> > Which contains the first half of the clean-up patches and my two
> > drivers. The cleanups are well ack'd now, and I've done quite a bit of
> > testing with the two drivers, so I'd like to see agreement that this
> > batch can move forward as a series, and the other patches can sit
> > ontop of this series.
> 
> Folks, the 3.13 merge window is fast approaching, any chance of
> advancing this work?
> 
> Jason

Hi Jason,
  Patch 0008-tpm-Rename-tpm.c-to-tpm-interface.c.patch does not meet the
Linux kernel's coding standards.  Please fix the errors found by
checkpatch.pl and let me know when it's ready.  Thanks.

ERROR: trailing whitespace
#54: FILE: drivers/char/tpm/tpm-interface.c:13:
+ * Specifications at www.trustedcomputinggroup.org^I $

ERROR: trailing whitespace
#60: FILE: drivers/char/tpm/tpm-interface.c:19:
+ * $

WARNING: unnecessary whitespace before a quoted newline
#415: FILE: drivers/char/tpm/tpm-interface.c:374:
+			"invalid count value %x %zx \n", count, bufsiz);

ERROR: do not use assignment in if condition
#421: FILE: drivers/char/tpm/tpm-interface.c:380:
+	if ((rc = chip->vendor.send(chip, (u8 *) buf, count)) < 0) {

ERROR: space required after that ',' (ctx:VxV)
#488: FILE: drivers/char/tpm/tpm-interface.c:447:
+	len = tpm_transmit(chip,(u8 *) cmd, len);
 	                       ^

ERROR: "foo * bar" should be "foo *bar"
#702: FILE: drivers/char/tpm/tpm-interface.c:661:
+ssize_t tpm_show_enabled(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#702: FILE: drivers/char/tpm/tpm-interface.c:661:
+ssize_t tpm_show_enabled(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#718: FILE: drivers/char/tpm/tpm-interface.c:677:
+ssize_t tpm_show_active(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#718: FILE: drivers/char/tpm/tpm-interface.c:677:
+ssize_t tpm_show_active(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#734: FILE: drivers/char/tpm/tpm-interface.c:693:
+ssize_t tpm_show_owned(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#734: FILE: drivers/char/tpm/tpm-interface.c:693:
+ssize_t tpm_show_owned(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#750: FILE: drivers/char/tpm/tpm-interface.c:709:
+ssize_t tpm_show_temp_deactivated(struct device * dev,

ERROR: "foo * bar" should be "foo *bar"
#751: FILE: drivers/char/tpm/tpm-interface.c:710:
+				struct device_attribute * attr, char *buf)

WARNING: please, no space before tabs
#813: FILE: drivers/char/tpm/tpm-interface.c:772:
+ * @chip_num: ^Itpm idx # or ANY$

WARNING: please, no space before tabs
#815: FILE: drivers/char/tpm/tpm-interface.c:774:
+ * @res_buf: ^ITPM_PCR value$

WARNING: please, no space before tabs
#816: FILE: drivers/char/tpm/tpm-interface.c:775:ERROR: trailing
whitespace
#54: FILE: drivers/char/tpm/tpm-interface.c:13:
+ * Specifications at www.trustedcomputinggroup.org^I $

ERROR: trailing whitespace
#60: FILE: drivers/char/tpm/tpm-interface.c:19:
+ * $

WARNING: unnecessary whitespace before a quoted newline
#415: FILE: drivers/char/tpm/tpm-interface.c:374:
+			"invalid count value %x %zx \n", count, bufsiz);

ERROR: do not use assignment in if condition
#421: FILE: drivers/char/tpm/tpm-interface.c:380:
+	if ((rc = chip->vendor.send(chip, (u8 *) buf, count)) < 0) {

ERROR: space required after that ',' (ctx:VxV)
#488: FILE: drivers/char/tpm/tpm-interface.c:447:
+	len = tpm_transmit(chip,(u8 *) cmd, len);
 	                       ^

ERROR: "foo * bar" should be "foo *bar"
#702: FILE: drivers/char/tpm/tpm-interface.c:661:
+ssize_t tpm_show_enabled(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#702: FILE: drivers/char/tpm/tpm-interface.c:661:
+ssize_t tpm_show_enabled(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#718: FILE: drivers/char/tpm/tpm-interface.c:677:
+ssize_t tpm_show_active(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#718: FILE: drivers/char/tpm/tpm-interface.c:677:
+ssize_t tpm_show_active(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#734: FILE: drivers/char/tpm/tpm-interface.c:693:
+ssize_t tpm_show_owned(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#734: FILE: drivers/char/tpm/tpm-interface.c:693:
+ssize_t tpm_show_owned(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#750: FILE: drivers/char/tpm/tpm-interface.c:709:
+ssize_t tpm_show_temp_deactivated(struct device * dev,

ERROR: "foo * bar" should be "foo *bar"
#751: FILE: drivers/char/tpm/tpm-interface.c:710:
+				struct device_attribute * attr, char *buf)

WARNING: please, no space before tabs
#813: FILE: drivers/char/tpm/tpm-interface.c:772:
+ * @chip_num: ^Itpm idx # or ANY$

WARNING: please, no space before tabs
#815: FILE: drivers/char/tpm/tpm-interface.c:774:
+ * @res_buf: ^ITPM_PCR value$

WARNING: please, no space before tabs
#816: FILE: drivers/char/tpm/tpm-interface.c:775:
+ * ^I^Isize of res_buf is 20 bytes (or NULL if you don't care)$

WARNING: please, no space before tabs
#838: FILE: drivers/char/tpm/tpm-interface.c:797:
+ * @chip_num: ^Itpm idx # or AN&$

WARNING: please, no space before tabs
#840: FILE: drivers/char/tpm/tpm-interface.c:799:
+ * @hash: ^Ihash value used to extend pcr value$

ERROR: code indent should use tabs where possible
#892: FILE: drivers/char/tpm/tpm-interface.c:851:
+^I                                     TPM_ORD_CONTINUE_SELFTEST);$

ERROR: trailing whitespace
#1009: FILE: drivers/char/tpm/tpm-interface.c:968:
+^I/* $

ERROR: trailing whitespace
#1014: FILE: drivers/char/tpm/tpm-interface.c:973:
+^I   parameters (RSA 12->bytes: keybit, #primes, expbit)  $

WARNING: line over 80 characters
#1136: FILE: drivers/char/tpm/tpm-interface.c:1095:
+static bool wait_for_tpm_stat_cond(struct tpm_chip *chip, u8 mask,
boolERROR: trailing whitespace
#54: FILE: drivers/char/tpm/tpm-interface.c:13:
+ * Specifications at www.trustedcomputinggroup.org^I $

ERROR: trailing whitespace
#60: FILE: drivers/char/tpm/tpm-interface.c:19:
+ * $

WARNING: unnecessary whitespace before a quoted newline
#415: FILE: drivers/char/tpm/tpm-interface.c:374:
+			"invalid count value %x %zx \n", count, bufsiz);

ERROR: do not use assignment in if condition
#421: FILE: drivers/char/tpm/tpm-interface.c:380:
+	if ((rc = chip->vendor.send(chip, (u8 *) buf, count)) < 0) {

ERROR: space required after that ',' (ctx:VxV)
#488: FILE: drivers/char/tpm/tpm-interface.c:447:
+	len = tpm_transmit(chip,(u8 *) cmd, len);
 	                       ^

ERROR: "foo * bar" should be "foo *bar"
#702: FILE: drivers/char/tpm/tpm-interface.c:661:
+ssize_t tpm_show_enabled(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#702: FILE: drivers/char/tpm/tpm-interface.c:661:
+ssize_t tpm_show_enabled(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#718: FILE: drivers/char/tpm/tpm-interface.c:677:
+ssize_t tpm_show_active(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#718: FILE: drivers/char/tpm/tpm-interface.c:677:
+ssize_t tpm_show_active(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#734: FILE: drivers/char/tpm/tpm-interface.c:693:
+ssize_t tpm_show_owned(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#734: FILE: drivers/char/tpm/tpm-interface.c:693:
+ssize_t tpm_show_owned(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#750: FILE: drivers/char/tpm/tpm-interface.c:709:
+ssize_t tpm_show_temp_deactivated(struct device * dev,

ERROR: "foo * bar" should be "foo *bar"
#751: FILE: drivers/char/tpm/tpm-interface.c:710:
+				struct device_attribute * attr, char *buf)

WARNING: please, no space before tabs
#813: FILE: drivers/char/tpm/tpm-interface.c:772:
+ * @chip_num: ^Itpm idx # or ANY$

WARNING: please, no space before tabs
#815: FILE: drivers/char/tpm/tpm-interface.c:774:
+ * @res_buf: ^ITPM_PCR value$

WARNING: please, no space before tabs
#816: FILE: drivers/char/tpm/tpm-interface.c:775:
+ * ^I^Isize of res_buf is 20 bytes (or NULL if you don't care)$

WARNING: please, no space before tabs
#838: FILE: drivers/char/tpm/tpm-interface.c:797:
+ * @chip_num: ^Itpm idx # or AN&$

WARNING: please, no space before tabs
#840: FILE: drivers/char/tpm/tpm-interface.c:799:
+ * @hash: ^Ihash value used to extend pcr value$

ERROR: code indent should use tabs where possible
#892: FILE: drivers/char/tpm/tpm-interface.c:851:
+^I                                     TPM_ORD_CONTINUE_SELFTEST);$

ERROR: trailing whitespace
#1009: FILE: drivers/char/tpm/tpm-interface.c:968:
+^I/* $

ERROR: trailing whitespace
#1014: FILE: drivers/char/tpm/tpm-interface.c:973:
+^I   parameters (RSA 12->bytes: keybit, #primes, expbit)  $

WARNING: line over 80 characters
#1136: FILE: drivers/char/tpm/tpm-interface.c:1095:
+static bool wait_for_tpm_stat_cond(struct tpm_chip *chip, u8 mask, bool
check_cancel,

ERROR: trailing whitespace
#1507: FILE: drivers/char/tpm/tpm-interface.c:1466:
+ * Called from tpm_<specific>.c probe function only for devices $

total: 16 errors, 7 warnings, 1562 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch
or
      scripts/cleanfile

./0008-tpm-Rename-tpm.c-to-tpm-interface.c.patch has style problems,
please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.
 check_cancel,

ERROR: trailing whitespace
#1507: FILE: drivers/char/tpm/tpm-interface.c:1466:
+ * Called from tpm_<specific>.c probe function only for devices $

total: 16 errors, 7 warnings, 1562 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch
or
      scripts/cleanfile

./0008-tpm-Rename-tpm.c-to-tpm-interface.c.patch has style problems,
please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

+ * ^I^Isize of res_buf is 20 bytes (or NULL if you don't care)$
ERROR: trailing whitespace
#54: FILE: drivers/char/tpm/tpm-interface.c:13:
+ * Specifications at www.trustedcomputinggroup.org^I $

ERROR: trailing whitespace
#60: FILE: drivers/char/tpm/tpm-interface.c:19:
+ * $

WARNING: unnecessary whitespace before a quoted newline
#415: FILE: drivers/char/tpm/tpm-interface.c:374:
+			"invalid count value %x %zx \n", count, bufsiz);

ERROR: do not use assignment in if condition
#421: FILE: drivers/char/tpm/tpm-interface.c:380:
+	if ((rc = chip->vendor.send(chip, (u8 *) buf, count)) < 0) {
ERROR: trailing whitespace
#54: FILE: drivers/char/tpm/tpm-interface.c:13:
+ * Specifications at www.trustedcomputinggroup.org^I $

ERROR: trailing whitespace
#60: FILE: drivers/char/tpm/tpm-interface.c:19:
+ * $

WARNING: unnecessary whitespace before a quoted newline
#415: FILE: drivers/char/tpm/tpm-interface.c:374:
+			"invalid count value %x %zx \n", count, bufsiz);

ERROR: do not use assignment in if condition
#421: FILE: drivers/char/tpm/tpm-interface.c:380:
+	if ((rc = chip->vendor.send(chip, (u8 *) buf, count)) < 0) {

ERROR: space required after that ',' (ctx:VxV)
#488: FILE: drivers/char/tpm/tpm-interface.c:447:
+	len = tpm_transmit(chip,(u8 *) cmd, len);
 	                       ^

ERROR: "foo * bar" should be "foo *bar"
#702: FILE: drivers/char/tpm/tpm-interface.c:661:
+ssize_t tpm_show_enabled(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#702: FILE: drivers/char/tpm/tpm-interface.c:661:
+ssize_t tpm_show_enabled(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#718: FILE: drivers/char/tpm/tpm-interface.c:677:
+ssize_t tpm_show_active(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#718: FILE: drivers/char/tpm/tpm-interface.c:677:
+ssize_t tpm_show_active(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#734: FILE: drivers/char/tpm/tpm-interface.c:693:
+ssize_t tpm_show_owned(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#734: FILE: drivers/char/tpm/tpm-interface.c:693:
+ssize_t tpm_show_owned(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#750: FILE: drivers/char/tpm/tpm-interface.c:709:
+ssize_t tpm_show_temp_deactivated(struct device * dev,

ERROR: "foo * bar" should be "foo *bar"
#751: FILE: drivers/char/tpm/tpm-interface.c:710:
+				struct device_attribute * attr, char *buf)

WARNING: please, no space before tabs
#813: FILE: drivers/char/tpm/tpm-interface.c:772:
+ * @chip_num: ^Itpm idx # or ANY$

WARNING: please, no space before tabs
#815: FILE: drivers/char/tpm/tpm-interface.c:774:
+ * @res_buf: ^ITPM_PCR value$

WARNING: please, no space before tabs
#816: FILE: drivers/char/tpm/tpm-interface.c:775:
+ * ^I^Isize of res_buf is 20 bytes (or NULL if you don't care)$

WARNING: please, no space before tabs
#838: FILE: drivers/char/tpm/tpm-interface.c:797:
+ * @chip_num: ^Itpm idx # or AN&$

WARNING: please, no space before tabs
#840: FILE: drivers/char/tpm/tpm-interface.c:799:
+ * @hash: ^Ihash value used to extend pcr value$

ERROR: code indent should use tabs where possible
#892: FILE: drivers/char/tpm/tpm-interface.c:851:
+^I                                     TPM_ORD_CONTINUE_SELFTEST);$

ERROR: trailing whitespace
#1009: FILE: drivers/char/tpm/tpm-interface.c:968:
+^I/* $

ERROR: trailing whitespace
#1014: FILE: drivers/char/tpm/tpm-interface.c:973:
+^I   parameters (RSA 12->bytes: keybit, #primes, expbit)  $

WARNING: line over 80 characters
#1136: FILE: drivers/char/tpm/tpm-interface.c:1095:
+static bool wait_for_tpm_stat_cond(struct tpm_chip *chip, u8 mask, bool
check_cancel,

ERROR: trailing whitespace
#1507: FILE: drivers/char/tpm/tpm-interface.c:1466:
+ * Called from tpm_<specific>.c probe function only for devices $

total: 16 errors, 7 warnings, 1562 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch
or
      scripts/cleanfile

./0008-tpm-Rename-tpm.c-to-tpm-interface.c.patch has style problems,
please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

ERROR: space required after that ',' (ctx:VxV)
#488: FILE: drivers/char/tpm/tpm-interface.c:447:
+	len = tpm_transmit(chip,(u8 *) cmd, len);
 	                       ^

ERROR: "foo * bar" should be "foo *bar"
#702: FILE: drivers/char/tpm/tpm-interface.c:661:
+ssize_t tpm_show_enabled(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#702: FILE: drivers/char/tpm/tpm-interface.c:661:
+ssize_t tpm_show_enabled(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#718: FILE: drivers/char/tpm/tpm-interface.c:677:
+ssize_t tpm_show_active(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#718: FILE: drivers/char/tpm/tpm-interface.c:677:
+ssize_t tpm_show_active(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#734: FILE: drivers/char/tpm/tpm-interface.c:693:
+ssize_t tpm_show_owned(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#734: FILE: drivers/char/tpm/tpm-interface.c:693:
+ssize_t tpm_show_owned(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#750: FILE: drivers/char/tpm/tpm-interface.c:709:
+ssize_t tpm_show_temp_deactivated(struct device * dev,

ERROR: "foo * bar" should be "foo *bar"
#751: FILE: drivers/char/tpm/tpm-interface.c:710:
+				struct device_attribute * attr, char *buf)

WARNING: please, no space before tabs
#813: FILE: drivers/char/tpm/tpm-interface.c:772:
+ * @chip_num: ^Itpm idx # or ANY$

WARNING: please, no space before tabs
#815: FILE: drivers/char/tpm/tpm-interface.c:774:
+ * @res_buf: ^ITPM_PCR value$

WARNING: please, no space before tabs
#816: FILE: drivers/char/tpm/tpm-interface.c:775:
+ * ^I^Isize of res_buf is 20 bytes (or NULL if you don't care)$

WARNING: please, no space before tabs
#838: FILE: drivers/char/tpm/tpm-interface.c:797:
+ * @chip_num: ^Itpm idx # or AN&$

WARNING: please, no space before tabs
#840: FILE: drivers/char/tpm/tpm-interface.c:799:
+ * @hash: ^Ihash value used to extend pcr value$

ERROR: code indent should use tabs where possible
#892: FILE: drivers/char/tpm/tpm-interface.c:851:
+^I                                     TPM_ORD_CONTINUE_SELFTEST);$

ERROR: trailing whitespace
#1009: FILE: drivers/char/tpm/tpm-interface.c:968:
+^I/* $

ERROR: trailing whitespace
#1014: FILE: drivers/char/tpm/tpm-interface.c:973:ERROR: trailing
whitespace
#54: FILE: drivers/char/tpm/tpm-interface.c:13:
+ * Specifications at www.trustedcomputinggroup.org^I $

ERROR: trailing whitespace
#60: FILE: drivers/char/tpm/tpm-interface.c:19:
+ * $

WARNING: unnecessary whitespace before a quoted newline
#415: FILE: drivers/char/tpm/tpm-interface.c:374:
+			"invalid count value %x %zx \n", count, bufsiz);

ERROR: do not use assignment in if condition
#421: FILE: drivers/char/tpm/tpm-interface.c:380:
+	if ((rc = chip->vendor.send(chip, (u8 *) buf, count)) < 0) {

ERROR: space required after that ',' (ctx:VxV)
#488: FILE: drivers/char/tpm/tpm-interface.c:447:
+	len = tpm_transmit(chip,(u8 *) cmd, len);
 	                       ^

ERROR: "foo * bar" should be "foo *bar"
#702: FILE: drivers/char/tpm/tpm-interface.c:661:
+ssize_t tpm_show_enabled(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#702: FILE: drivers/char/tpm/tpm-interface.c:661:
+ssize_t tpm_show_enabled(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#718: FILE: drivers/char/tpm/tpm-interface.c:677:
+ssize_t tpm_show_active(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#718: FILE: drivers/char/tpm/tpm-interface.c:677:
+ssize_t tpm_show_active(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#734: FILE: drivers/char/tpm/tpm-interface.c:693:
+ssize_t tpm_show_owned(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#734: FILE: drivers/char/tpm/tpm-interface.c:693:
+ssize_t tpm_show_owned(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#750: FILE: drivers/char/tpm/tpm-interface.c:709:
+ssize_t tpm_show_temp_deactivated(struct device * dev,

ERROR: "foo * bar" should be "foo *bar"
#751: FILE: drivers/char/tpm/tpm-interface.c:710:
+				struct device_attribute * attr, char *buf)

WARNING: please, no space before tabs
#813: FILE: drivers/char/tpm/tpm-interface.c:772:
+ * @chip_num: ^Itpm idx # or ANY$

WARNING: please, no space before tabs
#815: FILE: drivers/char/tpm/tpm-interface.c:774:
+ * @res_buf: ^ITPM_PCR value$

WARNING: please, no space before tabs
#816: FILE: drivers/char/tpm/tpm-interface.c:775:
+ * ^I^Isize of res_buf is 20 bytes (or NULL if you don't care)$

WARNING: please, no space before tabs
#838: FILE: drivers/char/tpm/tpm-interface.c:797:
+ * @chip_num: ^Itpm idx # or AN&$

WARNING: please, no space before tabs
#840: FILE: drivers/char/tpm/tpm-interface.c:799:
+ * @hash: ^Ihash value used to extend pcr value$

ERROR: code indent should use tabs where possible
#892: FILE: drivers/char/tpm/tpm-interface.c:851:
+^I                                     TPM_ORD_CONTINUE_SELFTEST);$

ERROR: trailing whitespace
#1009: FILE: drivers/char/tpm/tpm-interface.c:968:
+^I/* $

ERROR: trailing whitespace
#1014: FILE: drivers/char/tpm/tpm-interface.c:973:
+^I   parameters (RSA 12->bytes: keybit, #primes, expbit)  $

WARNING: line over 80 characters
#1136: FILE: drivers/char/tpm/tpm-interface.c:1095:
+static bool wait_for_tpm_stat_cond(struct tpm_chip *chip, u8 mask, bool
check_cancel,

ERROR: trailing whitespace
#1507: FILE: drivers/char/tpm/tpm-interface.c:1466:
+ * Called from tpm_<specific>.c probe function only for devices $

total: 16 errors, 7 warnings, 1562 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch
or
      scripts/cleanfile

./0008-tpm-Rename-tpm.c-to-tpm-interface.c.patch has style problems,
please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

+^I   parameters (RSA 12->bytes: keybit, #primes, expbit)  $

WARNING: line over 80 characters
#1136: FILE: drivers/char/tpm/tpm-interface.c:1095:
+static bool wait_for_tpm_stat_cond(struct tpm_chip *chip, u8 mask, bool
check_cancel,

ERROR: trailing whitespace
#1507: FILE: drivers/char/tpm/tpm-interface.c:1466:
+ * Called from tpm_<specific>.c probe function only for devices $

total: 16 errors, 7 warnings, 1562 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch
or
      scripts/cleanfile

./0008-tpm-Rename-tpm.c-to-tpm-interface.c.patch has style problems,
please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

WARNING: please, no space before tabs
#838: FILE: drivers/char/tpm/tpm-interface.c:797:
+ * @chip_num: ^Itpm idx # or AN&$

WARNING: please, no space before tabs
#840: FILE: drivers/char/tpm/tpm-interface.c:799:
+ * @hash: ^Ihash value used to extend pcr value$

ERROR: code indent should use tabs where possible
#892: FILE: drivers/char/tpm/tpm-interface.c:851:
+^I                                     TPM_ORD_CONTINUE_SELFTEST);$

ERROR: trailing whitespace
#1009: FILE: drivers/char/tpm/tpm-interface.c:968:
+^I/* $

ERROR: trailing whitespace
#1014: FILE: drivers/char/tpm/tpm-interface.c:973:
+^I   parameters (RSA 12->bytes: keybit, #primes, expbit)  $

WARNING: line over 80 characters
#1136: FILE: drivers/char/tpm/tpm-interface.c:1095:
+static bool wait_for_tpm_stat_cond(struct tpm_chip *chip, u8 mask, bool
check_cancel,

ERROR: trailing whitespace
#1507: FILE: drivers/char/tpm/tpm-interface.c:1466:
+ * Called from tpm_<specific>.c probe function only for devices $

total: 16 errors, 7 warnings, 1562 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch
orERROR: trailing whitespace
#54: FILE: drivers/char/tpm/tpm-interface.c:13:
+ * Specifications at www.trustedcomputinggroup.org^I $

ERROR: trailing whitespace
#60: FILE: drivers/char/tpm/tpm-interface.c:19:
+ * $

WARNING: unnecessary whitespace before a quoted newline
#415: FILE: drivers/char/tpm/tpm-interface.c:374:
+			"invalid count value %x %zx \n", count, bufsiz);

ERROR: do not use assignment in if condition
#421: FILE: drivers/char/tpm/tpm-interface.c:380:
+	if ((rc = chip->vendor.send(chip, (u8 *) buf, count)) < 0) {

ERROR: space required after that ',' (ctx:VxV)
#488: FILE: drivers/char/tpm/tpm-interface.c:447:
+	len = tpm_transmit(chip,(u8 *) cmd, len);
 	                       ^

ERROR: "foo * bar" should be "foo *bar"
#702: FILE: drivers/char/tpm/tpm-interface.c:661:
+ssize_t tpm_show_enabled(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#702: FILE: drivers/char/tpm/tpm-interface.c:661:
+ssize_t tpm_show_enabled(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#718: FILE: drivers/char/tpm/tpm-interface.c:677:
+ssize_t tpm_show_active(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#718: FILE: drivers/char/tpm/tpm-interface.c:677:
+ssize_t tpm_show_active(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#734: FILE: drivers/char/tpm/tpm-interface.c:693:
+ssize_t tpm_show_owned(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#734: FILE: drivers/char/tpm/tpm-interface.c:693:
+ssize_t tpm_show_owned(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#750: FILE: drivers/char/tpm/tpm-interface.c:709:
+ssize_t tpm_show_temp_deactivated(struct device * dev,

ERROR: "foo * bar" should be "foo *bar"
#751: FILE: drivers/char/tpm/tpm-interface.c:710:
+				struct device_attribute * attr, char *buf)

WARNING: please, no space before tabs
#813: FILE: drivers/char/tpm/tpm-interface.c:772:
+ * @chip_num: ^Itpm idx # or ANY$

WARNING: please, no space before tabs
#815: FILE: drivers/char/tpm/tpm-interface.c:774:
+ * @res_buf: ^ITPM_PCR value$

WARNING: please, no space before tabs
#816: FILE: drivers/char/tpm/tpm-interface.c:775:
+ * ^I^Isize of res_buf is 20 bytes (or NULL if you don't care)$

WARNING: please, no space before tabs
#838: FILE: drivers/char/tpm/tpm-interface.c:797:
+ * @chip_num: ^Itpm idx # or AN&$

WARNING: please, no space before tabs
#840: FILE: drivers/char/tpm/tpm-interface.c:799:
+ * @hash: ^Ihash value used to extend pcr value$

ERROR: code indent should use tabs where possible
#892: FILE: drivers/char/tpm/tpm-interface.c:851:
+^I                                     TPM_ORD_CONTINUE_SELFTEST);$

ERROR: trailing whitespace
#1009: FILE: drivers/char/tpm/tpm-interface.c:968:
+^I/* $

ERROR: trailing whitespace
#1014: FILE: drivers/char/tpm/tpm-interface.c:973:
+^I   parameters (RSA 12->bytes: keybit, #primes, expbit)  $

WARNING: line over 80 characters
#1136: FILE: drivers/char/tpm/tpm-interface.c:1095:
+static bool wait_for_tpm_stat_cond(struct tpm_chip *chip, u8 mask, bool
check_cancel,

ERROR: trailing whitespace
#1507: FILE: drivers/char/tpm/tpm-interface.c:1466:
+ * Called from tpm_<specific>.c probe function only for devices $

total: 16 errors, 7 warnings, 1562 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch
or
      scripts/cleanfile

./0008-tpm-Rename-tpm.c-to-tpm-interface.c.patch has style problems,
please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.ERROR: trailing
whitespace
#54: FILE: drivers/char/tpm/tpm-interface.c:13:
+ * Specifications at www.trustedcomputinggroup.org^I $

ERROR: trailing whitespace
#60: FILE: drivers/char/tpm/tpm-interface.c:19:
+ * $

WARNING: unnecessary whitespace before a quoted newline
#415: FILE: drivers/char/tpm/tpm-interface.c:374:
+			"invalid count value %x %zx \n", count, bufsiz);

ERROR: do not use assignment in if condition
#421: FILE: drivers/char/tpm/tpm-interface.c:380:
+	if ((rc = chip->vendor.send(chip, (u8 *) buf, count)) < 0) {

ERROR: space required after that ',' (ctx:VxV)
#488: FILE: drivers/char/tpm/tpm-interface.c:447:
+	len = tpm_transmit(chip,(u8 *) cmd, len);
 	                       ^

ERROR: "foo * bar" should be "foo *bar"
#702: FILE: drivers/char/tpm/tpm-interface.c:661:
+ssize_t tpm_show_enabled(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#702: FILE: drivers/char/tpm/tpm-interface.c:661:
+ssize_t tpm_show_enabled(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#718: FILE: drivers/char/tpm/tpm-interface.c:677:
+ssize_t tpm_show_active(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#718: FILE: drivers/char/tpm/tpm-interface.c:677:
+ssize_t tpm_show_active(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#734: FILE: drivers/char/tpm/tpm-interface.c:693:
+ssize_t tpm_show_owned(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#734: FILE: drivers/char/tpm/tpm-interface.c:693:
+ssize_t tpm_show_owned(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#750: FILE: drivers/char/tpm/tpm-interface.c:709:
+ssize_t tpm_show_temp_deactivated(struct device * dev,

ERROR: "foo * bar" should be "foo *bar"
#751: FILE: drivers/char/tpm/tpm-interface.c:710:
+				struct device_attribute * attr, char *buf)

WARNING: please, no space before tabs
#813: FILE: drivers/char/tpm/tpm-interface.c:772:
+ * @chip_num: ^Itpm idx # or ANY$

WARNING: please, no space before tabs
#815: FILE: drivers/char/tpm/tpm-interface.c:774:
+ * @res_buf: ^ITPM_PCR value$

WARNING: please, no space before tabs
#816: FILE: drivers/char/tpm/tpm-interface.c:775:
+ * ^I^Isize of res_buf is 20 bytes (or NULL if you don't care)$

WARNING: please, no space before tabs
#838: FILE: drivers/char/tpm/tpm-interface.c:797:
+ * @chip_num: ^Itpm idx # or AN&$

WARNING: please, no space before tabs
#840: FILE: drivers/char/tpm/tpm-interface.c:799:
+ * @hash: ^Ihash value used to extend pcr value$

ERROR: code indent should use tabs where possible
#892: FILE: drivers/char/tpm/tpm-interface.c:851:
+^I                                     TPM_ORD_CONTINUE_SELFTEST);$

ERROR: trailing whitespace
#1009: FILE: drivers/char/tpm/tpm-interface.c:968:
+^I/* $

ERROR: trailing whitespace
#1014: FILE: drivers/char/tpm/tpm-interface.c:973:
+^I   parameters (RSA 12->bytes: keybit, #primes, expbit)  $ERROR:
trailing whitespace
#54: FILE: drivers/char/tpm/tpm-interface.c:13:
+ * Specifications at www.trustedcomputinggroup.org^I $

ERROR: trailing whitespace
#60: FILE: drivers/char/tpm/tpm-interface.c:19:
+ * $

WARNING: unnecessary whitespace before a quoted newline
#415: FILE: drivers/char/tpm/tpm-interface.c:374:
+			"invalid count value %x %zx \n", count, bufsiz);

ERROR: do not use assignment in if condition
#421: FILE: drivers/char/tpm/tpm-interface.c:380:
+	if ((rc = chip->vendor.send(chip, (u8 *) buf, count)) < 0) {

ERROR: space required after that ',' (ctx:VxV)
#488: FILE: drivers/char/tpm/tpm-interface.c:447:
+	len = tpm_transmit(chip,(u8 *) cmd, len);
 	                       ^

ERROR: "foo * bar" should be "foo *bar"
#702: FILE: drivers/char/tpm/tpm-interface.c:661:
+ssize_t tpm_show_enabled(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#702: FILE: drivers/char/tpm/tpm-interface.c:661:
+ssize_t tpm_show_enabled(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#718: FILE: drivers/char/tpm/tpm-interface.c:677:
+ssize_t tpm_show_active(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#718: FILE: drivers/char/tpm/tpm-interface.c:677:
+ssize_t tpm_show_active(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#734: FILE: drivers/char/tpm/tpm-interface.c:693:ERROR: trailing
whitespace
#54: FILE: drivers/char/tpm/tpm-interface.c:13:
+ * Specifications at www.trustedcomputinggroup.org^I $

ERROR: trailing whitespace
#60: FILE: drivers/char/tpm/tpm-interface.c:19:
+ * $

WARNING: unnecessary whitespace before a quoted newline
#415: FILE: drivers/char/tpm/tpm-interface.c:374:
+			"invalid count value %x %zx \n", count, bufsiz);

ERROR: do not use assignment in if condition
#421: FILE: drivers/char/tpm/tpm-interface.c:380:
+	if ((rc = chip->vendor.send(chip, (u8 *) buf, count)) < 0) {

ERROR: space required after that ',' (ctx:VxV)
#488: FILE: drivers/char/tpm/tpm-interface.c:447:
+	len = tpm_transmit(chip,(u8 *) cmd, len);
 	                       ^

ERROR: "foo * bar" should be "foo *bar"
#702: FILE: drivers/char/tpm/tpm-interface.c:661:
+ssize_t tpm_show_enabled(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#702: FILE: drivers/char/tpm/tpm-interface.c:661:
+ssize_t tpm_show_enabled(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#718: FILE: drivers/char/tpm/tpm-interface.c:677:
+ssize_t tpm_show_active(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#718: FILE: drivers/char/tpm/tpm-interface.c:677:
+ssize_t tpm_show_active(struct device * dev, struct device_attribute *
attr,ERROR: trailing whitespace
#54: FILE: drivers/char/tpm/tpm-interface.c:13:
+ * Specifications at www.trustedcomputinggroup.org^I $

ERROR: trailing whitespace
#60: FILE: drivers/char/tpm/tpm-interface.c:19:
+ * $

WARNING: unnecessary whitespace before a quoted newline
#415: FILE: drivers/char/tpm/tpm-interface.c:374:
+			"invalid count value %x %zx \n", count, bufsiz);

ERROR: do not use assignment in if condition
#421: FILE: drivers/char/tpm/tpm-interface.c:380:
+	if ((rc = chip->vendor.send(chip, (u8 *) buf, count)) < 0) {

ERROR: space required after that ',' (ctx:VxV)
#488: FILE: drivers/char/tpm/tpm-interface.c:447:
+	len = tpm_transmit(chip,(u8 *) cmd, len);
 	                       ^

ERROR: "foo * bar" should be "foo *bar"
#702: FILE: drivers/char/tpm/tpm-interface.c:661:
+ssize_t tpm_show_enabled(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#702: FILE: drivers/char/tpm/tpm-interface.c:661:
+ssize_t tpm_show_enabled(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#718: FILE: drivers/char/tpm/tpm-interface.c:677:
+ssize_t tpm_show_active(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#718: FILE: drivers/char/tpm/tpm-interface.c:677:
+ssize_t tpm_show_active(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#734: FILE: drivers/char/tpm/tpm-interface.c:693:
+ssize_t tpm_show_owned(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#734: FILE: drivers/char/tpm/tpm-interface.c:693:
+ssize_t tpm_show_owned(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#750: FILE: drivers/char/tpm/tpm-interface.c:709:
+ssize_t tpm_show_temp_deactivated(struct device * dev,

ERROR: "foo * bar" should be "foo *bar"
#751: FILE: drivers/char/tpm/tpm-interface.c:710:
+				struct device_attribute * attr, char *buf)

WARNING: please, no space before tabs
#813: FILE: drivers/char/tpm/tpm-interface.c:772:
+ * @chip_num: ^Itpm idx # or ANY$ERROR: trailing whitespace
#54: FILE: drivers/char/tpm/tpm-interface.c:13:ERROR: trailing
whitespace
#54: FILE: drivers/char/tpm/tpm-interface.c:13:
+ * Specifications at www.trustedcomputinggroup.org^I $

ERROR: trailing whitespace
#60: FILE: drivers/char/tpm/tpm-interface.c:19:
+ * $

WARNING: unnecessary whitespace before a quoted newline
#415: FILE: drivers/char/tpm/tpm-interface.c:374:
+			"invalid count value %x %zx \n", count, bufsiz);

ERROR: do not use assignment in if condition
#421: FILE: drivers/char/tpm/tpm-interface.c:380:
+	if ((rc = chip->vendor.send(chip, (u8 *) buf, count)) < 0) {

ERROR: space required after that ',' (ctx:VxV)
#488: FILE: drivers/char/tpm/tpm-interface.c:447:
+	len = tpm_transmit(chip,(u8 *) cmd, len);
 	                       ^

ERROR: "foo * bar" should be "foo *bar"
#702: FILE: drivers/char/tpm/tpm-interface.c:661:
+ssize_t tpm_show_enabled(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#702: FILE: drivers/char/tpm/tpm-interface.c:661:
+ssize_t tpm_show_enabled(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#718: FILE: drivers/char/tpm/tpm-interface.c:677:
+ssize_t tpm_show_active(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#718: FILE: drivers/char/tpm/tpm-interface.c:677:
+ssize_t tpm_show_active(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#734: FILE: drivers/char/tpm/tpm-interface.c:693:
+ssize_t tpm_show_owned(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#734: FILE: drivers/char/tpm/tpm-interface.c:693:
+ssize_t tpm_show_owned(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#750: FILE: drivers/char/tpm/tpm-interface.c:709:
+ssize_t tpm_show_temp_deactivated(struct device * dev,

ERROR: "foo * bar" should be "foo *bar"
#751: FILE: drivers/char/tpm/tpm-interface.c:710:
+				struct device_attribute * attr, char *buf)

WARNING: please, no space before tabs
#813: FILE: drivers/char/tpm/tpm-interface.c:772:
+ * @chip_num: ^Itpm idx # or ANY$

WARNING: please, no space before tabs
#815: FILE: drivers/char/tpm/tpm-interface.c:774:
+ * @res_buf: ^ITPM_PCR value$

WARNING: please, no space before tabs
#816: FILE: drivers/char/tpm/tpm-interface.c:775:
+ * ^I^Isize of res_buf is 20 bytes (or NULL if you don't care)$

WARNING: please, no space before tabs
#838: FILE: drivers/char/tpm/tpm-interface.c:797:
+ * @chip_num: ^Itpm idx # or AN&$

WARNING: please, no space before tabs
#840: FILE: drivers/char/tpm/tpm-interface.c:799:
+ * @hash: ^Ihash value used to extend pcr value$

ERROR: code indent should use tabs where possible
#892: FILE: drivers/char/tpm/tpm-interface.c:851:
+^I                                     TPM_ORD_CONTINUE_SELFTEST);$

ERROR: trailing whitespace
#1009: FILE: drivers/char/tpm/tpm-interface.c:968:
+^I/* $

ERROR: trailing whitespace
#1014: FILE: drivers/char/tpm/tpm-interface.c:973:
+^I   parameters (RSA 12->bytes: keybit, #primes, expbit)  $

WARNING: line over 80 characters
#1136: FILE: drivers/char/tpm/tpm-interface.c:1095:ERROR: trailing
whitespace
#54: FILE: drivers/char/tpm/tpm-interface.c:13:
+ * Specifications at www.trustedcomputinggroup.org^I $

ERROR: trailing whitespace
#60: FILE: drivers/char/tpm/tpm-interface.c:19:
+ * $

WARNING: unnecessary whitespace before a quoted newline
#415: FILE: drivers/char/tpm/tpm-interface.c:374:
+			"invalid count value %x %zx \n", count, bufsiz);

ERROR: do not use assignment in if condition
#421: FILE: drivers/char/tpm/tpm-interface.c:380:
+	if ((rc = chip->vendor.send(chip, (u8 *) buf, count)) < 0) {

ERROR: space required after that ',' (ctx:VxV)
#488: FILE: drivers/char/tpm/tpm-interface.c:447:
+	len = tpm_transmit(chip,(u8 *) cmd, len);
 	                       ^

ERROR: "foo * bar" should be "foo *bar"
#702: FILE: drivers/char/tpm/tpm-interface.c:661:
+ssize_t tpm_show_enabled(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#702: FILE: drivers/char/tpm/tpm-interface.c:661:
+ssize_t tpm_show_enabled(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#718: FILE: drivers/char/tpm/tpm-interface.c:677:
+ssize_t tpm_show_active(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#718: FILE: drivers/char/tpm/tpm-interface.c:677:
+ssize_t tpm_show_active(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#734: FILE: drivers/char/tpm/tpm-interface.c:693:
+ssize_t tpm_show_owned(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#734: FILE: drivers/char/tpm/tpm-interface.c:693:
+ssize_t tpm_show_owned(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#750: FILE: drivers/char/tpm/tpm-interface.c:709:
+ssize_t tpm_show_temp_deactivated(struct device * dev,

ERROR: "foo * bar" should be "foo *bar"
#751: FILE: drivers/char/tpm/tpm-interface.c:710:
+				struct device_attribute * attr, char *buf)

WARNING: please, no space before tabs
#813: FILE: drivers/char/tpm/tpm-interface.c:772:
+ * @chip_num: ^Itpm idx # or ANY$

WARNING: please, no space before tabs
#815: FILE: drivers/char/tpm/tpm-interface.c:774:
+ * @res_buf: ^ITPM_PCR value$

WARNING: please, no space before tabs
#816: FILE: drivers/char/tpm/tpm-interface.c:775:
+ * ^I^Isize of res_buf is 20 bytes (or NULL if you don't care)$

WARNING: please, no space before tabs
#838: FILE: drivers/char/tpm/tpm-interface.c:797:
+ * @chip_num: ^Itpm idx # or AN&$

WARNING: please, no space before tabs
#840: FILE: drivers/char/tpm/tpm-interface.c:799:
+ * @hash: ^Ihash value used to extend pcr value$

ERROR: code indent should use tabs where possible
#892: FILE: drivers/char/tpm/tpm-interface.c:851:
+^I                                     TPM_ORD_CONTINUE_SELFTEST);$

ERROR: trailing whitespace
#1009: FILE: drivers/char/tpm/tpm-interface.c:968:
+^I/* $
ERROR: trailing whitespace
#54: FILE: drivers/char/tpm/tpm-interface.c:13:
+ * Specifications at www.trustedcomputinggroup.org^I $

ERROR: trailing whitespace
#60: FILE: drivers/char/tpm/tpm-interface.c:19:
+ * $

WARNING: unnecessary whitespace before a quoted newline
#415: FILE: drivers/char/tpm/tpm-interface.c:374:
+			"invalid count value %x %zx \n", count, bufsiz);

ERROR: do not use assignment in if condition
#421: FILE: drivers/char/tpm/tpm-interface.c:380:
+	if ((rc = chip->vendor.send(chip, (u8 *) buf, count)) < 0) {

ERROR: space required after that ',' (ctx:VxV)
#488: FILE: drivers/char/tpm/tpm-interface.c:447:
+	len = tpm_transmit(chip,(u8 *) cmd, len);
 	                       ^

ERROR: "foo * bar" should be "foo *bar"
#702: FILE: drivers/char/tpm/tpm-interface.c:661:
+ssize_t tpm_show_enabled(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#702: FILE: drivers/char/tpm/tpm-interface.c:661:
+ssize_t tpm_show_enabled(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#718: FILE: drivers/char/tpm/tpm-interface.c:677:
+ssize_t tpm_show_active(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#718: FILE: drivers/char/tpm/tpm-interface.c:677:
+ssize_t tpm_show_active(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#734: FILE: drivers/char/tpm/tpm-interface.c:693:
+ssize_t tpm_show_owned(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#734: FILE: drivers/char/tpm/tpm-interface.c:693:
+ssize_t tpm_show_owned(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#750: FILE: drivers/char/tpm/tpm-interface.c:709:
+ssize_t tpm_show_temp_deactivated(struct device * dev,

ERROR: "foo * bar" should be "foo *bar"
#751: FILE: drivers/char/tpm/tpm-interface.c:710:
+				struct device_attribute * attr, char *buf)

WARNING: please, no space before tabs
#813: FILE: drivers/char/tpm/tpm-interface.c:772:
+ * @chip_num: ^Itpm idx # or ANY$

WARNING: please, no space before tabs
#815: FILE: drivers/char/tpm/tpm-interface.c:774:
+ * @res_buf: ^ITPM_PCR value$

WARNING: please, no space before tabs
#816: FILE: drivers/char/tpm/tpm-interface.c:775:
+ * ^I^Isize of res_buf is 20 bytes (or NULL if you don't care)$

WARNING: please, no space before tabs
#838: FILE: drivers/char/tpm/tpm-interface.c:797:
+ * @chip_num: ^Itpm idx # or AN&$

WARNING: please, no space before tabs
#840: FILE: drivers/char/tpm/tpm-interface.c:799:
+ * @hash: ^Ihash value used to extend pcr value$

ERROR: code indent should use tabs where possible
#892: FILE: drivers/char/tpm/tpm-interface.c:851:
+^I                                     TPM_ORD_CONTINUE_SELFTEST);$

ERROR: trailing whitespace
#1009: FILE: drivers/char/tpm/tpm-interface.c:968:
+^I/* $

ERROR: trailing whitespace
#1014: FILE: drivers/char/tpm/tpm-interface.c:973:
+^I   parameters (RSA 12->bytes: keybit, #primes, expbit)  $

WARNING: line over 80 characters
#1136: FILE: drivers/char/tpm/tpm-interface.c:1095:ERROR: trailing
whitespace
#54: FILE: drivers/char/tpm/tpm-interface.c:13:
+ * Specifications at www.trustedcomputinggroup.org^I $

ERROR: trailing whitespace
#60: FILE: drivers/char/tpm/tpm-interface.c:19:
+ * $

WARNING: unnecessary whitespace before a quoted newline
#415: FILE: drivers/char/tpm/tpm-interface.c:374:
+			"invalid count value %x %zx \n", count, bufsiz);

ERROR: do not use assignment in if condition
#421: FILE: drivers/char/tpm/tpm-interface.c:380:
+	if ((rc = chip->vendor.send(chip, (u8 *) buf, count)) < 0) {

ERROR: space required after that ',' (ctx:VxV)
#488: FILE: drivers/char/tpm/tpm-interface.c:447:
+	len = tpm_transmit(chip,(u8 *) cmd, len);
 	                       ^

ERROR: "foo * bar" should be "foo *bar"
#702: FILE: drivers/char/tpm/tpm-interface.c:661:
+ssize_t tpm_show_enabled(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#702: FILE: drivers/char/tpm/tpm-interface.c:661:
+ssize_t tpm_show_enabled(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#718: FILE: drivers/char/tpm/tpm-interface.c:677:
+ssize_t tpm_show_active(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#718: FILE: drivers/char/tpm/tpm-interface.c:677:
+ssize_t tpm_show_active(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#734: FILE: drivers/char/tpm/tpm-interface.c:693:
+ssize_t tpm_show_owned(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#734: FILE: drivers/char/tpm/tpm-interface.c:693:
+ssize_t tpm_show_owned(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#750: FILE: drivers/char/tpm/tpm-interface.c:709:
+ssize_t tpm_show_temp_deactivated(struct device * dev,

ERROR: "foo * bar" should be "foo *bar"
#751: FILE: drivers/char/tpm/tpm-interface.c:710:
+				struct device_attribute * attr, char *buf)

WARNING: please, no space before tabs
#813: FILE: drivers/char/tpm/tpm-interface.c:772:
+ * @chip_num: ^Itpm idx # or ANY$

WARNING: please, no space before tabs
#815: FILE: drivers/char/tpm/tpm-interface.c:774:
+ * @res_buf: ^ITPM_PCR value$

WARNING: please, no space before tabs
#816: FILE: drivers/char/tpm/tpm-interface.c:775:
+ * ^I^Isize of res_buf is 20 bytes (or NULL if you don't care)$

WARNING: please, no space before tabs
#838: FILE: drivers/char/tpm/tpm-interface.c:797:
+ * @chip_num: ^Itpm idx # or AN&$

WARNING: please, no space before tabs
#840: FILE: drivers/char/tpm/tpm-interface.c:799:
+ * @hash: ^Ihash value used to extend pcr value$

ERROR: code indent should use tabs where possible
#892: FILE: drivers/char/tpm/tpm-interface.c:851:
+^I                                     TPM_ORD_CONTINUE_SELFTEST);$

ERROR: trailing whitespace
#1009: FILE: drivers/char/tpm/tpm-interface.c:968:
+^I/* $

ERROR: trailing whitespace
#1014: FILE: drivers/char/tpm/tpm-interface.c:973:
+^I   parameters (RSA 12->bytes: keybit, #primes, expbit)  $

WARNING: line over 80 characters
#1136: FILE: drivers/char/tpm/tpm-interface.c:1095:ERROR: trailing
whitespace
#54: FILE: drivers/char/tpm/tpm-interface.c:13:
+ * Specifications at www.trustedcomputinggroup.org^I $

ERROR: trailing whitespace
#60: FILE: drivers/char/tpm/tpm-interface.c:19:
+ * $

WARNING: unnecessary whitespace before a quoted newline
#415: FILE: drivers/char/tpm/tpm-interface.c:374:
+			"invalid count value %x %zx \n", count, bufsiz);

ERROR: do not use assignment in if condition
#421: FILE: drivers/char/tpm/tpm-interface.c:380:
+	if ((rc = chip->vendor.send(chip, (u8 *) buf, count)) < 0) {

ERROR: space required after that ',' (ctx:VxV)
#488: FILE: drivers/char/tpm/tpm-interface.c:447:
+	len = tpm_transmit(chip,(u8 *) cmd, len);
 	                       ^

ERROR: "foo * bar" should be "foo *bar"
#702: FILE: drivers/char/tpm/tpm-interface.c:661:
+ssize_t tpm_show_enabled(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#702: FILE: drivers/char/tpm/tpm-interface.c:661:
+ssize_t tpm_show_enabled(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#718: FILE: drivers/char/tpm/tpm-interface.c:677:
+ssize_t tpm_show_active(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#718: FILE: drivers/char/tpm/tpm-interface.c:677:
+ssize_t tpm_show_active(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#734: FILE: drivers/char/tpm/tpm-interface.c:693:
+ssize_t tpm_show_owned(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#734: FILE: drivers/char/tpm/tpm-interface.c:693:
+ssize_t tpm_show_owned(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#750: FILE: drivers/char/tpm/tpm-interface.c:709:
+ssize_t tpm_show_temp_deactivated(struct device * dev,

ERROR: "foo * bar" should be "foo *bar"
#751: FILE: drivers/char/tpm/tpm-interface.c:710:
+				struct device_attribute * attr, char *buf)

WARNING: please, no space before tabs
#813: FILE: drivers/char/tpm/tpm-interface.c:772:
+ * @chip_num: ^Itpm idx # or ANY$

WARNING: please, no space before tabs
#815: FILE: drivers/char/tpm/tpm-interface.c:774:
+ * @res_buf: ^ITPM_PCR value$

WARNING: please, no space before tabs
#816: FILE: drivers/char/tpm/tpm-interface.c:775:
+ * ^I^Isize of res_buf is 20 bytes (or NULL if you don't care)$

WARNING: please, no space before tabs
#838: FILE: drivers/char/tpm/tpm-interface.c:797:
+ * @chip_num: ^Itpm idx # or AN&$

WARNING: please, no space before tabs
#840: FILE: drivers/char/tpm/tpm-interface.c:799:
+ * @hash: ^Ihash value used to extend pcr value$

ERROR: code indent should use tabs where possible
#892: FILE: drivers/char/tpm/tpm-interface.c:851:
+^I                                     TPM_ORD_CONTINUE_SELFTEST);$

ERROR: trailing whitespace
#1009: FILE: drivers/char/tpm/tpm-interface.c:968:
+^I/* $

ERROR: trailing whitespace
#1014: FILE: drivers/char/tpm/tpm-interface.c:973:
+^I   parameters (RSA 12->bytes: keybit, #primes, expbit)  $

WARNING: line over 80 characters
#1136: FILE: drivers/char/tpm/tpm-interface.c:1095:
+static bool wait_for_tpm_stat_cond(struct tpm_chip *chip, u8 mask, bool
check_cancel,

ERROR: trailing whitespace
#1507: FILE: drivers/char/tpm/tpm-interface.c:1466:
+ * Called from tpm_<specific>.c probe function only for devices $

total: 16 errors, 7 warnings, 1562 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch
or
      scripts/cleanfile

./0008-tpm-Rename-tpm.c-to-tpm-interface.c.patch has style problems,
please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

+static bool wait_for_tpm_stat_cond(struct tpm_chip *chip, u8 mask, bool
check_cancel,

ERROR: trailing whitespace
#1507: FILE: drivers/char/tpm/tpm-interface.c:1466:
+ * Called from tpm_<specific>.c probe function only for devices $

total: 16 errors, 7 warnings, 1562 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch
or
      scripts/cleanfile

./0008-tpm-Rename-tpm.c-to-tpm-interface.c.patch has style problems,
please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

+static bool wait_for_tpm_stat_cond(struct tpm_chip *chip, u8 mask, bool
check_cancel,

ERROR: trailing whitespace
#1507: FILE: drivers/char/tpm/tpm-interface.c:1466:
+ * Called from tpm_<specific>.c probe function only for devices $

total: 16 errors, 7 warnings, 1562 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch
or
      scripts/cleanfile

./0008-tpm-Rename-tpm.c-to-tpm-interface.c.patch has style problems,
please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

ERROR: trailing whitespace
#1014: FILE: drivers/char/tpm/tpm-interface.c:973:
+^I   parameters (RSA 12->bytes: keybit, #primes, expbit)  $

WARNING: line over 80 characters
#1136: FILE: drivers/char/tpm/tpm-interface.c:1095:
+static bool wait_for_tpm_stat_cond(struct tpm_chip *chip, u8 mask, bool
check_cancel,

ERROR: trailing whitespace
#1507: FILE: drivers/char/tpm/tpm-interface.c:1466:
+ * Called from tpm_<specific>.c probe function only for devices $

total: 16 errors, 7 warnings, 1562 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch
or
      scripts/cleanfile

./0008-tpm-Rename-tpm.c-to-tpm-interface.c.patch has style problems,
please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

+static bool wait_for_tpm_stat_cond(struct tpm_chip *chip, u8 mask, bool
check_cancel,

ERROR: trailing whitespace
#1507: FILE: drivers/char/tpm/tpm-interface.c:1466:
+ * Called from tpm_<specific>.c probe function only for devices $

total: 16 errors, 7 warnings, 1562 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch
or
      scripts/cleanfile

./0008-tpm-Rename-tpm.c-to-tpm-interface.c.patch has style problems,
please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

+ * Specifications at www.trustedcomputinggroup.org^I $

ERROR: trailing whitespace
#60: FILE: drivers/char/tpm/tpm-interface.c:19:
+ * $

WARNING: unnecessary whitespace before a quoted newline
#415: FILE: drivers/char/tpm/tpm-interface.c:374:
+			"invalid count value %x %zx \n", count, bufsiz);

ERROR: do not use assignment in if condition
#421: FILE: drivers/char/tpm/tpm-interface.c:380:
+	if ((rc = chip->vendor.send(chip, (u8 *) buf, count)) < 0) {

ERROR: space required after that ',' (ctx:VxV)
#488: FILE: drivers/char/tpm/tpm-interface.c:447:
+	len = tpm_transmit(chip,(u8 *) cmd, len);
 	                       ^

ERROR: "foo * bar" should be "foo *bar"
#702: FILE: drivers/char/tpm/tpm-interface.c:661:
+ssize_t tpm_show_enabled(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#702: FILE: drivers/char/tpm/tpm-interface.c:661:
+ssize_t tpm_show_enabled(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#718: FILE: drivers/char/tpm/tpm-interface.c:677:
+ssize_t tpm_show_active(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#718: FILE: drivers/char/tpm/tpm-interface.c:677:
+ssize_t tpm_show_active(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#734: FILE: drivers/char/tpm/tpm-interface.c:693:
+ssize_t tpm_show_owned(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#734: FILE: drivers/char/tpm/tpm-interface.c:693:
+ssize_t tpm_show_owned(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#750: FILE: drivers/char/tpm/tpm-interface.c:709:
+ssize_t tpm_show_temp_deactivated(struct device * dev,

ERROR: "foo * bar" should be "foo *bar"
#751: FILE: drivers/char/tpm/tpm-interface.c:710:
+				struct device_attribute * attr, char *buf)

WARNING: please, no space before tabs
#813: FILE: drivers/char/tpm/tpm-interface.c:772:
+ * @chip_num: ^Itpm idx # or ANY$

WARNING: please, no space before tabs
#815: FILE: drivers/char/tpm/tpm-interface.c:774:
+ * @res_buf: ^ITPM_PCR value$

WARNING: please, no space before tabs
#816: FILE: drivers/char/tpm/tpm-interface.c:775:
+ * ^I^Isize of res_buf is 20 bytes (or NULL if you don't care)$

WARNING: please, no space before tabs
#838: FILE: drivers/char/tpm/tpm-interface.c:797:
+ * @chip_num: ^Itpm idx # or AN&$

WARNING: please, no space before tabs
#840: FILE: drivers/char/tpm/tpm-interface.c:799:
+ * @hash: ^Ihash value used to extend pcr value$

ERROR: code indent should use tabs where possible
#892: FILE: drivers/char/tpm/tpm-interface.c:851:
+^I                                     TPM_ORD_CONTINUE_SELFTEST);$

ERROR: trailing whitespace
#1009: FILE: drivers/char/tpm/tpm-interface.c:968:
+^I/* $

ERROR: trailing whitespace
#1014: FILE: drivers/char/tpm/tpm-interface.c:973:
+^I   parameters (RSA 12->bytes: keybit, #primes, expbit)  $

WARNING: line over 80 characters
#1136: FILE: drivers/char/tpm/tpm-interface.c:1095:
+static bool wait_for_tpm_stat_cond(struct tpm_chip *chip, u8 mask, bool
check_cancel,

ERROR: trailing whitespace
#1507: FILE: drivers/char/tpm/tpm-interface.c:1466:
+ * Called from tpm_<specific>.c probe function only for devices $

total: 16 errors, 7 warnings, 1562 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch
or
      scripts/cleanfile

./0008-tpm-Rename-tpm.c-to-tpm-interface.c.patch has style problems,
please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.


WARNING: please, no space before tabs
#815: FILE: drivers/char/tpm/tpm-interface.c:774:
+ * @res_buf: ^ITPM_PCR value$

WARNING: please, no space before tabs
#816: FILE: drivers/char/tpm/tpm-interface.c:775:
+ * ^I^Isize of res_buf is 20 bytes (or NULL if you don't care)$

WARNING: please, no space before tabs
#838: FILE: drivers/char/tpm/tpm-interface.c:797:
+ * @chip_num: ^Itpm idx # or AN&$

WARNING: please, no space before tabs
#840: FILE: drivers/char/tpm/tpm-interface.c:799:
+ * @hash: ^Ihash value used to extend pcr value$

ERROR: code indent should use tabs where possible
#892: FILE: drivers/char/tpm/tpm-interface.c:851:
+^I                                     TPM_ORD_CONTINUE_SELFTEST);$

ERROR: trailing whitespace
#1009: FILE: drivers/char/tpm/tpm-interface.c:968:
+^I/* $

ERROR: trailing whitespace
#1014: FILE: drivers/char/tpm/tpm-interface.c:973:
+^I   parameters (RSA 12->bytes: keybit, #primes, expbit)  $

WARNING: line over 80 characters
#1136: FILE: drivers/char/tpm/tpm-interface.c:1095:
+static bool wait_for_tpm_stat_cond(struct tpm_chip *chip, u8 mask, bool
check_cancel,
ERROR: trailing whitespace
#54: FILE: drivers/char/tpm/tpm-interface.c:13:
+ * Specifications at www.trustedcomputinggroup.org^I $

ERROR: trailing whitespace
#60: FILE: drivers/char/tpm/tpm-interface.c:19:
+ * $

WARNING: unnecessary whitespace before a quoted newline
#415: FILE: drivers/char/tpm/tpm-interface.c:374:
+			"invalid count value %x %zx \n", count, bufsiz);

ERROR: do not use assignment in if condition
#421: FILE: drivers/char/tpm/tpm-interface.c:380:
+	if ((rc = chip->vendor.send(chip, (u8 *) buf, count)) < 0) {

ERROR: space required after that ',' (ctx:VxV)
#488: FILE: drivers/char/tpm/tpm-interface.c:447:
+	len = tpm_transmit(chip,(u8 *) cmd, len);
 	                       ^
ERROR: trailing whitespace
#54: FILE: drivers/char/tpm/tpm-interface.c:13:
+ * Specifications at www.trustedcomputinggroup.org^I $

ERROR: trailing whitespace
#60: FILE: drivers/char/tpm/tpm-interface.c:19:
+ * $

WARNING: unnecessary whitespace before a quoted newline
#415: FILE: drivers/char/tpm/tpm-interface.c:374:
+			"invalid count value %x %zx \n", count, bufsiz);

ERROR: do not use assignment in if condition
#421: FILE: drivers/char/tpm/tpm-interface.c:380:
+	if ((rc = chip->vendor.send(chip, (u8 *) buf, count)) < 0) {

ERROR: space required after that ',' (ctx:VxV)
#488: FILE: drivers/char/tpm/tpm-interface.c:447:
+	len = tpm_transmit(chip,(u8 *) cmd, len);
 	                       ^

ERROR: "foo * bar" should be "foo *bar"
#702: FILE: drivers/char/tpm/tpm-interface.c:661:
+ssize_t tpm_show_enabled(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#702: FILE: drivers/char/tpm/tpm-interface.c:661:
+ssize_t tpm_show_enabled(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#718: FILE: drivers/char/tpm/tpm-interface.c:677:
+ssize_t tpm_show_active(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#718: FILE: drivers/char/tpm/tpm-interface.c:677:
+ssize_t tpm_show_active(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#734: FILE: drivers/char/tpm/tpm-interface.c:693:
+ssize_t tpm_show_owned(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#734: FILE: drivers/char/tpm/tpm-interface.c:693:
+ssize_t tpm_show_owned(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#750: FILE: drivers/char/tpm/tpm-interface.c:709:
+ssize_t tpm_show_temp_deactivated(struct device * dev,

ERROR: "foo * bar" should be "foo *bar"
#751: FILE: drivers/char/tpm/tpm-interface.c:710:
+				struct device_attribute * attr, char *buf)

WARNING: please, no space before tabs
#813: FILE: drivers/char/tpm/tpm-interface.c:772:
+ * @chip_num: ^Itpm idx # or ANY$

WARNING: please, no space before tabs
#815: FILE: drivers/char/tpm/tpm-interface.c:774:
+ * @res_buf: ^ITPM_PCR value$

WARNING: please, no space before tabs
#816: FILE: drivers/char/tpm/tpm-interface.c:775:
+ * ^I^Isize of res_buf is 20 bytes (or NULL if you don't care)$

WARNING: please, no space before tabs
#838: FILE: drivers/char/tpm/tpm-interface.c:797:
+ * @chip_num: ^Itpm idx # or AN&$

WARNING: please, no space before tabs
#840: FILE: drivers/char/tpm/tpm-interface.c:799:
+ * @hash: ^Ihash value used to extend pcr value$

ERROR: code indent should use tabs where possibleERROR: trailing
whitespace
#54: FILE: drivers/char/tpm/tpm-interface.c:13:
+ * Specifications at www.trustedcomputinggroup.org^I $

ERROR: trailing whitespace
#60: FILE: drivers/char/tpm/tpm-interface.c:19:
+ * $

WARNING: unnecessary whitespace before a quoted newline
#415: FILE: drivers/char/tpm/tpm-interface.c:374:
+			"invalid count value %x %zx \n", count, bufsiz);

ERROR: do not use assignment in if condition
#421: FILE: drivers/char/tpm/tpm-interface.c:380:
+	if ((rc = chip->vendor.send(chip, (u8 *) buf, count)) < 0) {

ERROR: space required after that ',' (ctx:VxV)
#488: FILE: drivers/char/tpm/tpm-interface.c:447:
+	len = tpm_transmit(chip,(u8 *) cmd, len);
 	                       ^

ERROR: "foo * bar" should be "foo *bar"
#702: FILE: drivers/char/tpm/tpm-interface.c:661:
+ssize_t tpm_show_enabled(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#702: FILE: drivers/char/tpm/tpm-interface.c:661:
+ssize_t tpm_show_enabled(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#718: FILE: drivers/char/tpm/tpm-interface.c:677:
+ssize_t tpm_show_active(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#718: FILE: drivers/char/tpm/tpm-interface.c:677:
+ssize_t tpm_show_active(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#734: FILE: drivers/char/tpm/tpm-interface.c:693:
+ssize_t tpm_show_owned(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#734: FILE: drivers/char/tpm/tpm-interface.c:693:
+ssize_t tpm_show_owned(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#750: FILE: drivers/char/tpm/tpm-interface.c:709:
+ssize_t tpm_show_temp_deactivated(struct device * dev,

ERROR: "foo * bar" should be "foo *bar"
#751: FILE: drivers/char/tpm/tpm-interface.c:710:
+				struct device_attribute * attr, char *buf)

WARNING: please, no space before tabs
#813: FILE: drivers/char/tpm/tpm-interface.c:772:
+ * @chip_num: ^Itpm idx # or ANY$

WARNING: please, no space before tabs
#815: FILE: drivers/char/tpm/tpm-interface.c:774:
+ * @res_buf: ^ITPM_PCR value$

WARNING: please, no space before tabs
#816: FILE: drivers/char/tpm/tpm-interface.c:775:
+ * ^I^Isize of res_buf is 20 bytes (or NULL if you don't care)$

WARNING: please, no space before tabs
#838: FILE: drivers/char/tpm/tpm-interface.c:797:
+ * @chip_num: ^Itpm idx # or AN&$

WARNING: please, no space before tabs
#840: FILE: drivers/char/tpm/tpm-interface.c:799:
+ * @hash: ^Ihash value used to extend pcr value$

ERROR: code indent should use tabs where possible
#892: FILE: drivers/char/tpm/tpm-interface.c:851:
+^I                                     TPM_ORD_CONTINUE_SELFTEST);$

ERROR: trailing whitespace
#1009: FILE: drivers/char/tpm/tpm-interface.c:968:
+^I/* $

ERROR: trailing whitespace
#1014: FILE: drivers/char/tpm/tpm-interface.c:973:
+^I   parameters (RSA 12->bytes: keybit, #primes, expbit)  $

WARNING: line over 80 characters
#1136: FILE: drivers/char/tpm/tpm-interface.c:1095:
+static bool wait_for_tpm_stat_cond(struct tpm_chip *chip, u8 mask, bool
check_cancel,

ERROR: trailing whitespace
#1507: FILE: drivers/char/tpm/tpm-interface.c:1466:
+ * Called from tpm_<specific>.c probe function only for devices $

total: 16 errors, 7 warnings, 1562 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch
or
      scripts/cleanfile

./0008-tpm-Rename-tpm.c-to-tpm-interface.c.patch has style problems,
please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

#892: FILE: drivers/char/tpm/tpm-interface.c:851:
+^I                                     TPM_ORD_CONTINUE_SELFTEST);$

ERROR: trailing whitespace
#1009: FILE: drivers/char/tpm/tpm-interface.c:968:
+^I/* $

ERROR: trailing whitespace
#1014: FILE: drivers/char/tpm/tpm-interface.c:973:
+^I   parameters (RSA 12->bytes: keybit, #primes, expbit)  $

WARNING: line over 80 characters
#1136: FILE: drivers/char/tpm/tpm-interface.c:1095:
+static bool wait_for_tpm_stat_cond(struct tpm_chip *chip, u8 mask, bool
check_cancel,

ERROR: trailing whitespace
#1507: FILE: drivers/char/tpm/tpm-interface.c:1466:
+ * Called from tpm_<specific>.c probe function only for devices $

total: 16 errors, 7 warnings, 1562 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch
or
      scripts/cleanfile

./0008-tpm-Rename-tpm.c-to-tpm-interface.c.patch has style problems,
please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

ERROR: "foo * bar" should be "foo *bar"
#702: FILE: drivers/char/tpm/tpm-interface.c:661:
+ssize_t tpm_show_enabled(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#702: FILE: drivers/char/tpm/tpm-interface.c:661:
+ssize_t tpm_show_enabled(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#718: FILE: drivers/char/tpm/tpm-interface.c:677:
+ssize_t tpm_show_active(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#718: FILE: drivers/char/tpm/tpm-interface.c:677:
+ssize_t tpm_show_active(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#734: FILE: drivers/char/tpm/tpm-interface.c:693:
+ssize_t tpm_show_owned(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#734: FILE: drivers/char/tpm/tpm-interface.c:693:
+ssize_t tpm_show_owned(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#750: FILE: drivers/char/tpm/tpm-interface.c:709:
+ssize_t tpm_show_temp_deactivated(struct device * dev,

ERROR: "foo * bar" should be "foo *bar"
#751: FILE: drivers/char/tpm/tpm-interface.c:710:
+				struct device_attribute * attr, char *buf)

WARNING: please, no space before tabs
#813: FILE: drivers/char/tpm/tpm-interface.c:772:
+ * @chip_num: ^Itpm idx # or ANY$

WARNING: please, no space before tabs
#815: FILE: drivers/char/tpm/tpm-interface.c:774:
+ * @res_buf: ^ITPM_PCR value$

WARNING: please, no space before tabs
#816: FILE: drivers/char/tpm/tpm-interface.c:775:
+ * ^I^Isize of res_buf is 20 bytes (or NULL if you don't care)$

WARNING: please, no space before tabs
#838: FILE: drivers/char/tpm/tpm-interface.c:797:
+ * @chip_num: ^Itpm idx # or AN&$

WARNING: please, no space before tabs
#840: FILE: drivers/char/tpm/tpm-interface.c:799:
+ * @hash: ^Ihash value used to extend pcr value$

ERROR: code indent should use tabs where possible
#892: FILE: drivers/char/tpm/tpm-interface.c:851:
+^I                                     TPM_ORD_CONTINUE_SELFTEST);$

ERROR: trailing whitespace
#1009: FILE: drivers/char/tpm/tpm-interface.c:968:
+^I/* $

ERROR: trailing whitespace
#1014: FILE: drivers/char/tpm/tpm-interface.c:973:
+^I   parameters (RSA 12->bytes: keybit, #primes, expbit)  $

WARNING: line over 80 characters
#1136: FILE: drivers/char/tpm/tpm-interface.c:1095:
+static bool wait_for_tpm_stat_cond(struct tpm_chip *chip, u8 mask, bool
check_cancel,

ERROR: trailing whitespace
#1507: FILE: drivers/char/tpm/tpm-interface.c:1466:
+ * Called from tpm_<specific>.c probe function only for devices $

total: 16 errors, 7 warnings, 1562 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch
or
      scripts/cleanfile

./0008-tpm-Rename-tpm.c-to-tpm-interface.c.patch has style problems,
please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

ERROR: trailing whitespace
#1507: FILE: drivers/char/tpm/tpm-interface.c:1466:
+ * Called from tpm_<specific>.c probe function only for devices $

total: 16 errors, 7 warnings, 1562 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch
or
      scripts/cleanfile

./0008-tpm-Rename-tpm.c-to-tpm-interface.c.patch has style problems,
please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.


ERROR: "foo * bar" should be "foo *bar"
#734: FILE: drivers/char/tpm/tpm-interface.c:693:
+ssize_t tpm_show_owned(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#734: FILE: drivers/char/tpm/tpm-interface.c:693:
+ssize_t tpm_show_owned(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#750: FILE: drivers/char/tpm/tpm-interface.c:709:
+ssize_t tpm_show_temp_deactivated(struct device * dev,

ERROR: "foo * bar" should be "foo *bar"
#751: FILE: drivers/char/tpm/tpm-interface.c:710:
+				struct device_attribute * attr, char *buf)

WARNING: please, no space before tabs
#813: FILE: drivers/char/tpm/tpm-interface.c:772:
+ * @chip_num: ^Itpm idx # or ANY$

WARNING: please, no space before tabs
#815: FILE: drivers/char/tpm/tpm-interface.c:774:
+ * @res_buf: ^ITPM_PCR value$

WARNING: please, no space before tabs
#816: FILE: drivers/char/tpm/tpm-interface.c:775:
+ * ^I^Isize of res_buf is 20 bytes (or NULL if you don't care)$

WARNING: please, no space before tabs
#838: FILE: drivers/char/tpm/tpm-interface.c:797:
+ * @chip_num: ^Itpm idx # or AN&$

WARNING: please, no space before tabs
#840: FILE: drivers/char/tpm/tpm-interface.c:799:
+ * @hash: ^Ihash value used to extend pcr value$

ERROR: code indent should use tabs where possible
#892: FILE: drivers/char/tpm/tpm-interface.c:851:
+^I                                     TPM_ORD_CONTINUE_SELFTEST);$

ERROR: trailing whitespace
#1009: FILE: drivers/char/tpm/tpm-interface.c:968:
+^I/* $

ERROR: trailing whitespace
#1014: FILE: drivers/char/tpm/tpm-interface.c:973:
+^I   parameters (RSA 12->bytes: keybit, #primes, expbit)  $

WARNING: line over 80 characters
#1136: FILE: drivers/char/tpm/tpm-interface.c:1095:
+static bool wait_for_tpm_stat_cond(struct tpm_chip *chip, u8 mask, bool
check_cancel,

ERROR: trailing whitespace
#1507: FILE: drivers/char/tpm/tpm-interface.c:1466:
+ * Called from tpm_<specific>.c probe function only for devices $

total: 16 errors, 7 warnings, 1562 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch
or
      scripts/cleanfile

./0008-tpm-Rename-tpm.c-to-tpm-interface.c.patch has style problems,
please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

+ssize_t tpm_show_owned(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#734: FILE: drivers/char/tpm/tpm-interface.c:693:
+ssize_t tpm_show_owned(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#750: FILE: drivers/char/tpm/tpm-interface.c:709:
+ssize_t tpm_show_temp_deactivated(struct device * dev,

ERROR: "foo * bar" should be "foo *bar"
#751: FILE: drivers/char/tpm/tpm-interface.c:710:
+				struct device_attribute * attr, char *buf)

WARNING: please, no space before tabs
#813: FILE: drivers/char/tpm/tpm-interface.c:772:
+ * @chip_num: ^Itpm idx # or ANY$

WARNING: please, no space before tabs
#815: FILE: drivers/char/tpm/tpm-interface.c:774:
+ * @res_buf: ^ITPM_PCR value$

WARNING: please, no space before tabs
#816: FILE: drivers/char/tpm/tpm-interface.c:775:
+ * ^I^Isize of res_buf is 20 bytes (or NULL if you don't care)$

WARNING: please, no space before tabs
#838: FILE: drivers/char/tpm/tpm-interface.c:797:
+ * @chip_num: ^Itpm idx # or AN&$

WARNING: please, no space before tabs
#840: FILE: drivers/char/tpm/tpm-interface.c:799:
+ * @hash: ^Ihash value used to extend pcr value$

ERROR: code indent should use tabs where possible
#892: FILE: drivers/char/tpm/tpm-interface.c:851:
+^I                                     TPM_ORD_CONTINUE_SELFTEST);$

ERROR: trailing whitespace
#1009: FILE: drivers/char/tpm/tpm-interface.c:968:
+^I/* $
ERROR: trailing whitespace
#54: FILE: drivers/char/tpm/tpm-interface.c:13:
+ * Specifications at www.trustedcomputinggroup.org^I $

ERROR: trailing whitespace
#60: FILE: drivers/char/tpm/tpm-interface.c:19:
+ * $

WARNING: unnecessary whitespace before a quoted newline
#415: FILE: drivers/char/tpm/tpm-interface.c:374:
+			"invalid count value %x %zx \n", count, bufsiz);

ERROR: do not use assignment in if condition
#421: FILE: drivers/char/tpm/tpm-interface.c:380:
+	if ((rc = chip->vendor.send(chip, (u8 *) buf, count)) < 0) {

ERROR: space required after that ',' (ctx:VxV)
#488: FILE: drivers/char/tpm/tpm-interface.c:447:
+	len = tpm_transmit(chip,(u8 *) cmd, len);
 	                       ^

ERROR: "foo * bar" should be "foo *bar"
#702: FILE: drivers/char/tpm/tpm-interface.c:661:
+ssize_t tpm_show_enabled(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#702: FILE: drivers/char/tpm/tpm-interface.c:661:
+ssize_t tpm_show_enabled(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#718: FILE: drivers/char/tpm/tpm-interface.c:677:
+ssize_t tpm_show_active(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#718: FILE: drivers/char/tpm/tpm-interface.c:677:
+ssize_t tpm_show_active(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#734: FILE: drivers/char/tpm/tpm-interface.c:693:
+ssize_t tpm_show_owned(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#734: FILE: drivers/char/tpm/tpm-interface.c:693:
+ssize_t tpm_show_owned(struct device * dev, struct device_attribute *
attr,

ERROR: "foo * bar" should be "foo *bar"
#750: FILE: drivers/char/tpm/tpm-interface.c:709:
+ssize_t tpm_show_temp_deactivated(struct device * dev,

ERROR: "foo * bar" should be "foo *bar"
#751: FILE: drivers/char/tpm/tpm-interface.c:710:
+				struct device_attribute * attr, char *buf)

WARNING: please, no space before tabs
#813: FILE: drivers/char/tpm/tpm-interface.c:772:
+ * @chip_num: ^Itpm idx # or ANY$

WARNING: please, no space before tabs
#815: FILE: drivers/char/tpm/tpm-interface.c:774:
+ * @res_buf: ^ITPM_PCR value$

WARNING: please, no space before tabs
#816: FILE: drivers/char/tpm/tpm-interface.c:775:
+ * ^I^Isize of res_buf is 20 bytes (or NULL if you don't care)$

WARNING: please, no space before tabs
#838: FILE: drivers/char/tpm/tpm-interface.c:797:
+ * @chip_num: ^Itpm idx # or AN&$

WARNING: please, no space before tabs
#840: FILE: drivers/char/tpm/tpm-interface.c:799:
+ * @hash: ^Ihash value used to extend pcr value$

ERROR: code indent should use tabs where possible
#892: FILE: drivers/char/tpm/tpm-interface.c:851:
+^I                                     TPM_ORD_CONTINUE_SELFTEST);$

ERROR: trailing whitespace
#1009: FILE: drivers/char/tpm/tpm-interface.c:968:
+^I/* $

ERROR: trailing whitespace
#1014: FILE: drivers/char/tpm/tpm-interface.c:973:
+^I   parameters (RSA 12->bytes: keybit, #primes, expbit)  $

WARNING: line over 80 characters
#1136: FILE: drivers/char/tpm/tpm-interface.c:1095:
+static bool wait_for_tpm_stat_cond(struct tpm_chip *chip, u8 mask, bool
check_cancel,

ERROR: trailing whitespace
#1507: FILE: drivers/char/tpm/tpm-interface.c:1466:
+ * Called from tpm_<specific>.c probe function only for devices $

total: 16 errors, 7 warnings, 1562 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch
or
      scripts/cleanfile

./0008-tpm-Rename-tpm.c-to-tpm-interface.c.patch has style problems,
please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

ERROR: trailing whitespace
#1014: FILE: drivers/char/tpm/tpm-interface.c:973:
+^I   parameters (RSA 12->bytes: keybit, #primes, expbit)  $

WARNING: line over 80 characters
#1136: FILE: drivers/char/tpm/tpm-interface.c:1095:
+static bool wait_for_tpm_stat_cond(struct tpm_chip *chip, u8 mask, bool
check_cancel,

ERROR: trailing whitespace
#1507: FILE: drivers/char/tpm/tpm-interface.c:1466:
+ * Called from tpm_<specific>.c probe function only for devices $

total: 16 errors, 7 warnings, 1562 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch
or
      scripts/cleanfile

./0008-tpm-Rename-tpm.c-to-tpm-interface.c.patch has style problems,
please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.


WARNING: line over 80 characters
#1136: FILE: drivers/char/tpm/tpm-interface.c:1095:
+static bool wait_for_tpm_stat_cond(struct tpm_chip *chip, u8 mask, bool
check_cancel,

ERROR: trailing whitespace
#1507: FILE: drivers/char/tpm/tpm-interface.c:1466:
+ * Called from tpm_<specific>.c probe function only for devices $

total: 16 errors, 7 warnings, 1562 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch
or
      scripts/cleanfile

./0008-tpm-Rename-tpm.c-to-tpm-interface.c.patch has style problems,
please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.


      scripts/cleanfile

./0008-tpm-Rename-tpm.c-to-tpm-interface.c.patch has style problems,
please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

--Ashley Lai



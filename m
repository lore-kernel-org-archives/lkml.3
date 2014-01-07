Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752400AbaAGFiq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 00:38:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49910 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750963AbaAGFin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 00:38:43 -0500
Message-ID: <52CB929C.6050403@zytor.com>
Date: Mon, 06 Jan 2014 21:37:32 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: joeyli <jlee@suse.com>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <matthew.garrett@nebula.com>, Elliott@hp.com,
        samer.el-haj-mahmoud@hp.com, Oliver Neukum <oneukum@suse.de>,
        werner@suse.com, trenn@suse.de, JBeulich@suse.com,
        linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        x86@kernel.org,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        linux-acpi@vger.kernel.org
Subject: Re: [RFC PATCH 04/14] ACPI: Add ACPI 5.0 Time and Alarm Device driver
References: <1387439515-8926-1-git-send-email-jlee@suse.com>	 <1387439515-8926-5-git-send-email-jlee@suse.com>	 <52B30F43.1060306@zytor.com> <1387518099.3539.4453.camel@linux-s257.site>	 <52C3647B.7000708@zytor.com> <1388998707.3539.6070.camel@linux-s257.site>
In-Reply-To: <1388998707.3539.6070.camel@linux-s257.site>
X-Enigmail-Version: 1.6
Content-Type: multipart/mixed;
 boundary="------------080104060501040706090104"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080104060501040706090104
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 01/06/2014 12:58 AM, joeyli wrote:
> 於 二，2013-12-31 於 16:42 -0800，H. Peter Anvin 提到：
>> On 12/19/2013 09:41 PM, joeyli wrote:
>>>>
>>>> What platform do you have that has TAD support?  I am wondering how this
>>>> was tested.
>>>>
>>>
>>> It's a testing platform that's only support get/set time functions of
>>> ACPI TAD.
>>>
>>
>> It would be really, really good to get this into Qemu (either SeaBIOS or
>> OVMF, or ideally both) so we can have anyone test.
>>
>> 	-hpa
> 
> I will try to add to OVMF first.
> 

For the record, I posted a patch to Qemu about a year ago to store the
timezone in the CMOS, which might be useful for this implementation.  It
was rejected because of no firmware support, so if you implement it for
OVMF we can (update and) push this patch again.

	-hpa




--------------080104060501040706090104
Content-Type: message/rfc822;
 name="Attached Message"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="Attached Message"

Return-Path: <qemu-devel-bounces+qemu=hpa.at.zytor.com@nongnu.org>
Received: from lists.gnu.org (lists.gnu.org [208.118.235.17])
	by terminus.zytor.com (8.14.5/8.14.5) with ESMTP id r1S3GqVK014901
	(version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=NO)
	for <qemu@hpa.at.zytor.com>; Wed, 27 Feb 2013 19:16:58 -0800
Received: from localhost ([::1]:50702 helo=lists.gnu.org)
	by lists.gnu.org with esmtp (Exim 4.71)
	(envelope-from <qemu-devel-bounces+qemu=hpa.at.zytor.com@nongnu.org>)
	id 1UAtzD-0006rb-Cx
	for qemu@hpa.at.zytor.com; Wed, 27 Feb 2013 22:16:47 -0500
Received: from eggs.gnu.org ([208.118.235.92]:42978)
	by lists.gnu.org with esmtp (Exim 4.71)
	(envelope-from <hpa@anvin.org>) id 1UAtyg-0006GY-V7
	for qemu-devel@nongnu.org; Wed, 27 Feb 2013 22:16:18 -0500
Received: from Debian-exim by eggs.gnu.org with spam-scanned (Exim 4.71)
	(envelope-from <hpa@anvin.org>) id 1UAtyc-0000f0-HR
	for qemu-devel@nongnu.org; Wed, 27 Feb 2013 22:16:14 -0500
Received: from terminus.zytor.com ([2001:1868:205::10]:34671
	helo=mail.zytor.com) by eggs.gnu.org with esmtp (Exim 4.71)
	(envelope-from <hpa@anvin.org>) id 1UAtyb-0000OI-Sg
	for qemu-devel@nongnu.org; Wed, 27 Feb 2013 22:16:10 -0500
Received: from tazenda.hos.anvin.org
	([IPv6:2601:9:3340:26:e269:95ff:fe35:9f3c]) (authenticated bits=0)
	by mail.zytor.com (8.14.5/8.14.5) with ESMTP id r1S2Cj8d032389
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO);
	Wed, 27 Feb 2013 18:12:45 -0800
Received: from tazenda.hos.anvin.org (localhost [127.0.0.1])
	by tazenda.hos.anvin.org (8.14.5/8.14.5) with ESMTP id r1S2Ce45001308; 
	Wed, 27 Feb 2013 18:12:40 -0800
Received: (from hpa@localhost)
	by tazenda.hos.anvin.org (8.14.5/8.14.5/Submit) id r1S2CcWT001307;
	Wed, 27 Feb 2013 18:12:38 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
To: qemu-devel@nongnu.org
Date: Wed, 27 Feb 2013 18:12:34 -0800
Message-Id: <1362017554-1260-3-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1362017554-1260-1-git-send-email-hpa@zytor.com>
References: <1362017554-1260-1-git-send-email-hpa@zytor.com>
X-detected-operating-system: by eggs.gnu.org: Error: Malformed IPv6 address
	(bad octet value).
X-Received-From: 2001:1868:205::10
Cc: "Kevin O'Connor" <kevin@koconnor.net>,
        David Woodhouse <dwmw2@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [Qemu-devel] [RFC PATCH 3/3] mc146818rtc: export the timezone
	information
X-BeenThere: qemu-devel@nongnu.org
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: <qemu-devel.nongnu.org>
List-Unsubscribe: <https://lists.nongnu.org/mailman/options/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=unsubscribe>
List-Archive: <http://lists.nongnu.org/archive/html/qemu-devel>
List-Post: <mailto:qemu-devel@nongnu.org>
List-Help: <mailto:qemu-devel-request@nongnu.org?subject=help>
List-Subscribe: <https://lists.nongnu.org/mailman/listinfo/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=subscribe>
Errors-To: qemu-devel-bounces+qemu=hpa.at.zytor.com@nongnu.org
Sender: qemu-devel-bounces+qemu=hpa.at.zytor.com@nongnu.org
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
	SPF_PASS autolearn=ham version=3.3.2
X-Spam-Checker-Version: SpamAssassin 3.3.2 (2011-06-06) on terminus.zytor.com
X-Greylist: IP, sender and recipient auto-whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [198.137.202.10]); Wed, 27 Feb 2013 19:16:58 -0800 (PST)

From: "H. Peter Anvin" <hpa@zytor.com>

There is no standard method for storing timezone information
associated with the classic PC/AT RTC, however, there are standard
methods in ACPI (Time and Alarm Device) and EFI (GetTime/SetTime) for
getting this information.

Since these are abstract methods, it is qreally firmware-specific how
it is stored, however, since Qemu initializes the RTC in the virtual
environment that information needs to come from Qemu in the first
place.

Non-PC platforms that use the MC146181 RTC may have their own
firmware-specific methods as well.

The most logical place to stash this information is in the RTC CMOS;
not only is it logically co-located with the relevant information, but
it is also very easy to access from ACPI bytecode.  Thus, save the
timezone information in two bytes in CMOS that have no known standard
definition, but are yet within the 64 bytes that even the most basic
RTC CMOS implementations including the original MC146181 support.

Note: all timezones currently in use in the world are on 15-minutes
boundaries, which would allow this information to be stored in a
single signed byte.  However, both EFI and ACPI use a minute-granular
interface (specified as -1440 to +1440 with 2047 used to mean
"unknown", this requires a minimum of 12 bits to represent); this
follows that model.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: "Kevin O'Connor" <kevin@koconnor.net>
Cc: David Woodhouse <dwmw2@infradead.org>
---
 hw/mc146818rtc.c      | 6 ++++++
 hw/mc146818rtc_regs.h | 2 ++
 2 files changed, 8 insertions(+)

diff --git a/hw/mc146818rtc.c b/hw/mc146818rtc.c
index 2fb11f6..72541dd 100644
--- a/hw/mc146818rtc.c
+++ b/hw/mc146818rtc.c
@@ -681,6 +681,7 @@ static void rtc_set_date_from_host(ISADevice *dev)
 {
     RTCState *s = DO_UPCAST(RTCState, dev, dev);
     struct tm tm;
+    int minuteseast;
 
     qemu_get_timedate(&tm, 0);
 
@@ -690,6 +691,11 @@ static void rtc_set_date_from_host(ISADevice *dev)
 
     /* set the CMOS date */
     rtc_set_cmos(s, &tm);
+
+    /* Set the timezone information as a signed 16-bit number of minutes */
+    minuteseast = ((int64_t)s->base_rtc - (int64_t)mktime(&tm)) / 60;
+    s->cmos_data[RTC_TIMEZONE_L] = (uint8_t)(minuteseast);
+    s->cmos_data[RTC_TIMEZONE_H] = (uint8_t)(minuteseast >> 8);
 }
 
 static int rtc_post_load(void *opaque, int version_id)
diff --git a/hw/mc146818rtc_regs.h b/hw/mc146818rtc_regs.h
index ccdee42..7dd5e0d 100644
--- a/hw/mc146818rtc_regs.h
+++ b/hw/mc146818rtc_regs.h
@@ -47,6 +47,8 @@
 /* PC cmos mappings */
 #define RTC_CENTURY              0x32
 #define RTC_IBM_PS2_CENTURY_BYTE 0x37
+#define RTC_TIMEZONE_L           0x3e
+#define RTC_TIMEZONE_H           0x3f
 
 #define REG_A_UIP 0x80
 
-- 
1.7.11.7



--------------080104060501040706090104--

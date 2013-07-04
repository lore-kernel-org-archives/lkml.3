Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932805Ab3GDBXx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 21:23:53 -0400
Received: from mga03.intel.com ([143.182.124.21]:19752 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755493Ab3GDBX3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 21:23:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,992,1363158000"; 
   d="scan'208";a="326557486"
Message-ID: <51D4CEB3.5080709@intel.com>
Date: Thu, 04 Jul 2013 09:24:03 +0800
From: Aaron Lu <aaron.lu@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Matthew Garrett <matthew.garrett@nebula.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "seth.forshee@canonical.com" <seth.forshee@canonical.com>,
        "joeyli.kernel@gmail.com" <joeyli.kernel@gmail.com>,
        "daniel.vetter@ffwll.ch" <daniel.vetter@ffwll.ch>,
        "lenb@kernel.org" <lenb@kernel.org>,
        Bob Moore <robert.moore@intel.com>
Subject: [PATCH 2/2] ACPI / OSL: add a wrapper function to return OSI version
References: <1370818899-8595-1-git-send-email-matthew.garrett@nebula.com> <51D2DC1D.60101@intel.com> <51D2DD37.2040000@intel.com> <3141401.j726us1HYg@vostro.rjw.lan>
In-Reply-To: <3141401.j726us1HYg@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04/2013 05:57 AM, Rafael J. Wysocki wrote:
> On Tuesday, July 02, 2013 10:01:27 PM Aaron Lu wrote:
>> Drivers may need to make policy decisions based on the OS that the firmware
>> believes it's interacting with. ACPI firmware will make a series of _OSI
>> calls, starting from the oldest OS version they support and ending with the
>> most recent. This patchset adds a function in ACPI OSL layer to return the
>> last successful call so that drivers know what the firmware's expecting.
>>
>> Based on a patch by Matthew Garrett <matthew.garrett@nebula.com>, which
>> is again based on a patch by Seth Forshee <seth.forshee@canonical.com>.
>>
>> Changelog-by: Matthew Garrett <matthew.garrett@nebula.com>
>> Signed-off-by: Aaron Lu <aaron.lu@intel.com>
>> Cc: Matthew Garrett <matthew.garrett@nebula.com>
>> Cc: Seth Forshee <seth.forshee@canonical.com>
>> ---
>>  drivers/acpi/osl.c   | 6 ++++++
>>  include/linux/acpi.h | 6 ++++++
>>  2 files changed, 12 insertions(+)
>>
>> diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
>> index 6ab2c35..7ebf07d 100644
>> --- a/drivers/acpi/osl.c
>> +++ b/drivers/acpi/osl.c
>> @@ -1799,3 +1799,9 @@ void alloc_acpi_hp_work(acpi_handle handle, u32 type, void *context,
>>  		kfree(hp_work);
>>  }
>>  EXPORT_SYMBOL_GPL(alloc_acpi_hp_work);
>> +
>> +u8 acpi_osi_version(void)
>> +{
>> +	return acpi_gbl_osi_data;
>> +}
> 
> Actually, is there a reason not to make this static inline and put it into
> the header?

Ah right, thanks for the suggestion.
Patch updated:

From: Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH updated 2/2] ACPI / OSL: add a wrapper function to return OSI version

Drivers may need to make policy decisions based on the OS that the firmware
believes it's interacting with. ACPI firmware will make a series of _OSI
calls, starting from the oldest OS version they support and ending with the
most recent. This patchset adds a function in ACPI OSL layer to return the
last successful call so that drivers know what the firmware's expecting.

Based on a patch by Matthew Garrett <matthew.garrett@nebula.com>, which
is again based on a patch by Seth Forshee <seth.forshee@canonical.com>.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
---
 include/linux/acpi.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index 353ba25..7969bf8 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -578,4 +578,10 @@ acpi_handle_printk(const char *level, void *handle, const char *fmt, ...) {}
 })
 #endif
 
+#ifdef CONFIG_ACPI
+static inline u8 acpi_osi_version(void) { return acpi_gbl_osi_data; }
+#else
+static inline u8 acpi_osi_version(void) { return 0; }
+#endif
+
 #endif	/*_LINUX_ACPI_H*/
-- 
1.8.3.2.10.g43d11f4

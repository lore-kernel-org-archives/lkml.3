Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932203Ab3B0CXM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 21:23:12 -0500
Received: from mga02.intel.com ([134.134.136.20]:4103 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759877Ab3B0CXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 21:23:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,744,1355126400"; 
   d="scan'208";a="268217691"
Message-ID: <512D6E49.4070201@intel.com>
Date: Wed, 27 Feb 2013 10:24:09 +0800
From: Aaron Lu <aaron.lu@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Nishanth Menon <nm@ti.com>, Tejun Heo <tj@kernel.org>,
        Jeff Garzik <jgarzik@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [GIT PULL] ACPI and power management fixes for v3.9-rc1
References: <1663657.ypAtqGpGAq@vostro.rjw.lan> <1781256.mPQbtiUPYR@vostro.rjw.lan> <CA+55aFyzjN_wMH+2RCEA+aNLY0Z7fn4YU7VOtTALbgngn1+vCw@mail.gmail.com> <2223198.XmyRLgb3Gv@vostro.rjw.lan> <20130226161049.GA9303@kahuna> <CA+55aFy24fp+9zXiDmAgvsz6YvWQh2L0BAJ2hAhF7cNSdyMd8w@mail.gmail.com> <CA+55aFyu5woJsH2y3y=w4UFneOG8hKz_cLXgZQbJzn5asn8=hQ@mail.gmail.com>
In-Reply-To: <CA+55aFyu5woJsH2y3y=w4UFneOG8hKz_cLXgZQbJzn5asn8=hQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27/2013 12:28 AM, Linus Torvalds wrote:
> Ugh. Forgot to actually add the ODD people to the list...
> 
>              Linus
> 
> On Tue, Feb 26, 2013 at 8:27 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>> On Tue, Feb 26, 2013 at 8:10 AM, Nishanth Menon <nm@ti.com> wrote:
>>> On 16:55-20130226, Rafael J. Wysocki wrote:
>>>>
>>>> It says that in "Introduction", but it would be clearer if the title of the
>>>> doc was something like "Operating Performance Points (OPP) Library".  Nishanth?
>>>
>>> Yes indeed. Will the following help? I can post it as an official patch
>>> if the direction is proper
>>
>> Yes, this will definitely help. I didn't even find it in the
>> introduction (Rafael is correct that it is indeed there), because it's
>> hard to see when you don't know what to scan for and it's in a big
>> block of text.
>>
>> I am also happy to note that it is in the Kconfig help and single-line
>> description. Which wasn't true for the new SATA_ZPODD ("Zero Power
>> ODD" - what the heck is ODD?) which was another new entry I wondered
>> about.

Sorry about this.

>>
>> It turns out that ODD is an odd TLA for "Optical Disk Drive". I'm sure
>> it makes perfect sense if you are a SATA person, but it sure doesn't
>> for any normal human being, even otherwise highly technical ones.
>>
>> Aaron, Tejun, Jeff, can I ask you to also not use specialized TLA's
>> without explaining them? Especially in help text and "documentation",
>> it's very unhelpful to have TLA's that aren't common.

OK.
I hope the following is better, if so, I'll send out a patch.

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index 9b58d32..b75efb0b 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -59,15 +59,16 @@ config ATA_ACPI
 	  option libata.noacpi=1
 
 config SATA_ZPODD
-	bool "SATA Zero Power ODD Support"
+	bool "SATA Zero Power Optical Disc Drive(ZPODD) support"
 	depends on ATA_ACPI
 	default n
 	help
-	  This option adds support for SATA ZPODD. It requires both
-	  ODD and the platform support, and if enabled, will automatically
-	  power on/off the ODD when certain condition is satisfied. This
-	  does not impact user's experience of the ODD, only power is saved
-	  when ODD is not in use(i.e. no disc inside).
+	  This option adds support for SATA Zero Power Optical Disc
+	  Drive(ZPODD). It requires both the ODD and the platform
+	  support, and if enabled, will automatically power on/off the
+	  ODD when certain condition is satisfied. This does not impact
+	  end user's experience of the ODD, only power is saved when
+	  the ODD is not in use(i.e. no disc inside).
 
 	  If unsure, say N.
 
 
Thanks,
Aaron


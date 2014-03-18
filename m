Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169AbaCRAcF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 20:32:05 -0400
Received: from mga01.intel.com ([192.55.52.88]:49160 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750716AbaCRAcA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 20:32:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,673,1389772800"; 
   d="scan'208";a="500790025"
From: "Zheng, Lv" <lv.zheng@intel.com>
To: "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>
CC: "Brown, Len" <len.brown@intel.com>, Lv Zheng <zetalog@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: RE: [RFC PATCH 2/2] ACPI: Default disable auto-serialization.
Thread-Topic: [RFC PATCH 2/2] ACPI: Default disable auto-serialization.
Thread-Index: AQHPQdnB7zYfPwO/T0q0D+Kd5BOXuZrl/Opg
Date: Tue, 18 Mar 2014 00:31:54 +0000
Message-ID: <1AE640813FDE7649BE1B193DEA596E88024E1AE0@SHSMSX101.ccr.corp.intel.com>
References: <14866.1394813101@turing-police.cc.vt.edu>
 <cover.1395028738.git.lv.zheng@intel.com>
 <fdc47fb7d89d984a164531b316e8b56f73ed05c9.1395028738.git.lv.zheng@intel.com>
 <5326E5E8.4070804@intel.com>
In-Reply-To: <5326E5E8.4070804@intel.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Rafael

> From: Wysocki, Rafael J
> Sent: Monday, March 17, 2014 8:09 PM
> 
> On 3/17/2014 5:14 AM, Lv Zheng wrote:
> > This feature enabled by the following commit is still under development.
> >
> >    Commit: cd52379678785b02d7a357988cfba214fdaf92f4
> >    Subject: ACPICA: Add global option to disable method auto-serialization.
> >    This change adds an option to disable the auto-serialization of
> >    methods that create named objects.
> >
> > This patch disables it by default temporarily according to the bug reports.
> 
> Well, it doesn't restore the 3.14 behavior of acpi_auto_serialize, as
> far as I can say, so we can't apply it.
> 
> I still can drop the commits related to auto-serialization from my
> acpica branch.  Which commits are they?

>From linux-pm/bleeding-edge branch, I found this series includes the following commits:

Commit: a0fd108f2da56b769472fc0095616fb370988516
Author: Lv Zheng <lv.zheng@intel.com>
Subject: ACPI: Rename kernel parameter "acpi_serialize" to "acpi_no_auto_serialize"

Commit: 5f1cb4a92e4c4aabd139ff9ca1e11c0e2db2ac59
Author: Lv Zheng <lv.zheng@intel.com>
Subject: ACPICA: Remove global option to serialize all control methods.

Commit: cd52379678785b02d7a357988cfba214fdaf92f4
Author: Bob Moore <robert.moore@intel.com>
Subject: ACPICA: Add global option to disable method auto-serialization.

Commit: f56b05bd111b01141ef74568dc4d262c70295d03
Author: Lv Zheng <lv.zheng@intel.com>
Subject: ACPICA: Add additional named objects for the auto-serialize method scan.

Commit: 27f1899350a1d6baab117c03c87f0e37730047bd
Author: Bob Moore <robert.moore@intel.com>
Subject: ACPICA: Add auto-serialization support for ill-behaved control methods.

Reverting these commits can restore original Linux behavior.
Please check.

Thanks and best regards
-Lv

> 
> > References: http://www.spinics.net/lists/linux-acpi/msg49496.html
> > Reported-by: Valdis Kletnieks <validis.kletnieks@vt.edu>
> > Reported-by: Sabrina Dubroka <sd@queasysnail.net>
> > Signed-off-by: Lv Zheng <lv.zheng@intel.com>
> > ---
> >   Documentation/kernel-parameters.txt |    8 ++++----
> >   drivers/acpi/acpica/acglobal.h      |    2 +-
> >   drivers/acpi/osl.c                  |   12 ++++++------
> >   3 files changed, 11 insertions(+), 11 deletions(-)
> >
> > diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> > index 91f0be8..a159537 100644
> > --- a/Documentation/kernel-parameters.txt
> > +++ b/Documentation/kernel-parameters.txt
> > @@ -229,13 +229,13 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
> >   			use by PCI
> >   			Format: <irq>,<irq>...
> >
> > -	acpi_no_auto_serialize	[HW,ACPI]
> > -			Disable auto-serialization of AML methods
> > +	acpi_auto_serialize	[HW,ACPI]
> > +			Enable auto-serialization of AML methods
> >   			AML control methods that contain the opcodes to create
> >   			named objects will be marked as "Serialized" by the
> >   			auto-serialization feature.
> > -			This feature is enabled by default.
> > -			This option allows to turn off the feature.
> > +			This feature is disabled by default.
> > +			This option allows to turn on the feature.
> >
> >   	acpi_no_auto_ssdt	[HW,ACPI] Disable automatic loading of SSDT
> >
> > diff --git a/drivers/acpi/acpica/acglobal.h b/drivers/acpi/acpica/acglobal.h
> > index 49bbc71..ea0f838 100644
> > --- a/drivers/acpi/acpica/acglobal.h
> > +++ b/drivers/acpi/acpica/acglobal.h
> > @@ -99,7 +99,7 @@ ACPI_INIT_GLOBAL(u8, acpi_gbl_enable_interpreter_slack, FALSE);
> >    * that create named objects are marked Serialized in order to prevent
> >    * possible run-time problems if they are entered by more than one thread.
> >    */
> > -ACPI_INIT_GLOBAL(u8, acpi_gbl_auto_serialize_methods, TRUE);
> > +ACPI_INIT_GLOBAL(u8, acpi_gbl_auto_serialize_methods, FALSE);
> >
> >   /*
> >    * Create the predefined _OSI method in the namespace? Default is TRUE
> > diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
> > index d40d6dc..928f0c2 100644
> > --- a/drivers/acpi/osl.c
> > +++ b/drivers/acpi/osl.c
> > @@ -1538,20 +1538,20 @@ static int __init osi_setup(char *str)
> >   __setup("acpi_osi=", osi_setup);
> >
> >   /*
> > - * Disable the auto-serialization of named objects creation methods.
> > + * Enable the auto-serialization of named objects creation methods.
> >    *
> > - * This feature is enabled by default.  It marks the AML control methods
> > + * This feature is disabled by default.  It marks the AML control methods
> >    * that contain the opcodes to create named objects as "Serialized".
> >    */
> > -static int __init acpi_no_auto_serialize_setup(char *str)
> > +static int __init acpi_auto_serialize_setup(char *str)
> >   {
> > -	acpi_gbl_auto_serialize_methods = FALSE;
> > -	pr_info("ACPI: auto-serialization disabled\n");
> > +	acpi_gbl_auto_serialize_methods = TRUE;
> > +	pr_info("ACPI: auto-serialization enabled\n");
> >
> >   	return 1;
> >   }
> >
> > -__setup("acpi_no_auto_serialize", acpi_no_auto_serialize_setup);
> > +__setup("acpi_auto_serialize", acpi_auto_serialize_setup);
> >
> >   /* Check of resource interference between native drivers and ACPI
> >    * OperationRegions (SystemIO and System Memory only).


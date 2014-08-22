Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664AbaHVChu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 22:37:50 -0400
Received: from mga09.intel.com ([134.134.136.24]:43109 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754822AbaHVChs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 22:37:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,377,1406617200"; 
   d="scan'208";a="591677820"
From: "Tc, Jenny" <jenny.tc@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Sebastian Reichel" <sre@kernel.org>, Pavel Machek <pavel@ucw.cz>
CC: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        "David Woodhouse" <dwmw2@infradead.org>,
        David Cohen <david.a.cohen@linux.intel.com>,
        "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>
Subject: RE: [PATCHv12 0/3] power_supply: Introduce power supply charging
 driver
Thread-Topic: [PATCHv12 0/3] power_supply: Introduce power supply charging
 driver
Thread-Index: AQHPtu+MXRgfqM5uZkKr0fW1ua8cPpvb1ajw
Date: Fri, 22 Aug 2014 02:37:33 +0000
Message-ID: <20ADAB092842284E95860F279283C5642ECF439E@BGSMSX104.gar.corp.intel.com>
References: <1407931799-25596-1-git-send-email-jenny.tc@intel.com>
In-Reply-To: <1407931799-25596-1-git-send-email-jenny.tc@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping...

> -----Original Message-----
> From: Tc, Jenny
> Sent: Wednesday, August 13, 2014 5:40 PM
> To: linux-kernel@vger.kernel.org; Sebastian Reichel; Pavel Machek
> Cc: Dmitry Eremin-Solenikov; Stephen Rothwell; Anton Vorontsov; David
> Woodhouse; David Cohen; Pallala, Ramakrishna; Tc, Jenny
> Subject: [PATCHv12 0/3] power_supply: Introduce power supply charging driver
> 
> v1: Introduced feature as a framework within power supply class driver with
> 	separate files for battid framework and charging framework
> v2: Fixed review comments, moved macros and inline functions to power_supply.h
> v3: Moved the feature as a separate driver, combined battid framework and
> 	charging framework inside the power supply charging driver. Moved
> 	charger specific properties to power_supply_charger.h and plugged the
> 	driver with power supply subsystem using power_supply_notifier
> 	introduced in my previous patch. Also a sample charger chip driver
> 	(bq24261) patch added to give more idea on the psy charging driver
> 	usage
> v4: Fixed review comments, no major design changes.
> v5: Fixed makefile inconsistencies, removed unused pdata callbacks
> v6: Fixed nested loops, commenting style
> v7: added kerneldocs for structs and minor fixes
> v8: used msecs_to_jiffies instead of HZ directly, modified Kconfig help text
>     for POWER_SUPPLY_CHARGING_ALGO_PSE
> v9: Removed string lookups, static cable initialization
> v10: Fixed bug in algorithm lookup
> v11: Few variable name changes for better readability
> v12: Enabled polling and RTC wakeup which is supported in charger-manager as
>      suggested by Sebastian. Fixed review comments from Sebastian and Pavel
> 
> Jenny TC (3):
>   power_supply: Introduce generic psy charging driver
>   power_supply: Introduce PSE compliant algorithm
>   power_supply: bq24261 charger driver
> 
>  Documentation/power/power_supply_charger.txt |  349 +++++++
>  drivers/power/Kconfig                        |   33 +
>  drivers/power/Makefile                       |    3 +
>  drivers/power/bq24261_charger.c              | 1348
> ++++++++++++++++++++++++++
>  drivers/power/charging_algo_pse.c            |  217 +++++
>  drivers/power/power_supply_charger.c         | 1186 ++++++++++++++++++++++
>  drivers/power/power_supply_charger.h         |  225 +++++
>  drivers/power/power_supply_core.c            |    3 +
>  include/linux/power/bq24261-charger.h        |   25 +
>  include/linux/power/power_supply_charger.h   |  374 +++++++
>  include/linux/power_supply.h                 |  161 +++
>  11 files changed, 3924 insertions(+)
>  create mode 100644 Documentation/power/power_supply_charger.txt
>  create mode 100644 drivers/power/bq24261_charger.c  create mode 100644
> drivers/power/charging_algo_pse.c  create mode 100644
> drivers/power/power_supply_charger.c
>  create mode 100644 drivers/power/power_supply_charger.h
>  create mode 100644 include/linux/power/bq24261-charger.h
>  create mode 100644 include/linux/power/power_supply_charger.h
> 
> --
> 1.7.9.5


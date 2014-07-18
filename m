Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760006AbaGRDmj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 23:42:39 -0400
Received: from mga09.intel.com ([134.134.136.24]:39833 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755689AbaGRDmh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 23:42:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,682,1400050800"; 
   d="scan'208";a="545163779"
From: "Tc, Jenny" <jenny.tc@intel.com>
To: Sebastian Reichel <sre@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Dmitry Eremin-Solenikov" <dbaryshkov@gmail.com>,
        Pavel Machek <pavel@ucw.cz>,
        "Anton Vorontsov" <anton.vorontsov@linaro.org>,
        David Woodhouse <dwmw2@infradead.org>,
        David Cohen <david.a.cohen@linux.intel.com>,
        "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>,
        "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>
Subject: RE: [PATCH 2/4] power_supply: Introduce generic psy charging driver
Thread-Topic: [PATCH 2/4] power_supply: Introduce generic psy charging driver
Thread-Index: AQHPmnKNI0r2NBTVDkup5w5zVT7G15ukzBAAgAByGVA=
Date: Fri, 18 Jul 2014 03:38:33 +0000
Message-ID: <20ADAB092842284E95860F279283C56422FBE00C@BGSMSX104.gar.corp.intel.com>
References: <1404799461-26345-1-git-send-email-jenny.tc@intel.com>
 <1404799461-26345-3-git-send-email-jenny.tc@intel.com>
 <20140718021836.GD21934@earth.universe>
In-Reply-To: <20140718021836.GD21934@earth.universe>
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

> From: Sebastian Reichel [mailto:sre@kernel.org]
> Sent: Friday, July 18, 2014 7:49 AM
> To: Tc, Jenny
> Cc: linux-kernel@vger.kernel.org; Dmitry Eremin-Solenikov; Pavel Machek; Anton
> Vorontsov; David Woodhouse; David Cohen; Pallala, Ramakrishna;
> myungjoo.ham@samsung.com
> Subject: Re: [PATCH 2/4] power_supply: Introduce generic psy charging driver
> 
> Hi Jenny,
> 
> On Tue, Jul 08, 2014 at 11:34:19AM +0530, Jenny TC wrote:
> > The Power Supply charging driver connects multiple subsystems to do
> > charging in a generic way. The subsystems involves power_supply,
> > thermal and battery communication subsystems (1wire). With this the
> > charging is handled in a generic way.
> >
> > The driver makes use of different new features - Battery
> > Identification interfaces, pluggable charging algorithms, charger cable arbitrations
> etc.
> > The patch also introduces generic interface for charger cable notifications.
> > Charger cable events and capabilities can be notified using the
> > generic power_supply_notifier chain.
> >
> > Overall this driver removes the charging logic out of the charger chip
> > driver and the charger chip driver can just listen to the request from
> > the power supply charging driver to set the charger properties. This
> > can be implemented by exposing get_property and set property callbacks.
> 
> this seems to be a superset of charger-manager, which is already in the kernel. I
> would prefer not to have two different charger mangement frameworks in the kernel.
> 
> I suggest to add features supported by charger-manager to power supply charging
> driver and convert users of charger-manager to the improved driver.
> 
> I CC'd MyungJoo Ham, who wrote the charger-manager, so that he can also give
> feedback.

We are back to the initial discussions we had in the list. The initial proposal
was for the charger manager. The charger manager is more aligned to
regulator framework, use private notification
mechanisms(cm_notify_event,fullbatt_vchk etc) and relies more on
platform data (struct charger_desc). This doesn't seems to be good to support plug in
charger drivers, charging algorithms, battery identification drivers at runtime.
Power supply charger driver is introduced to meet all these requirements by
extending the existing power_supply subsystem features like
power_supply_changed event, power_supply_register, power supply thermal
throttling mechanism so that plugging new driver would be
easy. Also the user interfaces would remain the same as power_supply subsystem.

Able to locate link on the discussion. 
http://www.gossamer-threads.com/lists/linux/kernel/1562180.


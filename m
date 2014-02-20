Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288AbaBTQnY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 11:43:24 -0500
Received: from mga09.intel.com ([134.134.136.24]:63252 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753754AbaBTQnW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 11:43:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,513,1389772800"; 
   d="scan'208";a="458933509"
From: "Luck, Tony" <tony.luck@intel.com>
To: Andy Lutomirski <luto@amacapital.net>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        Jean Delvare <khali@linux-fr.org>, Guenter Roeck <linux@roeck-us.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rui Wang <ruiv.wang@gmail.com>
Subject: RE: [PATCH v6 4/4] i2c, i2c_imc: Add DIMM bus code
Thread-Topic: [PATCH v6 4/4] i2c, i2c_imc: Add DIMM bus code
Thread-Index: AQHPLaOoTcezEbN7F0GXS4ur/mEeLZq87pWwgAD1VoCAAHSikA==
Date: Thu, 20 Feb 2014 16:42:09 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F31DCD1E1@ORSMSX106.amr.corp.intel.com>
References: <cover.1387588711.git.luto@amacapital.net>
 <15eccfa508fd0f55230c4274e3e968f91a123b73.1387588711.git.luto@amacapital.net>
 <20140219151626.GA13973@katana>
 <CALCETrVBPzGqaXbZVgUZMw7D5U5YnUMJOEsw1r=TceLYjJ39JA@mail.gmail.com>
 <20140220035128.14da0f79.m.chehab@samsung.com>
 <3908561D78D1C84285E8C5FCA982C28F31DCC6F8@ORSMSX106.amr.corp.intel.com>
 <CALCETrVwSj3KGcPqQD2Kd9W5FCHyPWLukCVr0BZLdQc_Fgz4qA@mail.gmail.com>
In-Reply-To: <CALCETrVwSj3KGcPqQD2Kd9W5FCHyPWLukCVr0BZLdQc_Fgz4qA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> NV-DIMM control registers are exposed via i2c, presumably because
> trying to access them through the memory pins would be a giant mess.
> So, one way or another, something needs to be able to initiate
> transactions to access those registers.  BIOS will do some initial
> setup, but the OS will need to poke at these registers, too.  (The
> actual docs are covered by NDA.  I suspect that this will change if
> the manufacturers ever want these things to be widely used, though,
> since these things really want a full-featured kernel driver so that
> things like pmfs will work cleanly.)
>
> As a secondary benefit, having access to the TSOD and SPD is nice,
> albeit far from critical.
>
> AFAICT Intel actively working on NV-DIMM-related things, so maybe
> Intel will contribute an engineer who help :)

Yes - we have people looking at pmfs and NV-DIMMs.  I don't know
the internal details ... to keep these accesses safe may require letting
the platform BIOS code perform them (via some ACPI thingy) ... messy
and slow - but probably workable if these registers are only required
for some maintenance/configuration usage patterns.  Not so good if
they are in the high frequency read/write path (but I2C in the critical
path sounds like a recipe for failure).

-Tony

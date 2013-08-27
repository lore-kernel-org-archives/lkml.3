Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753776Ab3H0TFY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 15:05:24 -0400
Received: from mga01.intel.com ([192.55.52.88]:5018 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753298Ab3H0TFW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 15:05:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,969,1367996400"; 
   d="scan'208";a="387300758"
From: "Yang, Fei" <fei.yang@intel.com>
To: Sam Ravnborg <sam@ravnborg.org>
CC: "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
        "'linux-kernel@vger.kernel.org' (linux-kernel@vger.kernel.org)" 
	<linux-kernel@vger.kernel.org>
Subject: RE: Can anyone suggest a better fix? Not sure if I understand the
	problem, but the patch fixed it
Thread-Topic: Can anyone suggest a better fix? Not sure if I understand the
	problem, but the patch fixed it
Thread-Index: AQHOophf0CjjG6Ws2kGkt7Ne1kn48JmpZ2Gg
Date: Tue, 27 Aug 2013 19:05:20 +0000
Message-ID: <02E7334B1630744CBDC55DA85862258348E458D8@ORSMSX102.amr.corp.intel.com>
References: <02E7334B1630744CBDC55DA85862258348E431C1@ORSMSX102.amr.corp.intel.com>
 <20130826201035.GA21141@merkur.ravnborg.org>
In-Reply-To: <20130826201035.GA21141@merkur.ravnborg.org>
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

>> From: Fei Yang <fei.yang@intel.com>
>> Date: Mon, 26 Aug 2013 11:21:48 -0700
>> Subject: [PATCH] FIXDEP: error opening depfile
>>  
>> Met a kernel build issue where fixdep fails to open a depfile,
>> fixdep: error opening depfile: drivers/driver-name/.driver-code.o.d: 
>> No such file or directory
>> make[4]: *** [drivers/driver-name/driver-code.o] Error 2
>> make[3]: *** [drivers/driver-name] Error 2 Don't know why the expected 
>> file was not created, but the assumption that the file had been 
>> created might not be true, so simply return for such failure.

> I tried to grep:
> git grep "driver-name"
>
> No hits.
>
>Are you trying to fix a build issue with something out-of-tree - or is this only in linux-next?

Oh, I changed the driver and file name in the error message to avoid unnecessary confusion as the driver is not an upstream one. But this issue happens randomly, not 100% reproducible. And it happens on different driver sometimes. So I don't think it would be driver related and pointing out the driver name would not help much anyway.
What I'm trying to understand is under what condition fixdep is triggered in the kernel build process. Is the .d file always generated for every driver? If that file is always created, could it be a timing issue that the .d file was actually created but then deleted when fixdep trying to find it?

Thank you Sam! I'm not familiar with kernel build scripts, any idea is really appreciated.

-Fei


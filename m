Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843Ab3H1Q1u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 12:27:50 -0400
Received: from mga14.intel.com ([143.182.124.37]:45358 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753725Ab3H1Q1s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 12:27:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,976,1367996400"; 
   d="scan'208";a="287929885"
From: "Yang, Fei" <fei.yang@intel.com>
To: Michal Marek <mmarek@suse.cz>
CC: Sam Ravnborg <sam@ravnborg.org>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
        "'linux-kernel@vger.kernel.org' (linux-kernel@vger.kernel.org)" 
	<linux-kernel@vger.kernel.org>
Subject: RE: Can anyone suggest a better fix? Not sure if I understand the
 problem, but the patch fixed it
Thread-Topic: Can anyone suggest a better fix? Not sure if I understand the
 problem, but the patch fixed it
Thread-Index: AQHOpABgg7SaLxkqpE+dFGFmbGSlkJmqxgjQ
Date: Wed, 28 Aug 2013 16:27:46 +0000
Message-ID: <02E7334B1630744CBDC55DA85862258348E4792D@ORSMSX102.amr.corp.intel.com>
References: <02E7334B1630744CBDC55DA85862258348E431C1@ORSMSX102.amr.corp.intel.com>
 <20130826201035.GA21141@merkur.ravnborg.org>
 <02E7334B1630744CBDC55DA85862258348E458D8@ORSMSX102.amr.corp.intel.com>
 <521E1232.6010501@suse.cz>
In-Reply-To: <521E1232.6010501@suse.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>> From: Fei Yang <fei.yang@intel.com>
>>>> Date: Mon, 26 Aug 2013 11:21:48 -0700
>>>> Subject: [PATCH] FIXDEP: error opening depfile
>>>>  
>>>> Met a kernel build issue where fixdep fails to open a depfile,
>>>> fixdep: error opening depfile: drivers/driver-name/.driver-code.o.d: 
>>>> No such file or directory
>>>> make[4]: *** [drivers/driver-name/driver-code.o] Error 2
>>>> make[3]: *** [drivers/driver-name] Error 2 Don't know why the 
>>>> expected file was not created, but the assumption that the file had 
>>>> been created might not be true, so simply return for such failure.
>>> 
>>> I tried to grep:
>>> git grep "driver-name"
>>>
>>> No hits.
>>>
>>> Are you trying to fix a build issue with something out-of-tree - or is this only in linux-next?
>>> 
>> Oh, I changed the driver and file name in the error message to avoid 
>> unnecessary confusion

>You achieved quite the opposite :-).
Yes, that appears to be a bad idea.

>> as the driver is not an upstream one. But this issue happens randomly, 
>> not 100% reproducible. And it happens on different driver sometimes.

>Are you able to reproduce this with the vanilla kernel? If so, details please.
I have not tried vanilla kernel.

>If not, then this can be something with your module's build system. Are you using anything fancier than
>
>$ cat Makefile
>obj-m += my-module.o
>$ make -C <kernel build tree> M=$PWD

> Michal

Nothing fancy except the kernel build is triggered by Android build system. And the driver is being built into the kernel with obj-(CONFIG_MY_DRIVER) += my-driver.o, so it's not even a loadable module.
I thought fixdep is about finding module dependency, and it isn't needed for built-in drivers. Please correct me if I'm wrong. I want to understand if the .d file had never been generated or had been generated but deleted by the time fixdep tries to open it.


Fei


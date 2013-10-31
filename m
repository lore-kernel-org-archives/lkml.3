Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078Ab3JaUWl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 16:22:41 -0400
Received: from mga01.intel.com ([192.55.52.88]:46227 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752769Ab3JaUWj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 16:22:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,611,1378882800"; 
   d="scan'208";a="426056693"
From: "Luck, Tony" <tony.luck@intel.com>
To: Seiji Aguchi <seiji.aguchi@hds.com>, Madper Xie <bbboson@gmail.com>
CC: Madper Xie <cxie@redhat.com>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "ccross@android.com" <ccross@android.com>,
        "anton@enomsg.org" <anton@enomsg.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 0/2] make all stored entries accessible.
Thread-Topic: [PATCH 0/2] make all stored entries accessible.
Thread-Index: AQHO1VTFeljrJQot5kSnramJnOjynpoNuMFggAChDwD//5kvUIAAom2AgADCLID//+laUA==
Date: Thu, 31 Oct 2013 20:22:03 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F31D53A1F@ORSMSX106.amr.corp.intel.com>
References: <1383126294-28793-1-git-send-email-cxie@redhat.com>
 <3908561D78D1C84285E8C5FCA982C28F31D529D7@ORSMSX106.amr.corp.intel.com>
 <A5ED84D3BB3A384992CBB9C77DEDA4D47F9D4476@USINDEM103.corp.hds.com>
 <3908561D78D1C84285E8C5FCA982C28F31D52E99@ORSMSX106.amr.corp.intel.com>
 <87d2mm6t64.fsf@gmail.com>
 <A5ED84D3BB3A384992CBB9C77DEDA4D47F9D4D01@USINDEM103.corp.hds.com>
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D47F9D4D01@USINDEM103.corp.hds.com>
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

>> 1. combine timestamp, count and part into "id".
>>    for now, in efi-pstore.c, *id = part. and we could simply change it
>>    to unique one. F.E. *id = (timestamp * 100 + part) * 100 + count.
>
> My opinion close to 1.
> But, the "*id" should not be the complex one like (timestamp * 100 + part) * 100 + count.
> Rather, it should be a simple sequential number beginning with 1.

I also like option 1 ... but I think the "id" should be a persistent value for
a given saved record.  So some func(timestamp, part, count) would be a
good idea.  If we try using "sequential" numbers - and don't manage to
clear out /sys/fs/pstore each time - then we may have the same "dmesg"
file show up with different names on each boot.

Right now I have a simple script to save & clear ... not much more
complex than:

	cd /sys/fs/pstore
	cp * /var/log/save-pstore
	rm *

This depends on not re-using filenames (otherwise new files in pstore
might overwrite older saved files in my /var/log/save-pstore area).

-Tony

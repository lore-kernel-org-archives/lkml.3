Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751374Ab3KIFHB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 00:07:01 -0500
Received: from mga01.intel.com ([192.55.52.88]:19154 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750831Ab3KIFG6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 00:06:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,665,1378882800"; 
   d="scan'208";a="424668435"
From: "Dixit, Ashutosh" <ashutosh.dixit@intel.com>
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        "Kharche, Harshavardhan R" <harshavardhan.r.kharche@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Rao, Nikhil" <nikhil.rao@intel.com>,
        "Dutt, Sudeep" <sudeep.dutt@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] misc: mic: dead code removal and minor cleanup
Thread-Topic: [PATCH] misc: mic: dead code removal and minor cleanup
Thread-Index: AQHO3QIfGx0Kfsdt00a6C/daJOLW15ocVxuA
Date: Sat, 9 Nov 2013 05:06:57 +0000
Message-ID: <6DC2528F945B4149AB6566DFB5F22ED38AAA142A@ORSMSX109.amr.corp.intel.com>
References: <1383970422-16973-1-git-send-email-michael.opdenacker@free-electrons.com>
In-Reply-To: <1383970422-16973-1-git-send-email-michael.opdenacker@free-electrons.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Michael Opdenacker [mailto:michael.opdenacker@free-electrons.com]
> Sent: Friday, November 08, 2013 8:14 PM
> Subject: [PATCH] misc: mic: dead code removal and minor cleanup
> 
> This removes the below test in drivers/misc/mic/card/mic_virtio.c:
> 
> if (!retry) {
> ...
> }
> 
> This is dead code because the "retry" variable was set to 100
> earlier in the same function.
> 
> This also removes dev_dbg statements to print the value of this variable.
> That's not interesting to print the value of a variable which value is
> always the same.

Hi Michael,

Thanks for your mail. However, the dead code has resulted from
another bug in the code, we should be decrementing retry instead
of i. The same bug occurs in several other places in the code too.

So I would say don't apply this patch. We are planning a series of
patches to fix other issues in the code when the 3.13 merge window
closes and will include this fix too and include you in "Reported-by".

Thanks,
Ashutosh


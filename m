Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046AbaESR7b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 13:59:31 -0400
Received: from mga09.intel.com ([134.134.136.24]:50357 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751171AbaESR73 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 13:59:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,868,1392192000"; 
   d="scan'208";a="514197799"
From: "Luck, Tony" <tony.luck@intel.com>
To: Chen Yucong <slaoub@gmail.com>
CC: "bp@alien8.de" <bp@alien8.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>
Subject: RE: [PATCH] x86/mce: Clear a useless global variable in mce.c
Thread-Topic: [PATCH] x86/mce: Clear a useless global variable in mce.c
Thread-Index: AQHPcciTwzLgOJZKAUyQ4CRuQRCpq5tIMhJg
Date: Mon, 19 May 2014 17:59:23 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F3280E51C@ORSMSX114.amr.corp.intel.com>
References: <1400328343-6483-1-git-send-email-slaoub@gmail.com>
In-Reply-To: <1400328343-6483-1-git-send-email-slaoub@gmail.com>
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

-	atomic_inc(&mce_entry);
-

I have used this in the past (in conjunction with an external debugger) to
diagnose problems (not all cpus showing up in the machine check handler).

But I suppose these can also be diagnosed from the "Timeout synchronizing ..."
message from mce_timed_out() [though with a bit less precision ... we know
that some cpus didn't show up, but we don't have a count of how many did,
or how many are missing.

If we print the value of "mce_callin" somewhere in mce_timed_out() ...
then I think we'd have equivalent functionality (in fact better - because
we don't need the external debugger to peek at mce_entry).

-Tony

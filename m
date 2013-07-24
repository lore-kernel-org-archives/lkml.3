Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752289Ab3GXRBL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 13:01:11 -0400
Received: from mga02.intel.com ([134.134.136.20]:51935 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751153Ab3GXRBJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 13:01:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,736,1367996400"; 
   d="scan'208";a="370329114"
From: "Luck, Tony" <tony.luck@intel.com>
To: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Borislav Petkov" <bp@suse.de>, Chen Gong <gong.chen@linux.intel.com>
Subject: RE: [PATCH] x86/mce: Pay no attention to 'F' bit in MCACOD when
 parsing 'UC' errors.
Thread-Topic: [PATCH] x86/mce: Pay no attention to 'F' bit in MCACOD when
 parsing 'UC' errors.
Thread-Index: AQHOiIYspPjuX7YEhUa+bD/+CCcJ8Jl0C14A
Date: Wed, 24 Jul 2013 17:00:17 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F31C9CAD4@ORSMSX106.amr.corp.intel.com>
References: <0104420@agluck-desk.sc.intel.com>
 <20130724155510.GA29756@naverao1-tp.watson.ibm.com>
In-Reply-To: <20130724155510.GA29756@naverao1-tp.watson.ibm.com>
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

> How about just changing MCACOD to 0xefff? I don't think we ever care
> about the 'F' bit, so we could simplify this by just changing MCACOD.

That certainly reduces the size of the patch ... I was a little worried about
just changing this because it doesn't match the definition of the MCACOD
field in the SDM (Figure 15-5 in 15.3.2.2 IA32_MCi_STATUS MSRS).

But auditing the existing uses of this define - we only currently use it in
places where we are looking for specific recoverable error signatures.
So I think a big comment in mce.h explaining the missing 'F' bit should
suffice.

I'm going to take Chen Gong's suggestion and break this into two patches,
one to fix the regression from the earlier cleanup. Another to tackle the
"F" bit issue.

New patches in a while.

-Tony

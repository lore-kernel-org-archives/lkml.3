Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752978AbaGIVA6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 17:00:58 -0400
Received: from mga11.intel.com ([192.55.52.93]:32954 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750724AbaGIVA5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 17:00:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,633,1400050800"; 
   d="scan'208";a="567559275"
From: "Luck, Tony" <tony.luck@intel.com>
To: Havard Skinnemoen <hskinnemoen@google.com>, Borislav Petkov <bp@alien8.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ewout van Bekkum" <ewout@google.com>
Subject: RE: [PATCH 5/6] x86-mce: check if no_way_out applies before
 deciding not to clear MCE banks.
Thread-Topic: [PATCH 5/6] x86-mce: check if no_way_out applies before
 deciding not to clear MCE banks.
Thread-Index: AQHPm5iX9ZL7m71kC0ibecR2+1ErWJuYOJZA
Date: Wed, 9 Jul 2014 21:00:17 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F328574C3@ORSMSX114.amr.corp.intel.com>
References: <1404925766-32253-1-git-send-email-hskinnemoen@google.com>
 <1404925766-32253-6-git-send-email-hskinnemoen@google.com>
In-Reply-To: <1404925766-32253-6-git-send-email-hskinnemoen@google.com>
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

+	if (!(no_way_out && cfg->tolerant < 3))
 		mce_clear_state(toclear);

Style - I think this is easier to grok:

	if (!no_way_out || cfg->tolerant >=3)
		mce_clear_state(toclear);

but not too strongly if other like !(a && b) form.

I'm never sure how to treat the crazy levels of "tolerant" though.  Do
we really want to clear the banks?  In one sense we do ... we are still
running and might see more UC errors. Since newer UC errors don't
overwrite older ones, clearing the banks allows us to see how many
errors are piling up and being ignored.

But running with tolerant==3 is likely to end in tears ... should we erase
the evidence on what bad things happened?

-Tony

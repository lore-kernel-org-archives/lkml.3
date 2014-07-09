Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756433AbaGIUUt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 16:20:49 -0400
Received: from mga11.intel.com ([192.55.52.93]:6852 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756062AbaGIUUs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 16:20:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,633,1400050800"; 
   d="scan'208";a="559582895"
From: "Luck, Tony" <tony.luck@intel.com>
To: Havard Skinnemoen <hskinnemoen@google.com>, Borislav Petkov <bp@alien8.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ewout van Bekkum" <ewout@google.com>
Subject: RE: [PATCH 2/6] x86-mce: Modify CMCI storm exit to reenable instead
 of rediscover banks.
Thread-Topic: [PATCH 2/6] x86-mce: Modify CMCI storm exit to reenable
 instead of rediscover banks.
Thread-Index: AQHPm5j+9/jcYklCLkGqPwCvlFaVaJuYLliA
Date: Wed, 9 Jul 2014 20:20:41 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F328573E4@ORSMSX114.amr.corp.intel.com>
References: <1404925766-32253-1-git-send-email-hskinnemoen@google.com>
 <1404925766-32253-3-git-send-email-hskinnemoen@google.com>
In-Reply-To: <1404925766-32253-3-git-send-email-hskinnemoen@google.com>
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

> The CMCI storm handler previously called cmci_reenable() when exiting a
> CMCI storm. However, when entering a CMCI storm the bank ownership was
> not relinquished by the affected CPUs. The CMCIs were only disabled via
> cmci_storm_disable_banks(). The handler was updated to instead call a
> new function, cmci_storm_enable_banks(), to reenable CMCI on the already
> owned banks instead of rediscovering CMCI banks (which were still owned
> but disabled).

Won't this cause problems if we online a cpu during the storm. We will
re-run the discovery algorithm and some other cpu that shares the bank
will see MCi_CTL2{30} is zero and claim ownership.

-Tony

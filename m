Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934673Ab3DHBg1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 21:36:27 -0400
Received: from mga03.intel.com ([143.182.124.21]:32174 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934610Ab3DHBgZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 21:36:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,427,1363158000"; 
   d="scan'208";a="282686093"
From: "Li, Fei" <fei.li@intel.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: Chris Ball <cjb@laptop.org>,
        "ulf.hansson@linaro.org" <ulf.hansson@linaro.org>,
        "johan.rudholm@stericsson.com" <johan.rudholm@stericsson.com>,
        "subhashj@codeaurora.org" <subhashj@codeaurora.org>,
        Philip Rakity <prakity@marvell.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "thierry.reding@avionic-design.de" <thierry.reding@avionic-design.de>,
        "sachin.kamat@linaro.org" <sachin.kamat@linaro.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Liu, Chuansheng" <chuansheng.liu@intel.com>
Subject: RE: [PATCH 2/5] mmc: core: call pm_runtime_put_sync in
 pm_runtime_get_sync failed case
Thread-Topic: [PATCH 2/5] mmc: core: call pm_runtime_put_sync in
 pm_runtime_get_sync failed case
Thread-Index: AQHOFYekJxSWLSJpJUKxgdJjzRyxApjKRyCAgAGABSA=
Date: Mon, 8 Apr 2013 01:36:20 +0000
Message-ID: <BEC9F67575FA1E429CA7CF5AE9BE363442B485@SHSMSX102.ccr.corp.intel.com>
References: <1362037031.6212.3.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
 <1362037455.6212.8.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
 <CAK=Wgbb1_CgHpftEFmuqSKcCSjsjvyNCWEYNzQwC4vQKteaerQ@mail.gmail.com>
In-Reply-To: <CAK=Wgbb1_CgHpftEFmuqSKcCSjsjvyNCWEYNzQwC4vQKteaerQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Hi Li,
> 
> On Thu, Feb 28, 2013 at 9:44 AM, Li Fei <fei.li@intel.com> wrote:
> > Even in failed case of pm_runtime_get_sync, the usage_count
> > is incremented. In order to keep the usage_count with correct
> > value and runtime power management to behave correctly, call
> > pm_runtime_put(_sync) in such case.
> 
> As with the remoteproc case, it is probably better to call the
> put_noidle variant here. This way you are sure not to erroneously
> invoke any underlying pm handler where your only intention is to fix
> usage_count.

Thanks for your check and feedback, and will update it in V2 soon.

Regards,
Fei
> 
> Thanks,
> Ohad.

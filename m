Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964982AbaLKVzo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 16:55:44 -0500
Received: from mga11.intel.com ([192.55.52.93]:31710 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751654AbaLKVzn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 16:55:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,560,1413270000"; 
   d="scan'208";a="646306233"
From: "Strasser, Kevin" <kevin.strasser@intel.com>
To: Mark Brown <broonie@kernel.org>
CC: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "Koul, Vinod" <vinod.koul@intel.com>,
        "Lin, Mengdong" <mengdong.lin@intel.com>,
        "Fang, Yang A" <yang.a.fang@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] ASoC: Intel: fix possible acpi enumeration panic
Thread-Topic: [PATCH] ASoC: Intel: fix possible acpi enumeration panic
Thread-Index: AQHQFUV5hrXvYTFNQE+13+CIMdY6QpyK7WFw
Date: Thu, 11 Dec 2014 21:55:38 +0000
Message-ID: <51B6C3CD1F10FB47A5702881E0E230A74A0ECAE1@ORSMSX104.amr.corp.intel.com>
References: <1418282517-851-1-git-send-email-kevin.strasser@intel.com>
 <20141211132026.GY11764@sirena.org.uk>
In-Reply-To: <20141211132026.GY11764@sirena.org.uk>
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

> -----Original Message-----
> From: Mark Brown [mailto:broonie@kernel.org]
> Sent: Thursday, December 11, 2014 5:20 AM> 
> On Wed, Dec 10, 2014 at 11:21:57PM -0800, Kevin Strasser wrote:
> 
> > A crash can occur on some platforms where adsp is enumerated but codec
> > is not matched. Check that the codec_id string is valid before
> > attempting to match.
> 
> > -	for (mach = machines; mach->codec_id; mach++)
> > +	for (mach = machines; mach->codec_id[0]; mach++)
> 
> This changes the check from verifying if a codec_id is present to verifying if
> the first character in the codec_id is non-NULL.  That doesn't seem obviously
> safer and the tables of machines seem to be terminated by having an entry
> with all fields set to zero (which is a common idiom in Linux) which would
> now crash with this change.

In this case mach->codec_id is non-NULL, even for the terminating element, because it
is defined to be a fixed width. So we have to take a look at the first character to see if it
has been initialized.

-Kevin

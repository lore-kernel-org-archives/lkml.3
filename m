Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097AbaI3Gnv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 02:43:51 -0400
Received: from mga01.intel.com ([192.55.52.88]:7543 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750988AbaI3Gnu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 02:43:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,625,1406617200"; 
   d="scan'208";a="607392572"
From: "Bityutskiy, Artem" <artem.bityutskiy@intel.com>
To: "richard@nod.at" <richard@nod.at>
CC: "dedekind1@gmail.com" <dedekind1@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "aschmidt@dekaresearch.com" <aschmidt@dekaresearch.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "ricard.wanderlof@axis.com" <ricard.wanderlof@axis.com>
Subject: Re: [RFC] UBI bitrot checking
Thread-Topic: [RFC] UBI bitrot checking
Thread-Index: AQHP3HmK9M5YuK+yuEuiGISW/y3eAg==
Date: Tue, 30 Sep 2014 06:41:19 +0000
Message-ID: <1412059278.3904.8.camel@sauron.fi.intel.com>
References: <1411509976-12636-1-git-send-email-richard@nod.at>
In-Reply-To: <1411509976-12636-1-git-send-email-richard@nod.at>
Reply-To: "Bityutskiy, Artem" <artem.bityutskiy@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.237.72.54]
Content-Type: text/plain; charset="utf-8"
Content-ID: <21F8B012269B4947A19A6933128F8AC4@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s8U6hup3019756

On Wed, 2014-09-24 at 00:06 +0200, Richard Weinberger wrote:
> This is a very initial draft for one possibility of bitrot checking in UBI.
> The basic idea is to have a worker function which reads a complete PEB and
> schedules scrubbing if bit flips are detected.
> Currently this check is triggered by accessing any UBI debugfs file (yes, I'm lazy!).
> We have to agree on an interface first.
> Do we want a debugfs file? Another ioctl()?
> Automatic in-kernel schedules?
> Of course this interface has to return EBUSY if currently a check is running...
> 
> The current implementation has one limitation, it can only check PEBs which are used.
> As of now ubi_wl_scrub_peb() works only for used PEBs but I think we could change that.

Most probably we do want to give user-space some kind of control. At the
very least:

1. Whether the unflipper (or bitunrotter?) is triggered or not at all
2. When is it triggered
3. Whether the unflipper finished the job or not
4. For #3, it is preferrable that user-space has a possibility to wait
for an event, rather than poll. Should be easy to do with sysfs.

And no, not debugfs, this is not a debugging feature. Sysfs or, less
preferrably, IMO, ioctl.

Then, question - do we want user-space to have more control over the
unflipper, e.g., pause it and resume? E.g., if we are talking a critical
path, like a phone call on a phone, user-space may pause the unflipper
to make sure the phone UI latency stays within certain limits.

We need to consider various usage scenarios and make sure the interface
is suitable.

And we do not have to implement all the features, just make sure we can
add them in the future if needed.

-- 
Best Regards,
Artem Bityutskiy
---------------------------------------------------------------------
Intel Finland Oy
Registered Address: PL 281, 00181 Helsinki 
Business Identity Code: 0357606 - 4 
Domiciled in Helsinki 

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

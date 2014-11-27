Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751555AbaK0OJ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 09:09:57 -0500
Received: from mga09.intel.com ([134.134.136.24]:54318 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019AbaK0OJz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 09:09:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,469,1413270000"; 
   d="scan'208";a="644552635"
From: "Liang, Kan" <kan.liang@intel.com>
To: Namhyung Kim <namhyung@kernel.org>
CC: "acme@kernel.org" <acme@kernel.org>, "jolsa@redhat.com" <jolsa@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Subject: RE: [PATCH V5 3/3] perf tool: check buildid for symoff
Thread-Topic: [PATCH V5 3/3] perf tool: check buildid for symoff
Thread-Index: AQHQCeaf8ZnshsuiH02FNfwCATHuw5x0gVew
Date: Thu, 27 Nov 2014 14:09:51 +0000
Message-ID: <37D7C6CF3E00A74B8858931C1DB2F07701676CB2@SHSMSX103.ccr.corp.intel.com>
References: <1416844829-26945-1-git-send-email-kan.liang@intel.com>
	<1416844829-26945-3-git-send-email-kan.liang@intel.com>
 <87d289o0sz.fsf@sejong.aot.lge.com>
In-Reply-To: <87d289o0sz.fsf@sejong.aot.lge.com>
Accept-Language: zh-CN, en-US
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



> Hi Kan,
> 
> On Mon, 24 Nov 2014 11:00:29 -0500, Kan Liang wrote:
> > From: Kan Liang <kan.liang@intel.com>
> >
> > symoff can support both same binaries and different binaries. However,
> > the offset may be changed for different binaries. This patch checks
> > the buildid of perf.data. If they are from different binaries, print a
> > warning to notify the user.
> 
> Hmm.. I think that perf diff is supposed to compare performance between
> different (i.e. modified) binaries.  So there's a little point to print the
> warning IMHO - but I'm not insist it strongly..
> 
> Anyway, I think what we really need for the warning is different version of
> same binary.  For example, if data file 1 has DSO A and B, and data file 2 has
> DSO B and C, we should not consider they're different (unless build-ids of B
> in data file 1 and 2 are different) since A and C won't affect symoff
> comparision.
>

It looks good.
But I still slightly prefer to warn/inform the user if there are any different dsos,
not just from common part. But it's not a strong option.
I'd like to hear from others.

Arnaldo? Jirka?

Thanks,
Kan
 
> Thanks,
> Namhyung

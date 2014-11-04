Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471AbaKDRIp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 12:08:45 -0500
Received: from mga02.intel.com ([134.134.136.20]:62464 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751305AbaKDRIn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 12:08:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,313,1413270000"; 
   d="scan'208";a="602102692"
From: "Liang, Kan" <kan.liang@intel.com>
To: Namhyung Kim <namhyung@kernel.org>
CC: "acme@kernel.org" <acme@kernel.org>, "jolsa@kernel.org" <jolsa@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>
Subject: RE: [PATCH 1/1] perf tools: perf diff for different binaries
Thread-Topic: [PATCH 1/1] perf tools: perf diff for different binaries
Thread-Index: AQHP9UQ2kXF1b6uO30GrqYg9DeXxZ5xP+aLOgACI6HA=
Date: Tue, 4 Nov 2014 17:07:43 +0000
Message-ID: <37D7C6CF3E00A74B8858931C1DB2F07701653813@SHSMSX103.ccr.corp.intel.com>
References: <1414757172-20064-1-git-send-email-kan.liang@intel.com>
 <87tx2f5xpo.fsf@sejong.aot.lge.com>
In-Reply-To: <87tx2f5xpo.fsf@sejong.aot.lge.com>
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

Hi Namhyung,

> >                             tchain_edit        [.] f1
> >      0.14%        3.913444  tchain_edit        [.] f2
> >     99.82%        1.005478  tchain_edit        [.] f3
> 
> Hmm.. I think it should be a default behavior for perf diff, otherwise -s
> symbol is almost meaningless IMHO. 

I think we need both instruction level and function level diff.
For debugging scaling issue, I think we need to do deeper analysis for some
cache or lock issue. The function level is too high granularity.  

The new option can be used to debug scaling regression issue.
If the binary/kernel is updated, it doesn't make sense to compare the
symbol address, since it should be changed. So comparing the function
should be more useful.


> What about setting the
> sort_sym.se_collapse in data_process() so that hists__match() can use
> symbol names?

Yes, we can set it if we only do function level diff. But I'd like to keep
both. So I defined two sort keys.
"symbol" means "symbol address executed at the time of sample "
"symbol_name" means "name of function executed at the time of sample"

Thanks,
Kan
> 
> Thanks,
> Namhyung

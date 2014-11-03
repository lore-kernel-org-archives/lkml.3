Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690AbaKCOy2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 09:54:28 -0500
Received: from mga14.intel.com ([192.55.52.115]:3852 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752300AbaKCOy0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 09:54:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,308,1413270000"; 
   d="scan'208";a="616036997"
From: "Liang, Kan" <kan.liang@intel.com>
To: Jiri Olsa <jolsa@redhat.com>
CC: "acme@kernel.org" <acme@kernel.org>, "jolsa@kernel.org" <jolsa@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>
Subject: RE: [PATCH 1/1] perf tools: perf diff for different binaries
Thread-Topic: [PATCH 1/1] perf tools: perf diff for different binaries
Thread-Index: AQHP9UQ2kXF1b6uO30GrqYg9DeXxZ5xONHcAgAC3EIA=
Date: Mon, 3 Nov 2014 14:52:39 +0000
Message-ID: <37D7C6CF3E00A74B8858931C1DB2F07701652809@SHSMSX103.ccr.corp.intel.com>
References: <1414757172-20064-1-git-send-email-kan.liang@intel.com>
 <20141103104016.GA19796@krava.brq.redhat.com>
In-Reply-To: <20141103104016.GA19796@krava.brq.redhat.com>
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



> > @@ -1164,6 +1164,9 @@ int cmd_diff(int argc, const char **argv, const
> char *prefix __maybe_unused)
> >  	if (setup_sorting() < 0)
> >  		usage_with_options(diff_usage, options);
> >
> > +	if (sort__has_sym_name)
> > +		tool.mmap2 = perf_event__process_mmap2;
> 
> why is the mmap2 callback set only for sort__has_sym_name?
> Shouldn't we use/define it directly in the tool's definition?
> 

If we define it in tools definition, perf diff will display the differential profile
between functions (Not previous userspace IPs).
For same binary, IPs are same. So I think it's better to compare between IPs.
For different binaries, IPs change. But most of the function names are same for
most binary update case. So we'd better compare between functions.
I want to keep both IP and function compare.
So only new sort key "symble_name" set mmap2 which implies function compare.
If we only need to compare between IPs, we don't need to set mmap2.

Thanks,
Kan

> jirka

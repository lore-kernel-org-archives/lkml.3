Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508AbaKRN51 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 08:57:27 -0500
Received: from mga14.intel.com ([192.55.52.115]:22851 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752212AbaKRN5Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 08:57:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,410,1413270000"; 
   d="scan'208";a="624236433"
From: "Liang, Kan" <kan.liang@intel.com>
To: Namhyung Kim <namhyung@kernel.org>
CC: "acme@kernel.org" <acme@kernel.org>, "jolsa@redhat.com" <jolsa@redhat.com>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "eranian@google.com" <eranian@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "paulus@samba.org" <paulus@samba.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Subject: RE: [PATCH V3 1/3] perf tools: enable LBR call stack support
Thread-Topic: [PATCH V3 1/3] perf tools: enable LBR call stack support
Thread-Index: AQHQAvQ+8txQ4tAb5U2YHX9AXb/4V5xmZw8g
Date: Tue, 18 Nov 2014 13:57:12 +0000
Message-ID: <37D7C6CF3E00A74B8858931C1DB2F077016711E8@SHSMSX103.ccr.corp.intel.com>
References: <1415972652-17310-1-git-send-email-kan.liang@intel.com>
	<1415972652-17310-2-git-send-email-kan.liang@intel.com>
 <87ppclqcif.fsf@sejong.aot.lge.com>
In-Reply-To: <87ppclqcif.fsf@sejong.aot.lge.com>
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


> 
> On Fri, 14 Nov 2014 08:44:10 -0500, kan liang wrote:
> > From: Kan Liang <kan.liang@intel.com>
> >
> > Currently, there are two call chain recording options, fp and dwarf.
> > Haswell has a new feature that utilizes the existing LBR facility to
> > record call chains. So it provides the third options to record call
> > chain. This patch enables the lbr call stack support.
> >
> > LBR call stack has some limitations. It reuses current LBR facility,
> > so LBR call stack and branch record can not be enabled at the same
> > time. It is only available for user callchain.
> > However, LBR call stack can work on the user app which doesn't have
> > frame-pointer or dwarf debug info compiled. It is a good alternative
> > when nothing else works.
> 
> So this is only for Haswell or later, right?  

Right.

>What if user gives it to the other
> CPUs - is it fail or ignore silently?  I think we need to warn user about it
> more kindly..

The kernel will handle it. EOPNOTSUPP will be return if there is no LBR
Call stack support.

Thanks,
Kan

> 
> Thanks,
> Namhyung

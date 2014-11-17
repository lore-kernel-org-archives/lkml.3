Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751919AbaKQJdH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 04:33:07 -0500
Received: from mga01.intel.com ([192.55.52.88]:55030 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751300AbaKQJdF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 04:33:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="417516430"
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Robert Richter <rric@kernel.org>,
        "Frederic Weisbecker" <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, "Paul Mackerras" <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        "Andi Kleen" <ak@linux.intel.com>, "Liang, Kan" <kan.liang@intel.com>,
        "Hunter, Adrian" <adrian.hunter@intel.com>,
        "mathieu.poirier@linaro.org" <mathieu.poirier@linaro.org>,
        "acme@infradead.org" <acme@infradead.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: RE: [PATCH v8 02/14] perf: Add AUX area to ring buffer for raw data
 streams
Thread-Topic: [PATCH v8 02/14] perf: Add AUX area to ring buffer for raw
 data streams
Thread-Index: AQHQABEn9YCSj49H5EmAjQeZXjmYpZxkkV6g
Date: Mon, 17 Nov 2014 09:33:00 +0000
Message-ID: <A78C989F6D9628469189715575E55B231E676088@IRSMSX104.ger.corp.intel.com>
References: <1415972627-37514-1-git-send-email-alexander.shishkin@linux.intel.com>
 <1415972627-37514-3-git-send-email-alexander.shishkin@linux.intel.com>
In-Reply-To: <1415972627-37514-3-git-send-email-alexander.shishkin@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [163.33.239.180]
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Alexander Shishkin [mailto:alexander.shishkin@linux.intel.com]
> Sent: Friday, November 14, 2014 2:44 PM
> To: Peter Zijlstra
> Cc: Ingo Molnar; linux-kernel@vger.kernel.org; Robert Richter; Frederic
> Weisbecker; Mike Galbraith; Paul Mackerras; Stephane Eranian; Andi Kleen;
> Liang, Kan; Hunter, Adrian; Metzger, Markus T; mathieu.poirier@linaro.org;
> acme@infradead.org; Peter Zijlstra; Alexander Shishkin
> Subject: [PATCH v8 02/14] perf: Add AUX area to ring buffer for raw data
> streams
> 
> From: Peter Zijlstra <peterz@infradead.org>
> 
> This patch introduces "AUX space" in the perf mmap buffer, intended for
> exporting high bandwidth data streams to userspace, such as instruction
> flow traces.
> 
> AUX space is a ring buffer, defined by aux_{offset,size} fields in the
> user_page structure, and read/write pointers aux_{head,tail}, which abide
> by the same rules as data_* counterparts of the main perf buffer.
> 
> In order to allocate/mmap AUX, userspace needs to set up aux_offset to
> such an offset that will be greater than data_offset+data_size and
> aux_size to be the desired buffer size. Both need to be page aligned.
> Then, same aux_offset and aux_size should be passed to mmap() call and
> if everything adds up, you should have an AUX buffer as a result.

Why would userspace need to fill in aux_offset and aux_size?  Can't the kernel
do this when userspace mmaps the aux buffer like it does for the respective
data_* fields?

How would userspace fill in those fields if it mapped the data buffer read-only?

Regards,
Markus.

Intel GmbH
Dornacher Strasse 1
85622 Feldkirchen/Muenchen, Deutschland
Sitz der Gesellschaft: Feldkirchen bei Muenchen
Geschaeftsfuehrer: Christian Lamprechter, Hannes Schwaderer, Douglas Lusk
Registergericht: Muenchen HRB 47456
Ust.-IdNr./VAT Registration No.: DE129385895
Citibank Frankfurt a.M. (BLZ 502 109 00) 600119052


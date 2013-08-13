Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759151Ab3HMRjF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 13:39:05 -0400
Received: from mga03.intel.com ([143.182.124.21]:23865 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759124Ab3HMRjD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 13:39:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,871,1367996400"; 
   d="scan'208";a="345817804"
From: "Luck, Tony" <tony.luck@intel.com>
To: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Borislav Petkov <bp@alien8.de>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "rjw@sisk.pl" <rjw@sisk.pl>, "lance.ortiz@hp.com" <lance.ortiz@hp.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Aristeu Rozanski Filho" <arozansk@redhat.com>
Subject: RE: [PATCH 3/3] mce: acpi/apei: trace: Enable ghes memory error
 trace event
Thread-Topic: [PATCH 3/3] mce: acpi/apei: trace: Enable ghes memory error
 trace event
Thread-Index: AQHOlGVcQB6qi1wV3Ei8qYoYEneewpmMKjwAgAMKHwCAArfagIAAEviAgAAiKACAAV9FAIAAEOaAgABNEAD//407sA==
Date: Tue, 13 Aug 2013 17:39:00 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F31CB8DB5@ORSMSX106.amr.corp.intel.com>
References: <1375986471-27113-1-git-send-email-naveen.n.rao@linux.vnet.ibm.com>
 <1375986471-27113-4-git-send-email-naveen.n.rao@linux.vnet.ibm.com>
 <20130808163822.67e0828a@samsung.com> <20130810180322.GC4155@pd.tnic>
 <20130812083355.47c1bae8@samsung.com> <5208D80D.5030206@linux.vnet.ibm.com>
 <20130812114404.3bd64fa0@samsung.com> <520A1B5E.8040105@linux.vnet.ibm.com>
 <20130813094147.062317f8@concha.lan> <520A6A30.1030406@linux.vnet.ibm.com>
In-Reply-To: <520A6A30.1030406@linux.vnet.ibm.com>
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

> In the meantime, like Boris suggests, I think we can have a different 
> trace event for raw APEI reports - userspace can use it as it pleases.
>
> Once ghes_edac gets better, users can decide whether they want raw APEI 
> reports or the EDAC-processed version and choose one or the other trace 
> event.

It's cheap to add as many tracepoints as we like - but may be costly to maintain.
Especially if we have to tinker with them later to adjust which things are logged,
that puts a burden on user-space tools to be updated to adapt to the changing
API.

Mauro has written his user-space tool to process the ghes-edac events:
  git://git.fedorahosted.org/rasdaemon.git

Who is writing the user space tools to process the new apei tracepoints
you want to add?

I'm not opposed to these patches - just wondering who is taking the next step
to make them useful.

-Tony

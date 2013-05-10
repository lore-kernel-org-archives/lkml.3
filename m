Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752663Ab3EJSNx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 14:13:53 -0400
Received: from mga11.intel.com ([192.55.52.93]:38357 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751731Ab3EJSNw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 14:13:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,650,1363158000"; 
   d="scan'208";a="335645404"
From: "Luck, Tony" <tony.luck@intel.com>
To: Ming Lei <Ming.Lei@riverbed.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "mchehab@redhat.com" <mchehab@redhat.com>, "bp@alien8.de" <bp@alien8.de>
Subject: RE: x86_mce: mce_start uses number of phsical cores instead of
 logical cores
Thread-Topic: x86_mce: mce_start uses number of phsical cores instead of
 logical cores
Thread-Index: Ac5NnrX+OJKCA1vXQtyGCRlOybefOwACkHHw
Date: Fri, 10 May 2013 18:13:50 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F2DA4C92B@ORSMSX106.amr.corp.intel.com>
References: <2CE44BD3DBCF9541909CCB42F11CA3921C6FAA49@SFO1EXC-MBXP06.nbttech.com>
In-Reply-To: <2CE44BD3DBCF9541909CCB42F11CA3921C6FAA49@SFO1EXC-MBXP06.nbttech.com>
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

> +#if NR_CPUS > 1
> +	cpus /= cpumask_weight(cpu_core_mask(0)) / cpu_data(0).booted_cores;
> +#endif

Not entirely sure what you are trying to do here (apart from making "cpus"
be a smaller number).  What is the reasoning behind the right hand side of
this expression?

Is this problem more related to how EDAC is injecting an error?  When I've
used other methods (e.g. ACPI/EINJ) I end up with a machine check that is
broadcast to all processors ... so "cpus = num_online_cpus()" is the correct[1]
number of processors to wait for.

-Tony

[1] Andi may point me (again) to a fix to help deal with the case that Linux
has taken some cpus offline. In that case this code is wrong as the "offline"
cpus will still show up for machine checks.  But there are troubling corner
cases with the fix.

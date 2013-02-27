Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760614Ab3B0RvA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 12:51:00 -0500
Received: from mga01.intel.com ([192.55.52.88]:43253 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760049Ab3B0Ru5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 12:50:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,749,1355126400"; 
   d="scan'208";a="292631992"
From: "Luck, Tony" <tony.luck@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
CC: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Don Morris <don.morris@hp.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Renninger <trenn@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tim Gardner <tim.gardner@canonical.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "Sakkinen, Jarkko" <jarkko.sakkinen@intel.com>,
        "tangchen@cn.fujitsu.com" <tangchen@cn.fujitsu.com>
Subject: RE: sched: CPU #1's llc-sibling CPU #0 is not on the same node!
Thread-Topic: sched: CPU #1's llc-sibling CPU #0 is not on the same node!
Thread-Index: AQHOE6qbrptHZR8AM0GbSwJ5BXpveZiNMXQAgAAS8ICAACPFAIAAfMUwgACaQID//34c0A==
Date: Wed, 27 Feb 2013 17:50:49 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F1E06EDDD@ORSMSX108.amr.corp.intel.com>
References: <512B7D10.4060304@tpi.com>	<512B8407.2090807@canonical.com>
	<512BD753.4080001@hp.com>
	<CAE9FiQVY4io_mO3PhTtE6FbGUgo1uZKKXO=pjx_FoZ1JuZmsAw@mail.gmail.com>
	<CAE9FiQXRZ2VjfG4L2d2zDQ3Sud=JqjS=M9=XW=ORS58_y7i4_g@mail.gmail.com>
	<CAE9FiQU-CV4mF8x=Bi_4pmpmeZW-tSoes_f-jOt7yYrbrppo+A@mail.gmail.com>
	<512D58C2.1090403@jp.fujitsu.com>
	<3908561D78D1C84285E8C5FCA982C28F1E06EB22@ORSMSX108.amr.corp.intel.com>
 <CAE9FiQV+FGmUwOgMJkcUkxdGgO_xgUEVQJ5eiLJPkjXa8XGRig@mail.gmail.com>
In-Reply-To: <CAE9FiQV+FGmUwOgMJkcUkxdGgO_xgUEVQJ5eiLJPkjXa8XGRig@mail.gmail.com>
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

>   b. it will be freed to slub before run time.
>       like init code and initrd disk.

If this is a problem - I'd be inclined to disable the code that frees it. It's only
a few hundred KB of code, and possibly a few MB of initrd. Too small to
worry about on a hot pluggable server.

> In that case, so they should just boot system with numa=off.

But we will still care about NUMA locality.

-Tony

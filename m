Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790Ab3B0Q2o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 11:28:44 -0500
Received: from mga01.intel.com ([192.55.52.88]:13890 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752037Ab3B0Q2n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 11:28:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,747,1355126400"; 
   d="scan'208";a="292591990"
From: "Luck, Tony" <tony.luck@intel.com>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Yinghai Lu <yinghai@kernel.org>
CC: Don Morris <don.morris@hp.com>, "H. Peter Anvin" <hpa@zytor.com>,
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
Thread-Index: AQHOE6qbrptHZR8AM0GbSwJ5BXpveZiNMXQAgAAS8ICAACPFAIAAfMUw
Date: Wed, 27 Feb 2013 16:28:29 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F1E06EB22@ORSMSX108.amr.corp.intel.com>
References: <512B7D10.4060304@tpi.com> <512B8407.2090807@canonical.com>
 <512BD753.4080001@hp.com>
 <CAE9FiQVY4io_mO3PhTtE6FbGUgo1uZKKXO=pjx_FoZ1JuZmsAw@mail.gmail.com>
 <CAE9FiQXRZ2VjfG4L2d2zDQ3Sud=JqjS=M9=XW=ORS58_y7i4_g@mail.gmail.com>
 <CAE9FiQU-CV4mF8x=Bi_4pmpmeZW-tSoes_f-jOt7yYrbrppo+A@mail.gmail.com>
 <512D58C2.1090403@jp.fujitsu.com>
In-Reply-To: <512D58C2.1090403@jp.fujitsu.com>
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

> assume first cpu only have 1G ram, and other 31 socket will have bunch of ram

That doesn't seem to be a very realistic assumption. Can you even still buy 1G
DIMMs for servers?   I'd think that a minimum would be to have each of four
channels populated with a 4G DIMM - so 16GB on first cpu. But even that feels
rather low.

I think that making sure that the system can boot is good (and maybe it should
ignore/override[*] parameters that would prevent booting). But let's be realistic
about the cases we actually have to deal with (before somebody comes and talks
about systems with just 16MB).

-Tony

[*] with some noisy warnings in the console log

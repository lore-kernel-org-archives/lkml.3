Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761525Ab3DBQmc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 12:42:32 -0400
Received: from mga02.intel.com ([134.134.136.20]:60898 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752238Ab3DBQma convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 12:42:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,394,1363158000"; 
   d="scan'208";a="288304982"
From: "Luck, Tony" <tony.luck@intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Al Viro <viro@ZenIV.linux.org.uk>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Richard Weinberger <richard@nod.at>
Subject: RE: linux-next: manual merge of the vfs tree with the ia64 tree
Thread-Topic: linux-next: manual merge of the vfs tree with the ia64 tree
Thread-Index: AQHOLzfwQtaoNcttC0yqLGbbYmtjpJjDH4gA
Date: Tue, 2 Apr 2013 16:42:27 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F1E09672C@ORSMSX108.amr.corp.intel.com>
References: <20130402112017.8c5e288cbbd31f93788df9d5@canb.auug.org.au>
In-Reply-To: <20130402112017.8c5e288cbbd31f93788df9d5@canb.auug.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Today's linux-next merge of the vfs tree got a conflict in
> arch/ia64/kernel/palinfo.c between commit 40c275bd92b8 ("[IA64] Fix stack
> overflow in create_palinfo_proc_entries") from the ia64 tree and commit
> d8e904861a28 ("palinfo fixes") from the vfs tree.
>
> I fixed it up (arbitrarily choosing the vfs tree version) and can carry
> the fix as necessary (no action is required).

It looks like you picked the version from the ia64 tree - but it would have
been better to pick Al's version. He wastes less space on the stack by only
declaring cpustr[3+4+1] instead of cpustr[32], but more importantly he
checks the return value from proc_mkdir().

I'll drop 40c275bd92b8 out of my tree so Al's can go in without a conflict.

-Tony

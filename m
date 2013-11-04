Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887Ab3KDNmn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 08:42:43 -0500
Received: from mga03.intel.com ([143.182.124.21]:23464 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751632Ab3KDNml convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 08:42:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="384398187"
From: "Marciniszyn, Mike" <mike.marciniszyn@intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Roland Dreier <roland@kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jan Kara <jack@suse.cz>
Subject: RE: linux-next: build warning after merge of the infiniband tree
Thread-Topic: linux-next: build warning after merge of the infiniband tree
Thread-Index: AQHO2Roewu9GUMZjTU+DJautUJNixpoVFEfA
Date: Mon, 4 Nov 2013 13:42:39 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC211C6448@FMSMSX107.amr.corp.intel.com>
References: <20131104155526.10e5aed0cd9512c47a82529f@canb.auug.org.au>
In-Reply-To: <20131104155526.10e5aed0cd9512c47a82529f@canb.auug.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.200.108]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This issue was caught by Tetsuo Handa and Acked on 10/30: http://marc.info/?t=138313364500008&r=1&w=2.

Roland, I noticed that the Tetsuo's original message didn't cc the linux-rdma list?

Mike

> -----Original Message-----
> From: Stephen Rothwell [mailto:sfr@canb.auug.org.au]
> Sent: Sunday, November 03, 2013 11:55 PM
> To: Roland Dreier; linux-rdma@vger.kernel.org
> Cc: linux-next@vger.kernel.org; linux-kernel@vger.kernel.org; Jan Kara;
> Marciniszyn, Mike
> Subject: linux-next: build warning after merge of the infiniband tree
> 
> Hi all,
> 
> After merging the infiniband tree, today's linux-next build (x86_64
> allmodconfig) produced this warning:
> 
> drivers/infiniband/hw/ipath/ipath_user_sdma.c: In function
> 'ipath_user_sdma_pin_pages':
> drivers/infiniband/hw/ipath/ipath_user_sdma.c:283:6: warning: 'j' is used
> uninitialized in this function [-Wuninitialized]
>   ret = get_user_pages_fast(addr, j, 0, pages);
>       ^
> 
> Introduced by commit 18fec3c6bdcb ("IB/ipath: Convert
> ipath_user_sdma_pin_pages() to use get_user_pages_fast()").  How did that
> pass review or testing?
> 
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au

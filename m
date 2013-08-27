Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630Ab3H0Axm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 20:53:42 -0400
Received: from mga09.intel.com ([134.134.136.24]:22962 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752341Ab3H0Axl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 20:53:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,963,1367996400"; 
   d="scan'208";a="368881767"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Eric Dumazet <eric.dumazet@gmail.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] Fix the race between the fget() and close()
Thread-Topic: [PATCH] Fix the race between the fget() and close()
Thread-Index: AQHOor5eQoUh+gkBHky3V+tcfqcdo5moOHMA
Date: Tue, 27 Aug 2013 00:53:37 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A01AEEE9C@SHSMSX101.ccr.corp.intel.com>
References: <1377533569.26153.3.camel@cliu38-desktop-build>
 <20130826112946.GD27005@ZenIV.linux.org.uk>
 <27240C0AC20F114CBF8149A2696CBE4A01AEEE31@SHSMSX101.ccr.corp.intel.com>
 <20130827004247.GG27005@ZenIV.linux.org.uk>
In-Reply-To: <20130827004247.GG27005@ZenIV.linux.org.uk>
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

Thanks Al.

> -----Original Message-----
> From: Al Viro [mailto:viro@ftp.linux.org.uk] On Behalf Of Al Viro
> Sent: Tuesday, August 27, 2013 8:43 AM
> To: Liu, Chuansheng
> Cc: Eric Dumazet; linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] Fix the race between the fget() and close()
> 
> On Mon, Aug 26, 2013 at 11:56:43PM +0000, Liu, Chuansheng wrote:
> 
> 
> Hell, might be buggered refcounting on descriptor table - binder is playing
I also suspected binder do some strange thing there, but in the panic log, there is another
process causes this case during vfs_read(), maybe it is not related with binder totally.
<1>[  392.669816] BUG: unable to handle kernel NULL pointer dereference at 00000020
<1>[  392.678055] IP: [<c131c8a7>] vfs_read+0x97/0x160

> interesting games there.  Try to reproduce that with
> CONFIG_DEBUG_KMEMLEAK
> and slab debugging turned on, see if you hit anything from those; if it's
> more or less readily reproducible, I would start with that - too many
> scenarios involve broken refcounting of one sort or another.
It is not easy to hit, will try with CONFIG_DEBUG_KMEMLEAK and SLAB DEBUGGING on.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758907Ab3BZQ5m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 11:57:42 -0500
Received: from mga09.intel.com ([134.134.136.24]:57412 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751833Ab3BZQ5k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 11:57:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,742,1355126400"; 
   d="scan'208";a="267932370"
Subject: Re: [PATCH 2/3 v2] Optimize CRC32C calculation with PCLMULQDQ
 instruction
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "David S. Miller" <davem@davemloft.net>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Chaohong Guo <chaohong.guo@intel.com>,
        Austin Zhang <austin_zhang@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org,
        James Guilford <james.guilford@intel.com>,
        Wajdi Feghali <wajdi.k.feghali@intel.com>, Min Li <min.a.li@intel.com>,
        David Cote <david.m.cote@intel.com>,
        Fengguang Wu <fengguang.wu@intel.com>
In-Reply-To: <20130226095424.GA19924@gondor.apana.org.au>
References: <cover.1348784343.git.tim.c.chen@linux.intel.com>
	 <1348785862.17632.17.camel@schen9-DESK>
	 <20130226095424.GA19924@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Feb 2013 08:57:41 -0800
Message-ID: <1361897861.17632.222.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-02-26 at 17:54 +0800, Herbert Xu wrote:
> On Thu, Sep 27, 2012 at 03:44:22PM -0700, Tim Chen wrote:
> > This patch adds the crc_pcl function that calculates CRC32C checksum using the
> > PCLMULQDQ instruction on processors that support this feature. This will
> > provide speedup over using CRC32 instruction only.
> > The usage of PCLMULQDQ necessitate the invocation of kernel_fpu_begin and
> > kernel_fpu_end and incur some overhead.  So the new crc_pcl function is only
> > invoked for buffer size of 512 bytes or more.  Larger sized
> > buffers will expect to see greater speedup.  This feature is best used coupled
> > with eager_fpu which reduces the kernel_fpu_begin/end overhead.  For
> > buffer size of 1K the speedup is around 1.6x and for buffer size greater than
> > 4K, the speedup is around 3x compared to original implementation in crc32c-intel
> > module. Test was performed on Sandy Bridge based platform with constant frequency
> > set for cpu.
> > 
> > A white paper detailing the algorithm can be found here:
> > http://download.intel.com/design/intarch/papers/323405.pdf
> > 
> > Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>

Acked.  

BTW, Herbert, I've also sent you a patch a few days ago to update the
link to the whitepaper on the CRC32C algorithm in the code.  Wonder if
you have received it.  Thanks.

Tim


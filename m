Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758062Ab3EGBMw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 21:12:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:22467 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753515Ab3EGBMt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 21:12:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,624,1363158000"; 
   d="scan'208";a="332867506"
Subject: Re: [PATCH v3 0/4] Patchset to use PCLMULQDQ to accelerate
 CRC-T10DIF checksum computation
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "David S. Miller" <davem@davemloft.net>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        Jim Kukunas <james.t.kukunas@linux.intel.com>,
        Keith Busch <keith.busch@intel.com>,
        Erdinc Ozturk <erdinc.ozturk@intel.com>,
        Vinodh Gopal <vinodh.gopal@intel.com>,
        James Guilford <james.guilford@intel.com>,
        Wajdi Feghali <wajdi.k.feghali@intel.com>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <cover.1367436101.git.tim.c.chen@linux.intel.com>
References: <cover.1367436101.git.tim.c.chen@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 06 May 2013 18:12:52 -0700
Message-ID: <1367889172.27102.261.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-05-01 at 12:52 -0700, Tim Chen wrote:
> Currently the CRC-T10DIF checksum is computed using a generic table lookup
> algorithm.  By switching the checksum to PCLMULQDQ based computation,
> we can speedup the computation by 8x for checksumming 512 bytes and
> even more for larger buffer size.  This will improve performance of SCSI
> drivers turning on the CRC-T10IDF checksum.  In our SSD based experiments,
> we have seen increase disk throughput by 3.5x with T10DIF for 512 byte
> block size.
> 
> This patch set provides the x86_64 routine using PCLMULQDQ instruction
> and switches the crc_t10dif library function to use the faster PCLMULQDQ
> based routine when available.
> 
> Tim
> 
> v3
> 1. Update the crct10dif crypto transform used in the crct10dif library in a safe way.
> 2. Load the accelerated t10dif transform for the x86_64 cpus that support it.
> 3. Added generic crct10dif crypto transform.
> 

Herbert,

Any feedback on this updated patchset?  Thanks.

Tim


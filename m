Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069AbaE1XCi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 19:02:38 -0400
Received: from mga02.intel.com ([134.134.136.20]:11622 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753791AbaE1XCh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 19:02:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,931,1392192000"; 
   d="scan'208";a="548053643"
Subject: Re: [PATCH v2] crypto: crc32c-pclmul - Shrink K_table to 32-bit
 words
From: Tim Chen <tim.c.chen@linux.intel.com>
To: George Spelvin <linux@horizon.com>
Cc: herbert@gondor.apana.org.au, JBeulich@suse.com, david.m.cote@intel.com,
        james.guilford@intel.com, linux-kernel@vger.kernel.org,
        sandyw@twitter.com, wajdi.k.feghali@intel.com
In-Reply-To: <20140528221505.30342.qmail@ns.horizon.com>
References: <20140528221505.30342.qmail@ns.horizon.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 May 2014 16:02:15 -0700
Message-ID: <1401318135.2970.399.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-05-28 at 18:15 -0400, George Spelvin wrote:
> crypto: crc32c-pclmul - Shrink K_table to 32-bit words
> 
> There's no need for the K_table to be made of 64-bit words.  For some
> reason, the original authors didn't fully reduce the values modulo the
> CRC32C polynomial, and so had some 33-bit number in there.  They
> can all be reduced to 32 bits.
> 
> Doing that cuts the table size in half.  Since the code depends on both
> pclmulq and crc32, SSE 4.1 is obviously present, so we can use pmovzxdq
> to fetch it in the correct format.
> 
> Two other related fixes:
> * K_table is read-only, so belongs in .text, not .data, and
> * There's no need for more than 8-byte alignment

George,

Can you do a tcrypt speed measurement with and without your changes?
Check to see if there's any slowdown.  Please make sure you pin
the frequency of your cpu when running the test.  

e.g.
echo performance > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor

Thanks.

Tim



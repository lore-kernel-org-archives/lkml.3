Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933903Ab3CSU3N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 16:29:13 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:11359 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933873Ab3CSU3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 16:29:12 -0400
Message-ID: <1363724947.4519.9.camel@lorien2>
Subject: Re: [PATCH 1/2] dma-debug: Fix locking bug in check_unmap
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: Alexander Duyck <alexander.h.duyck@intel.com>
Cc: linux-kernel@vger.kernel.org, konrad.wilk@oracle.com, joerg.roedel@amd.com,
        konrad@kernel.org, christoph.paasch@uclouvain.be, mingo@redhat.com,
        hpa@zytor.com, akpm@linux-foundation.org, netdev@vger.kernel.org,
        jeffrey.t.kirsher@intel.com, shuah.khan@hp.com
Date: Tue, 19 Mar 2013 14:29:07 -0600
In-Reply-To: <20130318221243.7349.64147.stgit@ahduyck-cp1.jf.intel.com>
References: <20130318220241.7349.5030.stgit@ahduyck-cp1.jf.intel.com>
	 <20130318221243.7349.64147.stgit@ahduyck-cp1.jf.intel.com>
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-03-18 at 15:12 -0700, Alexander Duyck wrote:
> In check_unmap it is possible to get into a dead-locked state if
> dma_mapping_error is called.  The problem is that the bucket is locked in
> check_unmap, and locked again by debug_dma_mapping_error which is called by
> dma_mapping_error.  To resolve that we must release the lock on the bucket
> before making the call to dma_mapping_error.
> 
> Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>

Looks good.

Reviewed-by: Shuah Khan
Tested-by Shuah Khan

Thanks for finding and fixing the problem.
-- Shuah



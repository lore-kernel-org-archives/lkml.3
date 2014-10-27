Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751858AbaJ0GlE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 02:41:04 -0400
Received: from ozlabs.org ([103.22.144.67]:45884 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149AbaJ0GlC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 02:41:02 -0400
In-Reply-To: <1414383875-20835-1-git-send-email-imunsie@au.ibm.com>
To: Ian Munsie <imunsie@au1.ibm.com>, mpe <mpe@ellerman.id.au>
From: Michael Ellerman <mpe@ellerman.id.au>
Cc: cbe-oss-dev <cbe-oss-dev@lists.ozlabs.org>, mikey <mikey@neuling.org>,
        arnd <arnd@arndb.de>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        greg <greg@kroah.com>, linux-kernel <linux-kernel@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@ozlabs.org>, anton <anton@samba.org>,
        imunsie <imunsie@au1.ibm.com>, jk <jk@ozlabs.org>
Subject: Re: CXL: Fix PSL error due to duplicate segment table entries
Message-Id: <20141027064100.D12B514007D@ozlabs.org>
Date: Mon, 27 Oct 2014 17:41:00 +1100 (AEDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-27-10 at 04:24:35 UTC, Ian Munsie wrote:
> From: Ian Munsie <imunsie@au1.ibm.com>
> 
> In certain circumstances the PSL can send an interrupt for a segment

Define PSL before using it please.

> miss that the kernel has already handled. This can happen if multiple
> translations for the same segment are queued in the PSL before the
> kernel has restarted the first translation.
> 
> The CXL driver did not expect this situation and did not check if a

does not and does not, you haven't patched it yet.

> segment had already been handled. This could cause a duplicate segment
> table entry which in turn caused a PSL error taking down the card.
> 
> This patch fixes the issue by checking for existing entries in the
> segment table that match the segment it is trying to insert to avoid
> inserting duplicate entries.
> 
> Some of the code has been refactored to simplify it - the segment table
> hash has been moved from cxl_load_segment to find_free_sste where it is

Any reason that's not a separate patch?

> used and we have disabled the secondary hash in the segment table to
> reduce the number of entries that need to be tested from 16 to 8. Due to
> the large segment sizes we use it is extremely unlikely that the
> secondary hash would ever have been used in practice, so this should not
> have any negative impacts and may even improve performance.

Any reason that's not a separate patch?

> copro_calculate_slb will now mask the ESID by the correct mask for 1T vs

Didn't, but will after this patch?

> 256M segments. This has no effect by itself as the extra bits were
> ignored, but it makes debugging the segment table entries easier and
> means that we can directly compare the ESID values for duplicates
> without needing to worry about masking in the comparison.

Separate patch?

cheers

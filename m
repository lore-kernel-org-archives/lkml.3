Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752990AbaJ1ARw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 20:17:52 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:59036 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369AbaJ1ARu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 20:17:50 -0400
Content-Type: text/plain; charset=UTF-8
From: Ian Munsie <imunsie@au1.ibm.com>
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: cbe-oss-dev <cbe-oss-dev@lists.ozlabs.org>, mikey <mikey@neuling.org>,
        arnd <arnd@arndb.de>, jk <jk@ozlabs.org>, greg <greg@kroah.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@ozlabs.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        anton <anton@samba.org>
Subject: Re: CXL: Fix PSL error due to duplicate segment table entries
In-reply-to: <20141027064100.D12B514007D@ozlabs.org>
References: <20141027064100.D12B514007D@ozlabs.org>
Date: Tue, 28 Oct 2014 11:17:47 +1100
Message-Id: <1414455360-sup-2142@delenn.ozlabs.ibm.com>
User-Agent: Sup/0.20.0
Content-Transfer-Encoding: 8bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102800-0005-0000-0000-000000EA4512
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Excerpts from Michael Ellerman's message of 2014-10-27 17:41:00 +1100:
> On Mon, 2014-27-10 at 04:24:35 UTC, Ian Munsie wrote:
> > From: Ian Munsie <imunsie@au1.ibm.com>
> > 
> > In certain circumstances the PSL can send an interrupt for a segment
> 
> Define PSL before using it please.

ok

> > The CXL driver did not expect this situation and did not check if a
> 
> does not and does not, you haven't patched it yet.

ok

> > Some of the code has been refactored to simplify it - the segment table
> > hash has been moved from cxl_load_segment to find_free_sste where it is
> 
> Any reason that's not a separate patch?

ok, I'll split it.

> > used and we have disabled the secondary hash in the segment table to
> > reduce the number of entries that need to be tested from 16 to 8. Due to
> > the large segment sizes we use it is extremely unlikely that the
> > secondary hash would ever have been used in practice, so this should not
> > have any negative impacts and may even improve performance.
> 
> Any reason that's not a separate patch?

ok, I'll split it.

> > copro_calculate_slb will now mask the ESID by the correct mask for 1T vs
> 
> Didn't, but will after this patch?

ok, will reword

> > 256M segments. This has no effect by itself as the extra bits were
> > ignored, but it makes debugging the segment table entries easier and
> > means that we can directly compare the ESID values for duplicates
> > without needing to worry about masking in the comparison.
> 
> Separate patch?

ok, I'll split it.

Cheers,
-Ian


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313AbaJ1AUW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 20:20:22 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:39933 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692AbaJ1AUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 20:20:21 -0400
Content-Type: text/plain; charset=UTF-8
From: Ian Munsie <imunsie@au1.ibm.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: mpe <mpe@ellerman.id.au>, cbe-oss-dev <cbe-oss-dev@lists.ozlabs.org>,
        mikey <mikey@neuling.org>, arnd <arnd@arndb.de>, greg <greg@kroah.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@ozlabs.org>, anton <anton@samba.org>,
        jk <jk@ozlabs.org>
Subject: Re: [PATCH] CXL: Fix PSL error due to duplicate segment table entries
In-reply-to: <87oasxy3v2.fsf@linux.vnet.ibm.com>
References: <1414383875-20835-1-git-send-email-imunsie@au.ibm.com> <87oasxy3v2.fsf@linux.vnet.ibm.com>
Date: Tue, 28 Oct 2014 11:20:20 +1100
Message-Id: <1414455469-sup-9840@delenn.ozlabs.ibm.com>
User-Agent: Sup/0.20.0
Content-Transfer-Encoding: 8bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102800-0025-0000-0000-00000063EE4A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Excerpts from Aneesh Kumar K.V's message of 2014-10-28 01:38:41 +1100:
> I guess you are missing too many fixes in one patch.
> 
> 1) One cleanup
> 2) Fix for masking ea correctly
> 3) And fix for not erroring out when a slb is already in the slb cache.

ok, I'll split it up

> > +/* This finds a free SSTE and checks to see if it's already in table */
> > +static struct cxl_sste* find_free_sste(struct cxl_context *ctx,
> > +                       struct copro_slb *slb)
> 
> the name is confusing. If you want to keep the name, can you also
> specify that it return NULL, if it finds a matching entry. IIUC that
> is the real part of the fix for the problem mentioned ?

Good point.

> > -    sr = CXL_PSL_SR_An_SC;
> > +    sr = 0;
> 
> What is this change about ?

That tells the PSL not to use the secondary hash since we are no longer
filling out any entries using it. I'll clarify that in the commit
message when I split this out.

Cheers,
-Ian


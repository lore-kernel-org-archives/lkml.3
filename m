Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661AbaD1FAW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 01:00:22 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:42171 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252AbaD1FAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 01:00:20 -0400
Message-ID: <535DE027.5050700@linux.vnet.ibm.com>
Date: Sun, 27 Apr 2014 21:59:19 -0700
From: Cody P Schafer <cody@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Michael Ellerman <michael@ellerman.id.au>,
        Linux PPC <linuxppc-dev@lists.ozlabs.org>,
        LKML <linux-kernel@vger.kernel.org>, Anton Blanchard <anton@samba.org>,
        David.Laight@aculab.com
Subject: Re: [PATCH v2 6/6] powerpc/perf/hv-24x7: catalog version number is
 be64, not be32
References: <1397581855-4585-1-git-send-email-cody@linux.vnet.ibm.com> <1397581855-4585-7-git-send-email-cody@linux.vnet.ibm.com> <1398660478.30694.10.camel@pasglop>
In-Reply-To: <1398660478.30694.10.camel@pasglop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042805-0928-0000-0000-0000018727D6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27/2014 09:47 PM, Benjamin Herrenschmidt wrote:
> On Tue, 2014-04-15 at 10:10 -0700, Cody P Schafer wrote:
>> The catalog version number was changed from a be32 (with proceeding
>> 32bits of padding) to a be64, update the code to treat it as a be64
>>
>> Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
>> --
>
> Have you tested this ?
>
> It doesn't build for me:
>
> arch/powerpc/perf/hv-24x7.c: In function 'catalog_read':
> arch/powerpc/perf/hv-24x7.c:223:3: error: format '%d' expects argument of type 'int', but argument 2 has type 'uint64_t' [-Werror=format]
> cc1: all warnings being treated as errors

I have, and I wasn't initially sure how I managed to miss that 
warning-as-error. On examination: My config (for some reason) has 
CONFIG_PPC_DISABLE_WERROR=y set (probably because it's a variation of a 
distro config). Must have been piping the warnings to a file and 
forgotten to check the file.

> I'll fix that up in my tree.

Thanks.


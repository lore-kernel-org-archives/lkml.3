Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047AbaFYCnZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 22:43:25 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:41476 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484AbaFYCnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 22:43:23 -0400
Message-ID: <53AA3745.7070108@ozlabs.ru>
Date: Wed, 25 Jun 2014 12:43:17 +1000
From: Alexey Kardashevskiy <aik@ozlabs.ru>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Alex Williamson <alex.williamson@redhat.com>,
        Alexander Graf <agraf@suse.de>, linuxppc-dev@lists.ozlabs.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
Subject: Re: [PATCH] vfio: Fix endianness handling for emulated BARs
References: <1403091391-31780-1-git-send-email-aik@ozlabs.ru>	 <1403116512.3707.175.camel@ul30vt.home> <53A233E9.6030006@ozlabs.ru>	 <53A241F6.9010307@ozlabs.ru> <53A25D74.5000804@ozlabs.ru>	 <1403234514.3707.278.camel@ul30vt.home> <1403305961.4587.66.camel@pasglop>		 <53A94EBD.101@ozlabs.ru> <53A955F5.6050801@suse.de>		 <53A9741B.1040500@ozlabs.ru> <53A97486.4070604@suse.de>		 <53A976B7.3070709@ozlabs.ru> <53A97BA9.4020702@suse.de>	 <1403619685.16078.15.camel@ul30vt.home> <53A98C38.8020205@ozlabs.ru> <1403646877.4587.184.camel@pasglop>
In-Reply-To: <1403646877.4587.184.camel@pasglop>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2014 07:54 AM, Benjamin Herrenschmidt wrote:
> On Wed, 2014-06-25 at 00:33 +1000, Alexey Kardashevskiy wrote:
>>
>> I do not understand why @val is considered LE here and need to be
>> converted
>> to CPU. Really. I truly believe it should be cpu_to_le32().
> 
> No. Both are slightly wrong semantically but le32_to_cpu() is less
> wrong :-)
>
> iowrite32 supposedly takes a "cpu" value as argument and writes an "le"
> value. So if anything, you need something that converts to a "cpu" value
> before you call iowrite32.
> 
> Now it's still slightly wrong because the "input" to le32_to_cpu() is
> supposed to be an "LE" value but of course here it's not, it's a "cpu"
> value too :-)
> 
> But yes, I agree with aw here, either do nothing or stick a set of
> iowriteXX_native or something equivalent in the generic iomap header,
> define them in term of iowrite32be/iowrite32 based on the compile time
> endian of the arch.


Ok. I'll do nothing.


> Hitting asm-generic/iomap.h I think will cover all archs except ARM.
> For ARM, just hack arch/arm/asm/io.h


-- 
Alexey

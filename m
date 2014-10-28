Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526AbaJ1NYv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 09:24:51 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:64218 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723AbaJ1NYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 09:24:50 -0400
Message-ID: <544F991E.3070500@imgtec.com>
Date: Tue, 28 Oct 2014 13:24:46 +0000
From: Markos Chandras <Markos.Chandras@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Joonsoo Kim <js1304@gmail.com>
CC: Joonsoo Kim <iamjoonsoo.kim@lge.com>, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, <linux-mips@linux-mips.org>
Subject: Re: Boot problems on Malta with EVA (bisected to 12220dea07f1 "mm/slab:
 support slab merge")
References: <544F73CD.1010409@imgtec.com> <CAAmzW4NdBNhsPtx1yw+drN+J=a23SS3yLkgQdvQx-Giokwxu-Q@mail.gmail.com> <544F97D4.4030408@imgtec.com>
In-Reply-To: <544F97D4.4030408@imgtec.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.149]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/2014 01:19 PM, Markos Chandras wrote:
> On 10/28/2014 01:01 PM, Joonsoo Kim wrote:
>> 2014-10-28 19:45 GMT+09:00 Markos Chandras <Markos.Chandras@imgtec.com>:
>>> Hi,
>>>
>>> It seems I am unable to boot my Malta with EVA. The problem appeared in
>>> the 3.18 merge window. I bisected the problem (between v3.17 and
>>> v3.18-rc1) and I found the following commit responsible for the broken boot.
>>
>> Hello,
>>
>> Did you start to bisect from v3.18-rc1?
>> I'd like to be sure that this is another bug which is fixed by following commit.
>>
>> commit 85c9f4b04a08f6bc770b77530c22d04103468b8f
>> Author: Joonsoo Kim <iamjoonsoo.kim@lge.com>
>> Date:   Mon Oct 13 15:51:01 2014 -0700
>>
>>     mm/slab: fix unaligned access on sparc64
>>
>> This fix is merged into v3.18-rc1 sometime later that
>> 'support slab merge' is merged.
>>
>> Thanks.
>>
> Hi,
> 
> I bisected from v3.17 until 3.18-rc1. But 3.18-rc2 and the latest
> mainline (f7e87a44ef60ad379e39b45437604141453bf0ec) still have the same
> problem
> 
> btw i did more tests and this is not EVA specific. A maltaup_defconfig
> fails in the same way. I suspect all malta*_defconfigs will fail in a
> similar way which makes it probably easier for you to reproduce it on a
> QEMU.
> 

sorry maltaup_defconfig does not fail. maltasmvp_defconfig does. So it
might be a similar problem like the one fixed in
85c9f4b04a08f6bc770b77530c22d04103468b8f

-- 
markos

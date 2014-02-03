Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752279AbaBCKDU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 05:03:20 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:58127 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbaBCKDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 05:03:17 -0500
Message-ID: <52EF6965.6040406@gmail.com>
Date: Mon, 03 Feb 2014 18:03:17 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: James Hogan <james.hogan@imgtec.com>, devel@driverdev.osuosl.org,
        andreas.dilger@intel.com, Antonio Quartulli <antonio@meshcoding.com>,
        Greg KH <gregkh@linuxfoundation.org>, bergwolf@gmail.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, oleg.drokin@intel.com,
        jacques-charles.lafoucriere@cea.fr, jinshan.xiong@intel.com,
        netdev <netdev@vger.kernel.org>, linux-metag@vger.kernel.org
Subject: Re: [PATCH] drivers: staging: lustre: lustre: include: add "__attribute__((packed))"
 for the related union
References: <20140118142404.GT7444@mwanda> <52DBA3D4.3090308@gmail.com> <52DD0EFF.2010305@imgtec.com> <20140120123045.GV7444@mwanda> <52DD18A5.1090308@imgtec.com> <20140120125603.GD4815@mwanda> <20140120211356.GG4815@mwanda> <52DE4DA3.7090301@imgtec.com> <52E3A642.7010307@gmail.com> <52ECFD53.7010401@gmail.com> <20140203085855.GA26722@mwanda>
In-Reply-To: <20140203085855.GA26722@mwanda>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/2014 04:58 PM, Dan Carpenter wrote:
> On Sat, Feb 01, 2014 at 09:57:39PM +0800, Chen Gang wrote:
>> It seems, our kernel still stick to treate 'pack' region have effect
>> with both 'align' and 'sizeof'.
>>
> 
> It's not about packed regions.  It's about unions.  It's saying the
> sizeof() a union is a multiple of 4 unless it's packed.
> 
> union foo {
> 	short x;
> 	short y;
> };
> 
> The author intended the sizeof(union foo) to be 2 but on metag arch then
> it is 4.
> 

Yeah, just like your original discussion.  :-)


Hmm... can we say: "for metag compiler, in a pack region, it considers
variables alignment, but does not consider about struct/union alignment
(except append packed to each related struct/union)".

For compatible (consider about its ABI), it has to keep this features,
but for kernel, it needs be changed.

So, I suggest to add one parameter to compiler to switch this feature,
and append this parameter to KBUILD_CFLAGS in "arch/metag/Makefile"
which can satisfy both ABI and kernel.


Thanks.
-- 
Chen Gang

Open, share and attitude like air, water and life which God blessed

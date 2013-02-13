Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757550Ab3BMNuY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 08:50:24 -0500
Received: from juliette.telenet-ops.be ([195.130.137.74]:40521 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756849Ab3BMNuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 08:50:23 -0500
Message-ID: <511B9A1C.6000402@acm.org>
Date: Wed, 13 Feb 2013 14:50:20 +0100
From: Bart Van Assche <bvanassche@acm.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130105 Thunderbird/17.0.2
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: Jack Morgenstein <jackm@dev.mellanox.co.il>,
        Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] IB/lmx4: silence GCC warning
References: <1348836538.3626.21.camel@x61.thuisdomein>  <201210100923.43927.jackm@dev.mellanox.co.il> <1351504201.1339.4.camel@x61.thuisdomein>
In-Reply-To: <1351504201.1339.4.camel@x61.thuisdomein>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/12 10:50, Paul Bolle wrote:
> On Wed, 2012-10-10 at 09:23 +0200, Jack Morgenstein wrote:
>> You could use:
>>
>>     u16 uninitialized_var(vlan);
>>
>> instead.
>
> I guess we'd better just wait and see whether uninitialized_var()
> survives before discussing your suggestion (see the thread starting at
> https://lkml.org/lkml/2012/10/26/508 ).
>
>> Although this in the special QP data flow, I still prefer to avoid adding extra code (even setting
>> initial values at procedure entry).  The line above will also do the job.  "uninitialized_var"
>> is used elsewhere in the driver.  See, for example, mlx4_ib_post_send() in the same file (qp.c).

(replying to an e-mail of a few months ago)

If there are no further objections I'd like to see this patch to go 
upstream. It fixes an annoying compiler warning and I don't think that 
this patch has a negative performance impact.

Thanks,

Bart.


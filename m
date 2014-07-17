Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934609AbaGQP7A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 11:59:00 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:51638 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933807AbaGQP67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 11:58:59 -0400
Message-ID: <53C7F2B2.2000803@oracle.com>
Date: Thu, 17 Jul 2014 11:58:42 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86-64, espfix: consider IRQs are off when initializing
References: <1405610015-27464-1-git-send-email-sasha.levin@oracle.com> <53C7F063.7030007@zytor.com>
In-Reply-To: <53C7F063.7030007@zytor.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2014 11:48 AM, H. Peter Anvin wrote:
> On 07/17/2014 08:13 AM, Sasha Levin wrote:
>> > When going through our initialization code (init_espfix_ap() ) we need to
>> > keep in mind IRQs are off, and we need to handle it appropriately:
>> > 
>> >  - Do not allocate with __GFP_FS.
>> >  - No point in using a mutex.
>> > 
>> > Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
> I don't think this is safe.  The whole point was that if we do
> GFP_ATOMIC we have to accept failure, and if we have a spin lock then
> sleeping is not permitted.  It is unclear to me is sleeping is safe in
> this context even so, so we may still have a problem, but calling
> __get_free_page(GFP_ATOMIC) and then unconditionally use the results is
> not right.

This is the result of getting an error message for allocating with GFP_KERNEL
saying that we can't do that with IRQs off.

My assumption after that was that we're not going to be sleeping at all, which
is why spinlock/GFP_ATOMIC would be correct here.


Thanks,
Sasha

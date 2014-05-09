Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756810AbaEIPo2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 11:44:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48532 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756630AbaEIPo0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 11:44:26 -0400
Message-ID: <536CF7B3.4040705@zytor.com>
Date: Fri, 09 May 2014 08:43:47 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>, tglx@linutronix.de,
        mingo@redhat.com
CC: linux-kernel@vger.kernel.org, stefani@seibold.net, luto@amacapital.net,
        konrad.wilk@oracle.com, stable@vger.kernel.org
Subject: Re: [PATCH] time: Cast tv_nsec to u64 for proper shifting in update_vsyscall()
References: <1399648287-15178-1-git-send-email-boris.ostrovsky@oracle.com>
In-Reply-To: <1399648287-15178-1-git-send-email-boris.ostrovsky@oracle.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2014 08:11 AM, Boris Ostrovsky wrote:
> With tk->wall_to_monotonic.tv_nsec being a 32-bit value on 32-bit
> systems, (tk->wall_to_monotonic.tv_nsec << tk->shift) in update_vsyscall()
> may lose upper bits or, worse, add them since compiler will do this:
> 	(u64)(tk->wall_to_monotonic.tv_nsec << tk->shift)
> instead of
> 	((u64)tk->wall_to_monotonic.tv_nsec << tk->shift)
> 
> So if, for example, tv_nsec is 0x800000 and shift is 8 we will end up
> with 0xffffffff80000000 instead of 0x80000000. And then we are stuck in
> the subsequent 'while' loop.
> 
> We need explicit cast.
> 
> Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
> Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Cc: stable@vger.kernel.org

This is needed in stable only for v3.14, right?

	-hpa



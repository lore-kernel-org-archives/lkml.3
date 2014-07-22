Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761AbaGVMcE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 08:32:04 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:8792 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbaGVMcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 08:32:01 -0400
Message-ID: <53CE59BE.104@imgtec.com>
Date: Tue, 22 Jul 2014 13:31:58 +0100
From: Markos Chandras <Markos.Chandras@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Aaro Koskinen <aaro.koskinen@nsn.com>, Ralf Baechle <ralf@linux-mips.org>,
        David Daney <david.daney@cavium.com>, <linux-mips@linux-mips.org>,
        <linux-kernel@vger.kernel.org>
CC: <stable@vger.kernel.org>
Subject: Re: [PATCH] MIPS: OCTEON: make get_system_type() thread-safe
References: <1406029868-6210-1-git-send-email-aaro.koskinen@nsn.com>
In-Reply-To: <1406029868-6210-1-git-send-email-aaro.koskinen@nsn.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.158]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2014 12:51 PM, Aaro Koskinen wrote:
> get_system_type() is not thread-safe on OCTEON. It uses static data,
> also more dangerous issue is that it's calling cvmx_fuse_read_byte()
> every time without any synchronization. Currently it's possible to get
> processes stuck looping forever in kernel simply by launching multiple
> readers of /proc/cpuinfo:
> 
> 	(while true; do cat /proc/cpuinfo > /dev/null; done) &
> 	(while true; do cat /proc/cpuinfo > /dev/null; done) &
> 	...
> 
> Fix by initializing the system type string only once during the early
> boot.
> 
> Signed-off-by: Aaro Koskinen <aaro.koskinen@nsn.com>
> Cc: stable@vger.kernel.org
> ---
>  arch/mips/cavium-octeon/setup.c | 18 +++++++++++++-----
>  1 file changed, 13 insertions(+), 5 deletions(-)
> 

It looks reasonable to me.

Reviewed-by: Markos Chandras <markos.chandras@imgtec.com>

-- 
markos

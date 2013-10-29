Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757037Ab3J2BMh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 21:12:37 -0400
Received: from intranet.asianux.com ([58.214.24.6]:31019 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756Ab3J2BMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 21:12:36 -0400
X-Spam-Score: -100.8
Message-ID: <526F0B44.7040004@asianux.com>
Date: Tue, 29 Oct 2013 09:11:32 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Vineet Gupta <vineetg76@gmail.com>
CC: Arnd Bergmann <arnd@arndb.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        pierrick.hascoet@abilis.com, christian.ruppert@abilis.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arc: include: asm: remove '__init' for setup_processor()
 and arc_init_IRQ()
References: <52673075.3080201@asianux.com> <526E6D14.4090202@synopsys.com>
In-Reply-To: <526E6D14.4090202@synopsys.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/2013 09:56 PM, Vineet Gupta wrote:
> On 10/23/2013 07:42 AM, Chen Gang wrote:
>> They haven't '__init' in definition, but has '__init' in declaration.
>> And normal function start_kernel_secondary() may call setup_processor()
>> which will call arc_init_IRQ().
>>
>> So need remove '__init' for both of them. The related warning (with
>> allmodconfig):
>>
>>     MODPOST vmlinux.o
>>   WARNING: vmlinux.o(.text+0x3084): Section mismatch in reference from the function start_kernel_secondary() to the function .init.text:setup_processor()
>>   The function start_kernel_secondary() references
>>   the function __init setup_processor().
>>   This is often because start_kernel_secondary lacks a __init
>>   annotation or the annotation of setup_processor is wrong.
>>
>>
>> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> 
> Applied for 3.13
> 

Thanks.
-- 
Chen Gang

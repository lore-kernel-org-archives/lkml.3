Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623Ab3J1N4p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 09:56:45 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:64356 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756436Ab3J1N4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 09:56:44 -0400
Message-ID: <526E6D14.4090202@synopsys.com>
Date: Mon, 28 Oct 2013 19:26:36 +0530
From: Vineet Gupta <vineetg76@gmail.com>
Organization: Synopsys
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Chen Gang <gang.chen@asianux.com>, Arnd Bergmann <arnd@arndb.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        pierrick.hascoet@abilis.com, christian.ruppert@abilis.com
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arc: include: asm: remove '__init' for setup_processor()
 and arc_init_IRQ()
References: <52673075.3080201@asianux.com>
In-Reply-To: <52673075.3080201@asianux.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/2013 07:42 AM, Chen Gang wrote:
> They haven't '__init' in definition, but has '__init' in declaration.
> And normal function start_kernel_secondary() may call setup_processor()
> which will call arc_init_IRQ().
> 
> So need remove '__init' for both of them. The related warning (with
> allmodconfig):
> 
>     MODPOST vmlinux.o
>   WARNING: vmlinux.o(.text+0x3084): Section mismatch in reference from the function start_kernel_secondary() to the function .init.text:setup_processor()
>   The function start_kernel_secondary() references
>   the function __init setup_processor().
>   This is often because start_kernel_secondary lacks a __init
>   annotation or the annotation of setup_processor is wrong.
> 
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>

Applied for 3.13

-Vineet

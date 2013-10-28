Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932093Ab3J1Nxy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 09:53:54 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41797 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932076Ab3J1Nxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 09:53:52 -0400
Message-ID: <526E6C6B.9020507@synopsys.com>
Date: Mon, 28 Oct 2013 19:23:47 +0530
From: Vineet Gupta <vineetg76@gmail.com>
Organization: Synopsys
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Chen Gang <gang.chen@asianux.com>, Arnd Bergmann <arnd@arndb.de>,
        noamc@ezchip.com
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arc: kernel: remove '__init' for first_lines_of_secondary()
References: <52673186.4050806@asianux.com>
In-Reply-To: <52673186.4050806@asianux.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/2013 07:46 AM, Chen Gang wrote:
> first_lines_of_secondary() is a '__init' function, but it may be called
> by __cpu_up() by _cpu_up() by cpu_up() which is a normal export symbol
> function. So recommend to remove '__init'.
> 
> The related warning (with allmodconfig):
> 
>     MODPOST vmlinux.o
>   WARNING: vmlinux.o(.text+0x315c): Section mismatch in reference from the function __cpu_up() to the function .init.text:first_lines_of_secondary()
>   The function __cpu_up() references
>   the function __init first_lines_of_secondary().
>   This is often because __cpu_up lacks a __init
>   annotation or the annotation of first_lines_of_secondary is wrong.
> 
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>

Applied for 3.13. But I'm planning to squash all the __init section annotation
fixes into one patch. OK with you ?

Thx,
-Vineet

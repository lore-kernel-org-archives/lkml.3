Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751444AbaHJQaW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 12:30:22 -0400
Received: from mail.active-venture.com ([67.228.131.205]:63878 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbaHJQaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 12:30:21 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53E79E16.7040603@roeck-us.net>
Date: Sun, 10 Aug 2014 09:30:14 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>, Guan Xuetao <gxt@mprc.pku.edu.cn>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] unicore32: Fix build error
References: <1407684595-30785-1-git-send-email-linux@roeck-us.net> <53E7923F.5000008@nod.at>
In-Reply-To: <53E7923F.5000008@nod.at>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/10/2014 08:39 AM, Richard Weinberger wrote:
> Guenther,
>
> Am 10.08.2014 17:29, schrieb Guenter Roeck:
>> unicore32 builds fail with
>>
>> arch/unicore32/kernel/signal.c: In function ‘setup_frame’:
>> arch/unicore32/kernel/signal.c:257: error:
>> 			‘usig’ undeclared (first use in this function)
>> arch/unicore32/kernel/signal.c:279: error:
>> 			‘usig’ undeclared (first use in this function)
>> arch/unicore32/kernel/signal.c: In function ‘handle_signal’:
>> arch/unicore32/kernel/signal.c:306: warning: unused variable ‘tsk’
>> arch/unicore32/kernel/signal.c: In function ‘do_signal’:
>> arch/unicore32/kernel/signal.c:376: error:
>> 			implicit declaration of function ‘get_signsl’
>> make[1]: *** [arch/unicore32/kernel/signal.o] Error 1
>> make: *** [arch/unicore32/kernel/signal.o] Error 2
>>
>> Bisect points to commit 649671c90eaf ("unicore32: Use get_signal()
>> signal_setup_done()").
>>
>> This code never even compiled. Reverting the patch does not work,
>> since previously used functions no longer exist, so try to fix it up.
>> Compile tested only.
>
> Where did you get the unicore32 cross compiler from?
>
mprc.pku.edu.cn/~guanxuetao/linux/uc4-1.0.5-hard.tgz

Guenter


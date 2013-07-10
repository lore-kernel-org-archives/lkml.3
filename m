Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754937Ab3GJXmV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 19:42:21 -0400
Received: from intranet.asianux.com ([58.214.24.6]:28973 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754110Ab3GJXmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 19:42:19 -0400
X-Spam-Score: -100.8
Message-ID: <51DDF122.9040206@asianux.com>
Date: Thu, 11 Jul 2013 07:41:22 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: sam@ravnborg.org, zhaohongjiang@huawei.com, gregkh@linuxfoundation.org,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH] arch: sparc: kernel: check the memory length before use
 strcpy().
References: <51C53571.9070403@asianux.com> <20130710.134216.1407498845215548973.davem@davemloft.net>
In-Reply-To: <20130710.134216.1407498845215548973.davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2013 04:42 AM, David Miller wrote:
> From: Chen Gang <gang.chen@asianux.com>
> Date: Sat, 22 Jun 2013 13:26:09 +0800
> 
>> > 
>> > For the related next strcpy(), the destination length is less than 512,
>> > but the source maximize length may be 'OPROMMAXPARAM' (4096) which is
>> > more than 512.
>> > 
>> > One work flow may:
>> >   openprom_sunos_ioctl() ->  if (cmd == OPROMSETOPT)
>> >     getstrings() ->  will alloc buffer with size 'OPROMMAXPARAM'.
>> >     opromsetopt() ->  devide the buffer into 'var' and 'value'
>> >       of_set_property() -> pass
>> >         prom_setprop() -> pass
>> >           ldom_set_var()
>> > 
>> > And do not mind the additional 4 alignment buffer increasing, since
>> > 'sizeof(pkt) - sizeof(pkt.header)' is 4 alignment at least.
>> > 
>> > 
>> > Signed-off-by: Chen Gang <gang.chen@asianux.com>
> Applied.
> 
> 

Thank you for your work, especially you are very busy.

-- 
Chen Gang

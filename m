Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265AbaBNIbt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 03:31:49 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:46456 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233AbaBNIbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 03:31:47 -0500
X-AuditID: 85900ec0-d312bb9000001514-10-52fdd470d9ad
Message-ID: <52FDD470.7000607@hitachi.com>
Date: Fri, 14 Feb 2014 17:31:44 +0900
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120604 Thunderbird/13.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: [PATCH] serial/uart: Add tunable RX interrupt trigger I/F of
 FIFO buffers
References: <20140206021655.8613.52786.stgit@yunodevel> <20140213181007.GA24155@kroah.com>
In-Reply-To: <20140213181007.GA24155@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Thank you for your reply.

[snip]

>> diff --git a/include/uapi/asm-generic/ioctls.h b/include/uapi/asm-generic/ioctls.h
>> index 143dacb..d2e56a4 100644
>> --- a/include/uapi/asm-generic/ioctls.h
>> +++ b/include/uapi/asm-generic/ioctls.h
>> @@ -78,6 +78,8 @@
>>   #define TIOCGPTLCK	_IOR('T', 0x39, int) /* Get Pty lock state */
>>   #define TIOCGEXCL	_IOR('T', 0x40, int) /* Get exclusive mode state */
>>
>> +#define TIOCSFIFORTRIG	0x5441
>
> Please define this as a "proper" ioctl command by using the correct IO*
> macros.

OK. I'll use _IOW as follows:

#define TIOCSFIFORTRIG    _IOW('T', 0x41, unsigned char)

> Also, why pass a pointer to a variable, and not just the value itself?

Ah, it's no big reason.
It will pass just the value itself in V2.

> And are you sure there's no other way to do this already?  It's odd that
> no one else has ever hit this before...

According to a manual of setserial command, we could set RX interrupt
trigger only for the Hayes ESP serial driver. However, current kernel
does not support Hayes ESP serial[1]. I couldn't find this feature for
current 8250/16X50 drivers.

[1] https://lkml.org/lkml/2009/12/11/500

Thanks,
Yoshihiro YUNOMAE

-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com



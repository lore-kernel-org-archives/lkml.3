Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755619Ab3GKGsv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 02:48:51 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:49257 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416Ab3GKGsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 02:48:50 -0400
Message-ID: <51DE554F.8020107@kernel.org>
Date: Thu, 11 Jul 2013 09:48:47 +0300
From: Pekka Enberg <penberg@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Matthieu CASTET <matthieu.castet@parrot.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Matthieu CASTET <castet.matthieu@free.fr>,
        Russell King <rmk@arm.linux.org.uk>,
        Shiyong Li <shi-yong.li@motorola.com>,
        Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] slab : allow SLAB_RED_ZONE and SLAB_STORE_USER to work
 on arm
References: <1350386231-770-1-git-send-email-matthieu.castet@parrot.com> <CAOJsxLHQy7pshnskn+wMp=1D9+9wGQZBhFD+kjtbCSJvoW7q2Q@mail.gmail.com> <5090F708.3010104@parrot.com>
In-Reply-To: <5090F708.3010104@parrot.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(nine months later...)

On 10/31/2012 12:01 PM, Matthieu CASTET wrote:
>> This piece of code tends to break in peculiar ways every time someone
>> touches it. I could use some more convincing in the changelog this
>> time it won't...
>
> Ok, is the following changelog is ok ?
>
> The current slab code only allow to put redzone( and user store) info if "buffer
> alignment(ralign) <= __alignof__(unsigned long long)". This was done because we
> want to keep the buffer aligned for user even after adding redzone at the
> beginning of the buffer (the user store is stored after user buffer) [1]
>
> But instead of disabling this feature when "ralign > __alignof__(unsigned long
> long)", we can force the alignment by allocating ralign before user buffer.
>
> This is done by setting ralign in obj_offset when "ralign > __alignof__(unsigned
> long long)" and keeping the old behavior when  "ralign <= __alignof__(unsigned
> long long)" (we set sizeof(unsigned long long)).
>
> The 5c5e3b33b7cb959a401f823707bee006caadd76e commit wasn't handling "ralign <=
> __alignof__(unsigned long long)", that's why it broked some configuration.
>
> This was tested on omap3 (ralign is 64 and __alignof__(unsigned long long) is 8)

Care to resend this patch with the above changelog? I'll see
if I can find someone to ACK it for v3.12.

			Pekka

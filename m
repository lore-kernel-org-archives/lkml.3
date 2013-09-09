Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751826Ab3IICbV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 22:31:21 -0400
Received: from mail.active-venture.com ([67.228.131.205]:54053 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366Ab3IICbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 22:31:20 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <522D32F6.4020705@roeck-us.net>
Date: Sun, 08 Sep 2013 19:31:18 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Peng Tao <tao.peng@emc.com>, Peng Tao <bergwolf@gmail.com>
Subject: Re: [PATCH] staging: Disable lustre file system for MIPS, SH, and
 XTENSA
References: <1378688580-11935-1-git-send-email-linux@roeck-us.net> <20130909015945.GA4029@kroah.com> <522D3153.5000102@roeck-us.net> <20130909023152.GA5329@kroah.com>
In-Reply-To: <20130909023152.GA5329@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08/2013 07:31 PM, Greg Kroah-Hartman wrote:
> On Sun, Sep 08, 2013 at 07:24:19PM -0700, Guenter Roeck wrote:
>> On 09/08/2013 06:59 PM, Greg Kroah-Hartman wrote:
>>> On Sun, Sep 08, 2013 at 06:03:00PM -0700, Guenter Roeck wrote:
>>>> mips allmodconfig fails with
>>>>
>>>> ERROR: "copy_from_user_page" [drivers/staging/lustre/lustre/libcfs/libcfs.ko]
>>>> undefined!
>>>>
>>>> which is due to LUSTRE using copy_from_user_page which is not exported by any
>>>> architecture.
>>>
>>> Any, or just these arches?
>>>
>> Other architectures implement it as define as far as I can see.
>
> Then why would it be a problem?
>
It isn't a problem for those other architectures. Mostly it is mapped to functions like memcpy().

Guenter

>>>> Unfortunately, LUSTRE can only be built as module, so there is no
>>>> easy fix.
>>>
>>> Can't we just export the functions for those arches?  Surely lutre
>>> isn't the first/only driver that needs this?
>>>
>> That would be another option.
>>
>> Actually, turns out Geert submitted a patch to do this for mips already, and Ralf applied it:
>>
>> https://lkml.org/lkml/2013/9/5/111
>>
>> So please forget this patch. If sh/xtensa actually need it, we can do the same there.
>
> Sounds good to me, consider it forgotten :)
>
> greg k-h
>
>


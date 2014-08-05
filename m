Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814AbaHEUka (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 16:40:30 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:37578 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753563AbaHEUk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 16:40:29 -0400
MIME-Version: 1.0
In-Reply-To: <53E13AC7.1030406@tilera.com>
References: <1406383480-1485-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <53E13AC7.1030406@tilera.com>
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Date: Tue, 5 Aug 2014 22:40:06 +0200
Message-ID: <CAFo99gaZO3wNEFxgOxB9nLPyBwjTSwCeY8Xzu1GrgGu5kv-L6g@mail.gmail.com>
Subject: Re: [PATCH] arch: tile: kernel: setup.c: Cleaning up missing
 null-terminate in conjunction with strncpy
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: Wang Sheng-Hui <shhuiw@gmail.com>, Daniel Walter <dwalter@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-08-05 22:12 GMT+02:00 Chris Metcalf <cmetcalf@tilera.com>:
> On 7/26/2014 10:04 AM, Rickard Strandqvist wrote:
>>
>> Replacing strncpy with strlcpy to avoid strings that lacks null terminate.
>>
>> Signed-off-by: Rickard Strandqvist
>> <rickard_strandqvist@spectrumdigital.se>
>> ---
>>   arch/tile/kernel/setup.c |    2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/tile/kernel/setup.c b/arch/tile/kernel/setup.c
>> index 112abab..1af7d19 100644
>> --- a/arch/tile/kernel/setup.c
>> +++ b/arch/tile/kernel/setup.c
>> @@ -1087,7 +1087,7 @@ static int __init setup_initramfs_file(char *str)
>>   {
>>         if (str == NULL)
>>                 return -EINVAL;
>> -       strncpy(initramfs_file, str, sizeof(initramfs_file) - 1);
>> +       strlcpy(initramfs_file, str, sizeof(initramfs_file));
>>         set_initramfs_file = 1;
>>         return 0;
>
>
> I'm inclined not to take this change, because it's not necessary.
> The initramfs_file[] is already zero-filled by being in the BSS, and
> this is a pretty obscure boot option, so it seems a bit more
> maintainable to use a somewhat more standard string API call.
>


Hi

Of course this is quite alright, the goal is to create code that it
can not get any bugs.
With sizeof -1 will get it right, if you can only be sure that the
zeroes string will be overwritten.


Kind regards
Rickard Strandqvist

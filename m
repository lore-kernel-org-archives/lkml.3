Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756947AbaIRT5k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 15:57:40 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:60336 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753741AbaIRT5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 15:57:39 -0400
MIME-Version: 1.0
In-Reply-To: <20140918085105.GB16827@mwanda>
References: <1410710597-14520-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <20140915082346.GB17875@mwanda> <CAFo99gZUiSB2cgSAAj7EBjZJTs7QxvCDZr6Wms3ud5qQvBWQMw@mail.gmail.com>
 <20140918085105.GB16827@mwanda>
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Date: Thu, 18 Sep 2014 21:57:17 +0200
Message-ID: <CAFo99gbNPLiEFSmeQOpeNwD=cSkXs79tfu2BJqZfmiX8dEsYWA@mail.gmail.com>
Subject: Re: [PATCH] staging: lustre: lustre: libcfs: debug.c: Cleaning up
 unnecessary use of memset in conjunction with strncpy
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peng Tao <bergwolf@gmail.com>, devel@driverdev.osuosl.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-09-18 10:51 GMT+02:00 Dan Carpenter <dan.carpenter@oracle.com>:
> On Thu, Sep 18, 2014 at 12:12:42AM +0200, Rickard Strandqvist wrote:
>> Hi Dan
>>
>> Ok, I have made two suggestions for strncpy function that also
>> guarantees a terminating null character.
>> 1) retunerar number of characters to be copied, it can be good to
>> have, but was not really satisfied.
>
> strlcpy() is more popular the strncpy() in the kernel.
>
> No one uses the return value of strncpy() because what is the point?
> There are around 15-20 places which use the return value of strlcpy().
> Some of the place which use the return value assume that the copy fits.
>
> I think we should return the number of bytes before the NUL or else
> count.
>
>>
>> int strncpyz(char *dest, const char *src, size_t count)
>> {
>>   size_t len=0;
>>
>>   if(0 == count)
>>     return 0;
>>
>>   --count;
>>   while(len < count && src[len])
>>    *dest++ = src[len++];
>>
>>   do {
>>     *dest++ = '\0';
>>   }
>>   while(len < count--);
>>
>>   return len;
>> }
>>
>>
>> 2) The next version is almost the same code as the regular strncpy,
>> but with two extra lines.
>>
>> char *strncpyz(char *dest, const char *src, size_t count)
>> {
>>         char *tmp = dest;
>>
>>         while (count) {
>>                 if ((*tmp = *src) != 0)
>>                         src++;
>>                 tmp++;
>>                 count--;
>>         }
>>
>>         if(tmp != dest)
>>           *--tmp = '\0';
>>
>>         return dest;
>> }
>>
>>
>> Since I did not got any better solution to variant 1, I prefer variant 2.
>
> I also prefer variant 2.
>
>>
>> Then the next question is of course what it should be called  :-)
>
> I think a lot of people call this function strzcpy().
>
> This sort of patch would go through Andrew Morton.
>
> regards,
> dan carpenter


Hi Dan

Ok, strzcpy is it :)

Should I add this as a patch in lib/string.c or email him first.. What
is customary in these situations?


Kind regards
Rickard Strandqvist

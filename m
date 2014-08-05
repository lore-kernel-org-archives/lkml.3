Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378AbaHEBRr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 21:17:47 -0400
Received: from s87.loopia.se ([194.9.94.112]:16415 "EHLO s87.loopia.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752723AbaHEBRp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 21:17:45 -0400
X-Spam-Flag: NO
X-Spam-Score: -1
Message-ID: <53E030BF.1010907@hanshq.net>
Date: Mon, 04 Aug 2014 18:17:51 -0700
From: Hans Wennborg <hans@hanshq.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.7.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Andy Whitcroft <apw@canonical.com>
Subject: Re: [PATCH] checkpatch: Add test for printf formats with 0x that
 emit decimal
References: <1407018043-648-1-git-send-email-hans@hanshq.net>	 <1407026806.1835.21.camel@joe-AO725> <53DD8E17.1@hanshq.net>	 <1407046215.1835.24.camel@joe-AO725> <53DED2E9.5090205@hanshq.net>	 <1407112425.16152.10.camel@joe-AO725> <1407120645.16152.28.camel@joe-AO725>	 <53DEF81B.1000303@hanshq.net> <1407124017.16152.31.camel@joe-AO725>
In-Reply-To: <1407124017.16152.31.camel@joe-AO725>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2014 08:46 PM, Joe Perches wrote:
> On Sun, 2014-08-03 at 20:03 -0700, Hans Wennborg wrote:
>> On 08/03/2014 07:50 PM, Joe Perches wrote:
>>> 0x%<foo> should be used to emit hexadecimal values.
>>>
>>> Uses of 0x%[udi] emit decimal values but these should
>>> probably instead use 0x%x variants.
>>>
>>> Warn on these uses.
>>
>> Good idea!
> []
>>> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> []
>>> @@ -4985,6 +4985,10 @@ sub process {
>>>    		while ($line =~ /(?:^|")([X\t]*)(?:"|$)/g) {
>>>    			$string = substr($rawline, $-[1], $+[1] - $-[1]);
>>>    			$string =~ s/%%/__/g;
>>> +			if ($string =~ /(0x(?<!%)%[0-9.\*]*[Ll]*[udi])(?![xX])/) {
>>
>> Maybe the regex should have a \b to check for a word boundary before the
>> 0 to avoid matching things like "800x%d"? (I don't know if that occurs
>> in the kernel, but I've seen it elsewhere.)
>
> Maybe.
>
> Code it to do the appropriate thing and test it too.
> See if there any other cases that should be emitted.

I grepped with your regex over the code and didn't get any false 
positives, so it seems fine. Feel free to ignore my previous comment.

Thanks,
Hans

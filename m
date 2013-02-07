Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110Ab3BGHCH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 02:02:07 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:53775 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925Ab3BGHCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 02:02:04 -0500
Message-ID: <51135137.4010003@ahsoftware.de>
Date: Thu, 07 Feb 2013 08:01:11 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: MODSIGN without RTC?
References: <5112EA69.6010100@ahsoftware.de> <5112FE21.4020404@ahsoftware.de> <CAMuHMdXu0-9=wHevviG=4s5fC=wxkT9XbXhP6ztOyGkkeb6+8Q@mail.gmail.com>
In-Reply-To: <CAMuHMdXu0-9=wHevviG=4s5fC=wxkT9XbXhP6ztOyGkkeb6+8Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 07.02.2013 07:42, schrieb Geert Uytterhoeven:
> On Thu, Feb 7, 2013 at 2:06 AM, Alexander Holler <holler@ahsoftware.de> wrote:
>> Am 07.02.2013 00:42, schrieb Alexander Holler:
>>> I wanted to try out MODSIGN with kernel 3.7.6 and I've just got hit by:
>>>
>>> [    1.346445] X.509: Cert 6a23533cec71c4c52a1618fb4d830e06aa90474e is
>>> not yet valid
>>>
>>> The reason is likely that the (ARM) device in question doesn't have a
>>> RTC (oh, that topic again ;) ) and gets it's time on boot through NTP.
>>>
>>> The used certificate was generated automatically. Having a look at it,
>>> the following is shown:
>>>
>>>         Validity
>>>              Not Before: Feb  6 02:56:46 2013 GMT
>>>              Not After : Jan 13 02:56:46 2113 GMT
>>>
>>> Without having thought about possible security problems, my first idea
>>> would be to let the validity start at 1970. As I never did such I never
>>> had thought about possible implications when doing such (e.g. I don't
>>> know if someone checks the start date for plausabilitiy)
>>>
>>> Another solution would be to retry loading of the certificate if the
>>> time gets set (and e.g. differs more than a year).
>>>
>>> Has someone already thought about how to solve that problem? Or did
>>> everyone use sane systems which have a (working) RTC?
>>
>>
>> Another option would be to make a configure option to just ignore the date.
> 
> Or an option to auto-advance the clock to the "Not Before" date if needed...
> 
>> I'm not sure if I would like to use MODSIGN when I have to fear that the
>> machine wouldn't start when the RTC fails or got set to a wrong date.
> 
> Hmm, nice failure mode...

And the dream of every vendor, finally a working expiration date. And a
nice TV-B-Gone, just feed a wrong date once. ;)

Regards,

Alexader


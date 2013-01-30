Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515Ab3A3Mdd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 07:33:33 -0500
Received: from mail-ee0-f42.google.com ([74.125.83.42]:60168 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475Ab3A3Mdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 07:33:31 -0500
Message-ID: <51091318.6000001@monstr.eu>
Date: Wed, 30 Jan 2013 13:33:28 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-arch@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        David Hinds <dahinds@users.sourceforge.net>
Subject: Re: Using IO functions across ARM, PPC and Microblaze architectures
References: <CAHTX3d+VNDVQjnTnAB=Ywxo7odvNmCPu=wGZ03-xWLecSMsS9A@mail.gmail.com> <20121207211606.6c5d5bc8@pyramind.ukuu.org.uk> <CAMuHMdVNszTFRjqiUoZ42+noaOcGjLZyZ9O30c5UVNNJhp0LMw@mail.gmail.com>
In-Reply-To: <CAMuHMdVNszTFRjqiUoZ42+noaOcGjLZyZ9O30c5UVNNJhp0LMw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/2012 11:57 AM, Geert Uytterhoeven wrote:
> On Fri, Dec 7, 2012 at 10:16 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>>> Because I need to use IO functions which will behave
>>> on arm as little endian and on powerpc as big endian
>>> and on microblaze depends on endian setting.
>>> I haven't found any IO function which I could use by 3 architectures
>>> without using preprocessor macros or runtime detection
>>
>> Its a rather weird mix. We can do "always big" and "always little"
>>
>>> 1. Using helper function + preprocessor macros
>>> (using static inline function also possible)
>>
>> Then someone comes along and sticks a daughterboard into the system with
>> the same device the other way around and there are years
>>
>>> 2. Using function pointers
>>
>> Probably smarter. 8250.c works this way and it has to handle some
>> extremely bizarre mappings.
>>
>>> b) Runtime initialization - here is the question if there is
>>> any standard function which I could use.
>>
>> Set the pointers up and pass them as data with your platform device, that
>> way the function definitions are buried in your platform code where they
>> depend.
>
> Or embed a struct io_ops * in struct device, to be set up by the bus driver?
>
> Wasn't David Hinds working on something like this in the context of PCMCIA
> a few decades ago?


Do you have any link on that?

Thanks,
Michal



-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian

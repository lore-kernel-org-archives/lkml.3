Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758771AbbA0NEh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 08:04:37 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:48562 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758591AbbA0NEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 08:04:35 -0500
X-Sasl-enc: mkVR2AzNScupYMaixyJPj4f281wFfi5p+XX6TCGJyrZE 1422363874
Message-ID: <54C78CE0.6040207@imap.cc>
Date: Tue, 27 Jan 2015 14:04:32 +0100
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Jim Davis <jim.epost@gmail.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        devel <devel@driverdev.osuosl.org>, isdn@linux-pingi.de,
        netdev <netdev@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: Re: make allyesconfig i386 build failure with next-20150122 (caused
 by fb_agm1264k-fl driver)
References: <CA+r1ZhhXF+hicy7JKo3jAbgSbO4KOLm6BwPosTKNb+E_Cb4yPQ@mail.gmail.com> <20150126215959.GA9853@roeck-us.net> <20150126224654.GA17166@kroah.com> <54C6FB28.3000304@roeck-us.net>
In-Reply-To: <54C6FB28.3000304@roeck-us.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 27.01.2015 um 03:42 schrieb Guenter Roeck:
> On 01/26/2015 02:46 PM, Greg Kroah-Hartman wrote:
>> On Mon, Jan 26, 2015 at 01:59:59PM -0800, Guenter Roeck wrote:
>>> On Thu, Jan 22, 2015 at 12:10:33PM -0700, Jim Davis wrote:
>>>> make ARCH=i386 allyesconfig fails with
>>>>
>>>> drivers/staging/built-in.o: In function `reset':
>>>> (.text+0x2ae89d): multiple definition of `reset'
>>>> drivers/isdn/built-in.o:(.text+0x185dc2): first defined here
>>>> make[1]: *** [drivers/built-in.o] Error 1
>>>
>>> Culprit:
>>>
>>> commit b2ebd4be6fa1d2329b63531b044f9e25474981cb
>>> Author: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
>>> Date:   Wed Dec 31 10:11:10 2014 +0100
>>>
>>>      staging: fbtft: add fb_agm1264k-fl driver
>>>
>>> A global function named 'reset' isn't really a good idea.
>>>
>>> Not that the global function with the same name in the isdn code
>>> is better ;-).
>>
>> Agreed, the fbtft code is now fixed.  Patches to fix the isdn code would
>> be gladly accepted as well :)
>>
> 
> Did you have a look into the isdn code ? It will need someone
> with a lot of spare time to clean this code up.

Cleaning up the entire isdn code certainly will, but that particular
problem is in fact much more limited. The function in question is
declared, along with several other also much too generically named
ones, in drivers/isdn/sc/card.h which is included nowhere outside
drivers/isdn/sc. So these are really private functions of the
SpellCaster driver which could easily be renamed.

OTOH good old SpellCaster was an ISA card, and the sc driver depends
on the deprecated I4L framework. I wonder if it's worth any effort.

Tilman

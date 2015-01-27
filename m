Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757509AbbA0CnG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 21:43:06 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:47699 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383AbbA0CnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 21:43:03 -0500
Message-ID: <54C6FB28.3000304@roeck-us.net>
Date: Mon, 26 Jan 2015 18:42:48 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Jim Davis <jim.epost@gmail.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        devel <devel@driverdev.osuosl.org>, isdn@linux-pingi.de,
        netdev <netdev@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: Re: make allyesconfig i386 build failure with next-20150122 (caused
 by fb_agm1264k-fl driver)
References: <CA+r1ZhhXF+hicy7JKo3jAbgSbO4KOLm6BwPosTKNb+E_Cb4yPQ@mail.gmail.com> <20150126215959.GA9853@roeck-us.net> <20150126224654.GA17166@kroah.com>
In-Reply-To: <20150126224654.GA17166@kroah.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020203.54C6FB36.0165,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 5
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26/2015 02:46 PM, Greg Kroah-Hartman wrote:
> On Mon, Jan 26, 2015 at 01:59:59PM -0800, Guenter Roeck wrote:
>> On Thu, Jan 22, 2015 at 12:10:33PM -0700, Jim Davis wrote:
>>> make ARCH=i386 allyesconfig fails with
>>>
>>> drivers/staging/built-in.o: In function `reset':
>>> (.text+0x2ae89d): multiple definition of `reset'
>>> drivers/isdn/built-in.o:(.text+0x185dc2): first defined here
>>> make[1]: *** [drivers/built-in.o] Error 1
>>
>> Culprit:
>>
>> commit b2ebd4be6fa1d2329b63531b044f9e25474981cb
>> Author: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
>> Date:   Wed Dec 31 10:11:10 2014 +0100
>>
>>      staging: fbtft: add fb_agm1264k-fl driver
>>
>> A global function named 'reset' isn't really a good idea.
>>
>> Not that the global function with the same name in the isdn code
>> is better ;-).
>
> Agreed, the fbtft code is now fixed.  Patches to fix the isdn code would
> be gladly accepted as well :)
>

Did you have a look into the isdn code ? It will need someone
with a lot of spare time to clean this code up.

Guenter


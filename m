Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902AbaLWBuF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 20:50:05 -0500
Received: from know-smtprelay-omc-10.server.virginmedia.net ([80.0.253.74]:40337
	"EHLO know-smtprelay-omc-10.server.virginmedia.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751890AbaLWBuE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 20:50:04 -0500
X-Originating-IP: [82.36.39.136]
X-Spam: 0
X-Authority: v=2.1 cv=dY0O3Bne c=1 sm=1 tr=0 a=h3ZJzbuz6X3s3VlFudNWSw==:117
 a=h3ZJzbuz6X3s3VlFudNWSw==:17 a=DrNGYBpgUcYA:10 a=N659UExz7-8A:10
 a=a5Gf7U6LAAAA:8 a=D19gQVrFAAAA:8 a=LzpjfA9cuJCWKjV0h58A:9 a=pILNOxqGKmIA:10
Message-ID: <5498CA48.7000400@blueyonder.co.uk>
Date: Tue, 23 Dec 2014 01:50:00 +0000
From: Sid Boyce <sboyce@blueyonder.co.uk>
Reply-To: sboyce@blueyonder.co.uk
Organization: blueyonder.co.uk
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Jiri Kosina <jkosina@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Drysdale <drysdale@google.com>, Michal Marek <mmarek@suse.cz>
Subject: Re: Linux 3.19-rc1 - merge window closed
References: <CA+55aFwu19GP5vHTwadX+ygAKwOqNLuEBA9TVEdnfxgvzP1zHA@mail.gmail.com>	 <1419145899.8696.5.camel@haakon3.risingtidesystems.com>	 <20141222124310.b35177e67db8d76b64ec55f6@linux-foundation.org>	 <alpine.LRH.2.00.1412222156260.29843@twin.jikos.cz>	 <1419288214.8696.14.camel@haakon3.risingtidesystems.com>	 <CA+55aFxvP8i37MUkioxs6wjT8WKdTPuLrMiV0NZLYyGKpjeomg@mail.gmail.com> <1419290529.30945.61.camel@x220>
In-Reply-To: <1419290529.30945.61.camel@x220>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/12/14 23:22, Paul Bolle wrote:
> On Mon, 2014-12-22 at 15:02 -0800, Linus Torvalds wrote:
>> Hmm. So it seems that there is something wrong with the dependency
>> generation for the generated header files. Possibly limited to just
>> the uapi files.
>>
>> But I can't seem to recreate it even by trying to first build 3.18-rc2
>> and then switching to 3.19-rc1. So there's something
>> not-very-straightforward going on, possibly including some nasty race
>> in the Makefiles.
> The basically random build failure in
> https://lkml.org/lkml/2014/12/22/164 might be related. Still makes no
> sense to me whatsoever.
>
>
> Paul Bolle
>
>
tindog:/usr/src/linux-3.19.0-rc1 # grep GM204_DISP_CORE_CHANNEL_DMA 
drivers/gpu/drm/nouveau/core/include/nvif/class.h
tindog:/usr/src/linux-3.19.0-rc1 #

Checking the other 2 boxes it's defined so I started with a fresh clone 
and it's now defined. As usual I did git pull on all 3 boxes to get from 
3.18.0 to 3.19-rc1.

tindog:/usr/src/linux # grep GM204_DISP_CORE_CHANNEL_DMA 
drivers/gpu/drm/nouveau/core/include/nvif/class.h
#define GM204_DISP_CORE_CHANNEL_DMA 0x0000957d
Regards
Sid.

-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support
Senior Staff Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks


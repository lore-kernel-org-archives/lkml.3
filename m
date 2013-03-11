Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753145Ab3CKOU1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 10:20:27 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:2163 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750948Ab3CKOUX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 10:20:23 -0400
X-Server-Uuid: B86B6450-0931-4310-942E-F00ED04CA7AF
Message-ID: <513DE819.7060203@broadcom.com>
Date: Mon, 11 Mar 2013 15:20:09 +0100
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US;
 rv:1.9.2.24) Gecko/20111103 Lightning/1.0b2 Thunderbird/3.1.16
MIME-Version: 1.0
To: dri-devel@lists.freedesktop.org
cc: "Borislav Petkov" <bp@alien8.de>, linux-kernel@vger.kernel.org
Subject: Re: nouveau lockdep splat
References: <20130304211608.GD22274@pd.tnic>
 <513877F4.2070102@broadcom.com>
In-Reply-To: <513877F4.2070102@broadcom.com>
X-WSS-ID: 7D23392E56411027260-01-01
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/13 12:20, Arend van Spriel wrote:
> On 03/04/13 22:16, Borislav Petkov wrote:
>> New -rc1, so let the stabilization games begin.
>>
>> I see the following on rc1, let me know if you need more info.
>>
>>
>> [ 0.633617] =============================================
>> [ 0.633618] [ INFO: possible recursive locking detected ]
>> [ 0.633618] 3.9.0-rc1 #2 Not tainted
>> [ 0.633619] ---------------------------------------------
>> [ 0.633619] swapper/0/1 is trying to acquire lock:
>> [ 0.633623] (&dmac->lock){+.+...}, at: [<ffffffff8141bb53>]
>> evo_wait+0x43/0xf0
>> [ 0.633624]
>> [ 0.633624] but task is already holding lock:
>> [ 0.633626] (&dmac->lock){+.+...}, at: [<ffffffff8141bb53>]
>> evo_wait+0x43/0xf0
>> [ 0.633626]
>> [ 0.633626] other info that might help us debug this:
>> [ 0.633626] Possible unsafe locking scenario:
>> [ 0.633626]
>> [ 0.633626] CPU0
>> [ 0.633627] ----
>> [ 0.633627] lock(&dmac->lock);
>> [ 0.633628] lock(&dmac->lock);
>
> I am getting the same on my Dell Latitude e6410 and as a bonus I get
> abundant amount of nouveau error messages. These are not all as my
> system hangs after this.
>
> Ubuntu 12.04.2 LTS (GNU/Linux
> 3.9.0-rc1-wl-testing-lockdep-00002-gc181dcd i686)
>
> 01:00.0 VGA compatible controller: NVIDIA Corporation GT218 [NVS 3100M]
> (rev a2)
>
> Gr. AvS
>
> c$ dmesg
> [ 753.201712] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x0f04 data 0x00000480
> [ 753.215281] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 753.224605] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x0f04 data 0x00010360
> [ 753.238198] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS

The stuff seem to start after logging in from lightdm. It fails to start 
the windows manager and after a while I am kick back to lightdm.

I was able to capture the first messages this time. Hope it helps.

Mar 11 09:37:47 arend-lp-dev kernel: [  143.520051] nouveau E[ 
PFIFO][0000:0100.0] CACHE_ERROR - ch 1 [DRM] subc 0 mthd 0x0060 data 
0x80000002
Mar 11 09:37:47 arend-lp-dev kernel: [  143.529648] nouveau E[ 
PFB][0000:0100.0] trapped write at 0x0020014104 on channel 0x0001fca0 
[unknown] PFIFO/PFIFOREAD/SEMAPHORE reason: NULL_DMAOBJ
Mar 11 09:38:00 arend-lp-dev kernel: [  156.700076] nouveau 
E[Xorg[1360]] faile to idle channel 0xcccc0000 [Xorg[1360]]
Mar 11 09:38:00 arend-lp-dev kernel: [  156.708020] nouveau E[ 
PFB][0000:0100.0] trapped read at 0x002001a040 on channel 0x0001fb34 
[unknown] SEMAPHORE_BGPFIFO_READ/00 reason: PAGE_NOT_PRESENT
Mar 11 09:38:03 arend-lp-dev kernel: [  159.724632] nouveau 
E[compiz[2102]] faied to idle channel 0xcccc0000 [compiz[2102]]
Mar 11 09:38:03 arend-lp-dev kernel: [  159.732519] nouveau E[ 
PFB][0000:0100.0] trapped read at 0x0020014110 on channel 0x0001f96c 
[unknown] SEMAPHORE_BGPFIFO_READ/00 reason: PAGE_NOT_PRESENT
Mar 11 09:38:03 arend-lp-dev kernel: [  159.746819] nouveau E[ 
PGRAPH][0000:0100.0] TRAP_DISPATCH (unknown 0x00000004)
Mar 11 09:38:03 arend-lp-dev kernel: [  159.754213] nouveau E[ 
PDISP][0000:0100.0] chid 2 mthd 0x0080 data 0x00000000 0x000b5080
Mar 11 09:38:03 arend-lp-dev kernel: [  159.762560] nouveau E[ 
PFB][0000:0100.0] trapped read at 0x0020015210 on channel 0x0001f96c 
[unknown] SEMAPHORE_BGPFIFO_READ/00 reason: PAGE_NOT_PRESENT
Mar 11 09:38:03 arend-lp-dev kernel: [  159.776840] nouveau E[ 
PGRAPH][0000:0100.0]  ILLEGAL_MTHD ILLEGAL_CLASS
Mar 11 09:38:03 arend-lp-dev kernel: [  159.783664] nouveau E[ 
PGRAPH][0000:0100.0] ch -1 [0x001f96c000 unknown] subc 5 class 0x0000 
mthd 0x1640 data 0x3f80000
Mar 11 09:38:03 arend-lp-dev kernel: [  159.794764] nouveau E[ 
PGRAPH][0000:0100.0]  ILLEGAL_MTHD ILLEGAL_CLASS
Mar 11 09:38:03 arend-lp-dev kernel: [  159.801584] nouveau E[ 
PGRAPH][0000:0100.0] ch -1 [0x001f96c000 unknown] subc 5 class 0x0000 
mthd 0x1640 data 0x426c000
Mar 11 09:38:03 arend-lp-dev kernel: [  159.812683] nouveau E[ 
PGRAPH][0000:0100.0]  ILLEGAL_MTHD ILLEGAL_CLASS

> [ 753.247167] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x0f04 data 0x03000000
> [ 753.260757] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 753.269919] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x0f04 data 0x00000000
> [ 753.283456] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 753.292705] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x155c data 0x00000000
> [ 753.306231] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 753.315505] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x1560 data 0x20034000
> [ 753.329049] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 753.338221] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x1564 data 0x00000000
> [ 753.351752] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 753.360716] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x1280 data 0x00000000
> [ 753.374255] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 753.383226] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x1284 data 0x20034000
> [ 753.396780] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 753.405741] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x1288 data 0x00004000
> [ 753.419278] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 753.428535] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x0f00 data 0x00000000
> [ 753.442069] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 753.451006] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x0f04 data 0x000240db
> [ 753.464549] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 753.473505] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x0f04 data 0x00000051
> [ 753.487058] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 753.495994] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x0f04 data 0x00000000
> [ 753.509213] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 753.518160] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x0f04 data 0x00000000
> [ 753.531370] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 753.540630] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x0f04 data 0x00000000
> [ 753.554170] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 753.563113] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x0f04 data 0x00000000
> [ 753.576643] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 753.585897] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x0f04 data 0x00000000
> [ 753.599430] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 753.608365] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x0f04 data 0x00000000
> [ 753.621907] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 753.630847] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x1414 data 0x00000000
> [ 753.644373] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 753.653360] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x1334 data 0x00000000
> [ 753.666892] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 753.675846] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x1458 data 0x00000001
> [ 753.689388] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 753.698335] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x1458 data 0x00000203
> [ 753.711542] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 753.720745] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x0e04 data 0x00010000
> [ 753.733950] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 753.742901] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x0e08 data 0x00010000
> [ 753.756130] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 753.765391] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x15dc data 0x00000004
> [ 753.778925] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 753.787877] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x03c0 data 0xbdb1c71c
> [ 753.801418] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 753.810385] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x03c4 data 0xbde84bda
> [ 753.823934] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 753.833185] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x0680 data 0x00020000
> [ 753.846719] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 753.855978] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x03c0 data 0xbdb1c71c
> [ 753.869505] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 753.878624] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x03c4 data 0xbded097b
> [ 753.892160] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 753.901108] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x0680 data 0x00000000
> [ 753.914642] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 753.923507] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x03c0 data 0xbdae38e4
> [ 753.937005] nouveau E[ PFIFO][0000:01:00.0] CACHE_ERROR - ch 127
> [unknown] subc 0 mthd 0x0060 data 0xd8000001
> [ 753.949476] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 753.958677] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x03c4 data 0xbded097b
> [ 753.972119] nouveau E[ PFB][0000:01:00.0] trapped write at
> 0x002001a024 on channel 0x0001fb34 [unknown] PFIFO/PFIFO_READ/SEMAPHORE
> reason: PAGE_NOT_PRESENT
> [ 753.988968] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 753.998023] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x0680 data 0x00000002
> [ 754.011608] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 754.020595] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x15e0 data 0x00000000
> [ 754.034162] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 754.043134] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 2 class 0x0000 mthd 0x0200 data 0x000000cf
> [ 754.056708] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 754.065676] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 2 class 0x0000 mthd 0x0204 data 0x00000000
> [ 754.079251] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 754.088219] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 2 class 0x0000 mthd 0x0208 data 0x00000030
> [ 754.101799] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 754.110772] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 2 class 0x0000 mthd 0x020c data 0x00000001
> [ 754.124346] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 754.133314] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 2 class 0x0000 mthd 0x0210 data 0x00000000
> [ 754.146882] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 754.155851] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 2 class 0x0000 mthd 0x0218 data 0x00000020
> [ 754.169422] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 754.178405] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 2 class 0x0000 mthd 0x021c data 0x00000020
> [ 754.191985] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 754.200975] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 2 class 0x0000 mthd 0x0220 data 0x00000000
> [ 754.214553] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 754.223555] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 2 class 0x0000 mthd 0x0224 data 0x212c7000
> [ 754.237146] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 754.246446] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 2 class 0x0000 mthd 0x0280 data 0x00000000
> [ 754.260017] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 754.269315] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 2 class 0x0000 mthd 0x0284 data 0x00000000
> [ 754.282893] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 754.292190] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 2 class 0x0000 mthd 0x0288 data 0x00000020
> [ 754.305821] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 754.315124] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 2 class 0x0000 mthd 0x028c data 0x00000020
> [ 754.328713] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 754.338030] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 2 class 0x0000 mthd 0x02ac data 0x00000003
> [ 754.351612] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 754.360910] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 2 class 0x0000 mthd 0x0580 data 0x00000004
> [ 754.374487] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 754.383699] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 2 class 0x0000 mthd 0x0584 data 0x000000cf
> [ 754.397295] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 754.406313] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 2 class 0x0000 mthd 0x0588 data 0x00000000
> [ 754.419898] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 754.428806] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 2 class 0x0000 mthd 0x0600 data 0x00000000
> [ 754.442344] nouveau E[ PFIFO][0000:01:00.0] CACHE_ERROR - ch 127
> [unknown] subc 0 mthd 0x0010 data 0x00000000
> [ 754.454576] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 754.463849] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 2 class 0x0000 mthd 0x0604 data 0x00000000
> [ 754.477338] nouveau E[ PFB][0000:01:00.0] trapped write at
> 0x002001a024 on channel 0x0001fb34 [unknown] PFIFO/PFIFO_READ/SEMAPHORE
> reason: NULL_DMAOBJ
> [ 754.493774] nouveau E[ PFIFO][0000:01:00.0] CACHE_ERROR - ch 127
> [unknown] subc 3 mthd 0x0188 data 0xd8000002
> [ 754.506331] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 754.515662] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 2 class 0x0000 mthd 0x0608 data 0x00000020
> [ 754.529286] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 754.538323] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 2 class 0x0000 mthd 0x060c data 0x00000020
> [ 754.551930] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 754.560955] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 2 class 0x0000 mthd 0x0200 data 0x000000cf
> [ 754.574572] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 754.583605] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 2 class 0x0000 mthd 0x0204 data 0x00000000
> [ 754.597220] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 754.606548] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 2 class 0x0000 mthd 0x0208 data 0x00000030
> [ 754.620138] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 754.629127] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 2 class 0x0000 mthd 0x020c data 0x00000001
> [ 754.642713] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 754.651707] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 2 class 0x0000 mthd 0x0210 data 0x00000000
> [ 754.664971] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 754.673948] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 2 class 0x0000 mthd 0x0218 data 0x00000020
> [ 754.687201] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 754.696502] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 2 class 0x0000 mthd 0x021c data 0x00000020
> [ 754.710081] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 754.719409] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 2 class 0x0000 mthd 0x0220 data 0x00000000
> [ 754.732995] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 754.741982] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 2 class 0x0000 mthd 0x0224 data 0x212c7000
> [ 754.755579] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 754.764571] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 2 class 0x0000 mthd 0x0280 data 0x00000000
> [ 754.778156] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 754.787469] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 2 class 0x0000 mthd 0x0284 data 0x00000000
> [ 754.801060] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 754.810374] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 2 class 0x0000 mthd 0x0288 data 0x00000020
> [ 754.823972] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 754.833282] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 2 class 0x0000 mthd 0x028c data 0x00000020
> [ 754.846869] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 754.856178] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 2 class 0x0000 mthd 0x02ac data 0x00000003
> [ 754.869760] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 754.879086] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 2 class 0x0000 mthd 0x0580 data 0x00000004
> [ 754.892686] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 754.901992] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 2 class 0x0000 mthd 0x0584 data 0x000000cf
> [ 754.915568] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 754.924562] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 2 class 0x0000 mthd 0x0588 data 0x00000000
> [ 754.937825] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 754.946798] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 2 class 0x0000 mthd 0x0200 data 0x000000cf
> [ 754.960043] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 754.969332] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 2 class 0x0000 mthd 0x0204 data 0x00000000
> [ 754.982916] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 754.992218] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 2 class 0x0000 mthd 0x0208 data 0x00000030
> [ 755.005796] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 755.015108] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 2 class 0x0000 mthd 0x020c data 0x00000001
> [ 755.028693] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 755.038016] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 2 class 0x0000 mthd 0x0210 data 0x00000000
> [ 755.051605] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 755.060589] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 2 class 0x0000 mthd 0x0218 data 0x00000020
> [ 755.074162] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 755.083142] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 2 class 0x0000 mthd 0x021c data 0x00000020
> [ 755.096709] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 755.105713] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 2 class 0x0000 mthd 0x0220 data 0x00000000
> [ 755.119294] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 755.128255] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 2 class 0x0000 mthd 0x0224 data 0x212c7000
> [ 755.141813] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 755.150769] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 2 class 0x0000 mthd 0x0280 data 0x00000000
> [ 755.164323] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 755.173280] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 2 class 0x0000 mthd 0x0284 data 0x00000000
> [ 755.186830] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 755.195848] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 2 class 0x0000 mthd 0x0288 data 0x00000020
> [ 755.209398] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 755.218355] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 2 class 0x0000 mthd 0x028c data 0x00000020
> [ 755.231910] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 755.240879] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 2 class 0x0000 mthd 0x02ac data 0x00000003
> [ 755.254428] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 755.263377] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 2 class 0x0000 mthd 0x0580 data 0x00000004
> [ 755.276923] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 755.285875] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 2 class 0x0000 mthd 0x0584 data 0x000000cf
> [ 755.299421] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 755.308379] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 2 class 0x0000 mthd 0x0588 data 0xffffffff
> [ 755.321939] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 755.330898] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 2 class 0x0000 mthd 0x0600 data 0x00000007
> [ 755.344484] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 755.353430] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 3 class 0x0000 mthd 0x0604 data 0x00000007
> [ 755.366640] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 755.375583] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 3 class 0x0000 mthd 0x0608 data 0x00000017
> [ 755.389121] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 755.398395] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 3 class 0x0000 mthd 0x060c data 0x00000017
> [ 755.411943] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 755.420898] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 3 class 0x0000 mthd 0x0200 data 0x00000000
> [ 755.434431] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 755.443363] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 3 class 0x0000 mthd 0x0204 data 0x00000030
> [ 755.456906] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 755.465852] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 3 class 0x0000 mthd 0x0208 data 0x00000080
> [ 755.479077] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 755.488009] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 3 class 0x0000 mthd 0x020c data 0x00000020
> [ 755.501221] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 755.510475] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 3 class 0x0000 mthd 0x0210 data 0x00000001
> [ 755.524010] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 755.532971] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 3 class 0x0000 mthd 0x0214 data 0x00000000
> [ 755.546189] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 755.555122] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 3 class 0x0000 mthd 0x0218 data 0x00000000
> [ 755.568323] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 755.577579] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 3 class 0x0000 mthd 0x021c data 0x00000001
> [ 755.591117] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 755.600066] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 3 class 0x0000 mthd 0x0238 data 0x00000000
> [ 755.613593] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 755.622538] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 3 class 0x0000 mthd 0x023c data 0x00000000
> [ 755.636056] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 755.645000] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 3 class 0x0000 mthd 0x030c data 0x212c7000
> [ 755.663995] nouveau E[compiz[2734]] failed to idle channel 0xcccc0000
> [compiz[2734]]
> [ 755.658524] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 755.677173] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 3 class 0x0000 mthd 0x0310 data 0x20041000
> [ 755.690298] nouveau E[ PFB][0000:01:00.0] trapped read at 0x0020014110
> on channel 0x0001f96c [unknown] SEMAPHORE_BG/PFIFO_READ/00 reason:
> PAGE_NOT_PRESENT
> [ 755.706716] nouveau E[ PFIFO][0000:01:00.0] CACHE_ERROR - ch 127
> [unknown] subc 0 mthd 0x001c data 0x00000002
> [ 755.719083] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 755.728006] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 3 class 0x0000 mthd 0x0314 data 0x00000000
> [ 755.741211] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 755.750438] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 3 class 0x0000 mthd 0x0318 data 0x00000080
> [ 755.763930] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 755.772870] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 3 class 0x0000 mthd 0x031c data 0x00000080
> [ 755.786077] nouveau E[ PFIFO][0000:01:00.0] CACHE_ERROR - ch 127
> [unknown] subc 0 mthd 0x0010 data 0x00000000
> [ 755.798280] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 755.807196] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 3 class 0x0000 mthd 0x0320 data 0x00000020
> [ 755.820339] nouveau E[ PFB][0000:01:00.0] trapped write at
> 0x002001a024 on channel 0x0001fb34 [unknown] PFIFO/PFIFO_READ/SEMAPHORE
> reason: NULL_DMAOBJ
> [ 755.836420] nouveau E[ PFIFO][0000:01:00.0] CACHE_ERROR - ch 127
> [unknown] subc 0 mthd 0x0010 data 0x00000000
> [ 755.849005] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 755.858273] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 3 class 0x0000 mthd 0x0324 data 0x00000101
> [ 755.871761] nouveau E[ PFB][0000:01:00.0] trapped write at
> 0x002001a024 on channel 0x0001fb34 [unknown] PFIFO/PFIFO_READ/SEMAPHORE
> reason: NULL_DMAOBJ
> [ 755.888156] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 755.897105] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 3 class 0x0000 mthd 0x0328 data 0x00000000
> [ 757.285204] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 757.292029] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 2 class 0x0000 mthd 0x0220 data 0x00000000
> [ 757.303153] nouveau E[ PFIFO][0000:01:00.0] CACHE_ERROR - ch 127
> [unknown] subc 1 mthd 0x0500 data 0x00000000
> [ 757.313239] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 757.320062] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 2 class 0x0000 mthd 0x0224 data 0x212c7000
> [ 757.331184] nouveau E[ PFIFO][0000:01:00.0] CACHE_ERROR - ch 127
> [unknown] subc 0 mthd 0x0060 data 0xbeef0201
> [ 757.341275] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 757.348091] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 2 class 0x0000 mthd 0x0280 data 0x00000000
> [ 757.359131] nouveau E[ PFB][0000:01:00.0] trapped write at
> 0x0020012044 on channel 0x0001fb34 [unknown] PFIFO/PFIFO_READ/SEMAPHORE
> reason: NULL_DMAOBJ
> [ 757.373077] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 757.379899] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x121c data 0x0fac6881
> [ 757.391028] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 757.397850] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x0ff4 data 0x04800000
> [ 757.408949] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 757.415769] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x0ff8 data 0x03600000
> [ 757.426881] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 757.433701] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x0200 data 0x00000000
> [ 757.444814] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 757.451632] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x0204 data 0x40bb0000
> [ 757.462740] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 757.469561] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x0208 data 0x000000cf
> [ 757.480670] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 757.487487] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x020c data 0x00000040
> [ 757.498606] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 757.505425] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x0210 data 0x00000000
> [ 757.516534] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 757.523351] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x1240 data 0x00000480
> [ 757.534446] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 757.541266] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x1244 data 0x00000360
> [ 757.552364] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 757.559184] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x1224 data 0x00000001
> [ 757.570295] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 757.577114] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x0fe0 data 0x00000000
> [ 757.588227] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 757.595049] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x0fe4 data 0x40770000
> [ 757.606158] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 757.612984] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x0fe8 data 0x00000016
> [ 757.624092] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 757.630909] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x0fec data 0x00000040
> [ 757.642019] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 757.648836] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x0ff0 data 0x00000000
> [ 757.659944] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 757.666768] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x1538 data 0x00000001
> [ 757.677864] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 757.684683] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x1228 data 0x00000480
> [ 757.695790] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 757.702607] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x122c data 0x00000360
> [ 757.713895] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 757.720711] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x1230 data 0x00010001
> [ 757.731825] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 757.738641] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x15d0 data 0x00000000
> [ 757.749752] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 757.756569] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x0c00 data 0x04800000
> [ 757.767668] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 757.774487] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x0c04 data 0x03600000
> [ 757.785595] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 757.792413] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x12e4 data 0x00000000
> [ 757.803518] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 757.810339] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x0f90 data 0x00000001
> [ 757.821445] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 757.828261] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x135c data 0x00000001
> [ 757.839367] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 757.846186] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x1360 data 0x00000000
> [ 757.857315] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 757.864133] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x19c4 data 0x00000000
> [ 757.875242] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 757.882055] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x1a00 data 0x00001111
> [ 757.893169] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 757.899991] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x153c data 0x00000000
> [ 757.911090] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 757.917910] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x12d4 data 0x00001d01
> [ 757.929008] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 757.935827] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x1684 data 0x00000001
> [ 757.946932] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 757.953758] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x1688 data 0x00000000
> [ 757.964867] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 757.971687] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x13a8 data 0x11111111
> [ 757.982797] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 757.989616] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x1534 data 0x00000000
> [ 758.000748] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 758.007571] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x13b0 data 0x3f800000
> [ 758.018699] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 758.025518] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x1570 data 0x00000000
> [ 758.036649] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 758.043471] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x166c data 0x00000000
> [ 758.054593] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 758.061412] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x1518 data 0x3f800000
> [ 758.072549] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 758.079365] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x1520 data 0x00000000
> [ 758.090489] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 758.097308] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x1658 data 0x00000000
> [ 758.108437] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 758.115254] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x0dac data 0x00001b02
> [ 758.126376] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 758.133195] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x0db0 data 0x00001b02
> [ 758.144308] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 758.151127] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x0db4 data 0x00000000
> [ 758.162231] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 758.169050] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x1918 data 0x00000001
> [ 758.180164] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 758.186982] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x191c data 0x00000901
> [ 758.198100] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 758.204922] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x1920 data 0x00000405
> [ 758.216021] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 758.222837] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x168c data 0x00000000
> [ 758.233949] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 758.240765] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x0dc0 data 0x00000000
> [ 758.251876] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 758.258692] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x0dc4 data 0x00000000
> [ 758.269808] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 758.276631] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x0dc8 data 0x00000000
> [ 758.287741] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 758.294562] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x193c data 0x00000000
> [ 758.305688] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 758.312508] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x0e04 data 0x04800000
> [ 758.323620] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 758.330442] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x0e08 data 0x03600000
> [ 758.341551] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 758.348372] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x0a0c data 0x44100000
> [ 758.359484] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 758.366307] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x0a10 data 0x43d80000
> [ 758.377418] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 758.384240] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x0a14 data 0x3f000000
> [ 758.395352] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 758.402170] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x0a00 data 0x44100000
> [ 758.413289] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 758.420111] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x0a04 data 0xc3d80000
> [ 758.431222] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 758.438041] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x0a08 data 0x3f000000
> [ 758.449154] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 758.455974] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x0c08 data 0x00000000
> [ 758.467083] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 758.473906] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x0c0c data 0x3f800000
> [ 758.485018] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 758.491836] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x1650 data 0x000000ff
> [ 758.502945] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 758.509764] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x1654 data 0x00000000
> [ 758.520876] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 758.527692] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x16b8 data 0x00000008
> [ 758.538806] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 758.545630] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x16b0 data 0x00000004
> [ 758.556743] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 758.563563] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x140c data 0x0007ff00
> [ 758.574677] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 758.581497] nouveau E[ PGRAPH][0000:01:00.0] ch -1 [0x001fb34000
> unknown] subc 5 class 0x0000 mthd 0x198c data 0x00000004
> [ 758.592623] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 758.599451] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1298 data 0x00000004
> [ 758.610747] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 758.617572] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x19a8 data 0x00000000
> [ 758.628852] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 758.635673] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x196c data 0x00000000
> [ 758.646949] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 758.653774] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1414 data 0x0007ff00
> [ 758.665051] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 758.671873] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x164c data 0x00000000
> [ 758.683146] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 758.689966] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1914 data 0x00000000
> [ 758.701239] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 758.708195] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x16ac data 0x00000007
> [ 758.719470] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 758.726293] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x16bc data 0x03020100
> [ 758.737567] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 758.744392] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x16c0 data 0x40070504
> [ 758.755665] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 758.762491] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1904 data 0x01000404
> [ 758.773767] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 758.780589] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1908 data 0x00000004
> [ 758.791864] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 758.798691] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x190c data 0x00000000
> [ 758.809964] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 758.816793] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1910 data 0x00000000
> [ 758.828065] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 758.834893] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1988 data 0x08030403
> [ 758.846165] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 758.852994] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1540 data 0x00000000
> [ 758.864267] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 758.871095] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1544 data 0x00000000
> [ 758.882370] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 758.889201] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1548 data 0x00000000
> [ 758.900477] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 758.907303] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x154c data 0x00000000
> [ 758.918574] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 758.925403] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1798 data 0x00000000
> [ 758.936677] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 758.943507] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1510 data 0x00000000
> [ 758.954779] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 758.961603] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f00 data 0x0000007c
> [ 758.972876] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 758.979703] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f04 data 0x3ac511a3
> [ 758.990976] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 758.997803] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f04 data 0x00000000
> [ 759.009076] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 759.015900] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f04 data 0x00000000
> [ 759.027170] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 759.033996] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f04 data 0x00000000
> [ 759.045274] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 759.052097] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f04 data 0x80000000
> [ 759.063372] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 759.070199] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f04 data 0xbb036117
> [ 759.081470] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 759.088304] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f04 data 0x00000000
> [ 759.099580] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 759.106406] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f04 data 0x00000000
> [ 759.117678] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 759.124516] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f04 data 0x00000000
> [ 759.135791] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 759.142628] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f04 data 0x00000000
> [ 759.153903] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 759.160724] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f04 data 0xbf80419a
> [ 759.171996] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 759.178818] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f04 data 0xbf800000
> [ 759.190093] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 759.196919] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f04 data 0xbf5db3d7
> [ 759.208197] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 759.215022] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f04 data 0x3f5db3d7
> [ 759.226291] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 759.233122] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f04 data 0x3f2ae525
> [ 759.244400] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 759.251234] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f04 data 0x3f5db3d7
> [ 759.262505] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 759.269332] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f00 data 0x0000007d
> [ 759.280604] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 759.287434] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f04 data 0x00000000
> [ 759.298708] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 759.305545] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f04 data 0x00000000
> [ 759.316817] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 759.323642] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f04 data 0x00000000
> [ 759.334916] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 759.341743] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f04 data 0x00000000
> [ 759.353011] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 759.359845] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f04 data 0x00000000
> [ 759.371119] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 759.377945] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f04 data 0x00000000
> [ 759.389218] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 759.396039] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f04 data 0x00000000
> [ 759.407315] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 759.414140] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f04 data 0x3f800000
> [ 759.425414] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 759.432238] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f04 data 0x3f800000
> [ 759.443522] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 759.450347] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f04 data 0x00000000
> [ 759.461618] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 759.468444] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f04 data 0x00000000
> [ 759.479714] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 759.486540] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f04 data 0x00000000
> [ 759.497811] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 759.504644] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f04 data 0x00000000
> [ 759.515917] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 759.522759] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f04 data 0x00000000
> [ 759.534036] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 759.540860] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f04 data 0xbf800000
> [ 759.552135] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 759.558970] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f04 data 0x3f800000
> [ 759.570263] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 759.577089] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f04 data 0x3f800000
> [ 759.588362] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 759.595189] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f04 data 0x3f800000
> [ 759.606468] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 759.613295] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f04 data 0x3f800000
> [ 759.624565] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 759.631398] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f04 data 0x3f800000
> [ 759.642674] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 759.649501] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1458 data 0x00000001
> [ 759.660773] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 759.667602] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1454 data 0x00000001
> [ 759.678875] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 759.685708] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1ac0 data 0x7e100000
> [ 759.696979] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 759.703888] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1ac4 data 0x7e200001
> [ 759.715162] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 759.721991] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0900 data 0x00000000
> [ 759.733266] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 759.740104] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0910 data 0x00000000
> [ 759.751383] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 759.758210] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1ac8 data 0x7e080010
> [ 759.769482] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 759.776317] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0920 data 0x00000000
> [ 759.787588] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 759.794418] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x15dc data 0x00000007
> [ 759.805690] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 759.812528] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1640 data 0x00000000
> [ 759.823807] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 759.830635] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1640 data 0x00000000
> [ 759.841907] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 759.848734] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1640 data 0x00000000
> [ 759.860006] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 759.866828] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1640 data 0x00000000
> [ 759.878102] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 759.884927] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1640 data 0x00000000
> [ 759.896203] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 759.903030] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1640 data 0x00000000
> [ 759.914300] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 759.921127] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1640 data 0x44580000
> [ 759.932399] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 759.939226] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1640 data 0x00000000
> [ 759.950496] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 759.957319] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1640 data 0x00000000
> [ 759.968596] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 759.975435] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1640 data 0x3f800000
> [ 759.986708] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 759.993534] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1640 data 0x44900000
> [ 760.004806] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 760.011631] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1640 data 0x44580000
> [ 760.022905] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 760.029737] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1640 data 0x00000000
> [ 760.041011] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 760.047836] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1640 data 0x3f800000
> [ 760.059111] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 760.065947] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1640 data 0x3f800000
> [ 760.077226] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 760.084060] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1640 data 0x44900000
> [ 760.095339] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 760.102162] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1640 data 0x00000000
> [ 760.113434] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 760.120268] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1640 data 0x00000000
> [ 760.131545] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 760.138382] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1640 data 0x3f800000
> [ 760.149661] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 760.156485] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1640 data 0x00000000
> [ 760.167757] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 760.174583] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x15e0 data 0x00000000
> [ 760.185857] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 760.192691] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x12e4 data 0x00000000
> [ 760.203971] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 760.210795] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f90 data 0x00000001
> [ 760.222068] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 760.228897] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x135c data 0x00000001
> [ 760.240167] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 760.246994] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1360 data 0x00000001
> [ 760.258271] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 760.265096] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1340 data 0x00008006
> [ 760.276368] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 760.283194] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1344 data 0x00004001
> [ 760.294466] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 760.301292] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1348 data 0x00004303
> [ 760.312564] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 760.319387] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x134c data 0x00008006
> [ 760.330659] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 760.337485] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1350 data 0x00004001
> [ 760.348758] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 760.355583] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1358 data 0x00004303
> [ 760.366851] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 760.373676] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x19c4 data 0x00000000
> [ 760.384950] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 760.391775] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1a00 data 0x00001111
> [ 760.403049] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 760.409878] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x153c data 0x00000000
> [ 760.421152] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 760.427985] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x198c data 0x00000004
> [ 760.439263] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 760.446090] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1298 data 0x00000004
> [ 760.457361] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 760.464199] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x19a8 data 0x00000000
> [ 760.475483] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 760.482320] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x196c data 0x00000000
> [ 760.493594] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 760.500419] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1414 data 0x0007fb00
> [ 760.511691] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 760.518519] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x164c data 0x00000000
> [ 760.529790] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 760.536624] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1914 data 0x00000000
> [ 760.547896] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 760.554719] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x16ac data 0x00000007
> [ 760.565992] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 760.572816] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x16bc data 0x03020100
> [ 760.584087] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 760.590914] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x16c0 data 0x40070504
> [ 760.602188] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 760.609017] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1904 data 0x01000404
> [ 760.620292] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 760.627120] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1908 data 0x00000004
> [ 760.638395] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 760.645224] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x190c data 0x00000000
> [ 760.656493] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 760.663318] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1910 data 0x00000000
> [ 760.674591] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 760.681415] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1988 data 0x08030403
> [ 760.692687] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 760.699650] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1540 data 0x00000000
> [ 760.710924] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 760.717745] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1544 data 0x00000000
> [ 760.729015] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 760.735845] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1548 data 0x00000000
> [ 760.747119] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 760.753948] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x154c data 0x00000000
> [ 760.765221] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 760.772047] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1798 data 0x00000000
> [ 760.783327] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 760.790154] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f00 data 0x0000007c
> [ 760.801427] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 760.808254] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f04 data 0x3ac511a3
> [ 760.819527] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 760.826351] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f04 data 0x00000000
> [ 760.837622] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 760.844455] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f04 data 0x00000000
> [ 760.855727] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 760.862560] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f04 data 0x00000000
> [ 760.873833] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 760.880657] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f04 data 0x80000000
> [ 760.891928] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 760.898753] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f04 data 0xbb036117
> [ 760.910025] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 760.916860] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f04 data 0x00000000
> [ 760.928132] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 760.934954] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f04 data 0x00000000
> [ 760.946227] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 760.953054] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f04 data 0x00000000
> [ 760.964326] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 760.971155] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f04 data 0x00000000
> [ 760.982434] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 760.989271] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f04 data 0xbf80419a
> [ 761.000552] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 761.007378] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f04 data 0xbf800000
> [ 761.018650] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 761.025474] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f04 data 0xbf5db3d7
> [ 761.036747] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 761.043574] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f04 data 0x3f5db3d7
> [ 761.054847] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 761.061674] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f04 data 0x3f2ae525
> [ 761.072946] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 761.079779] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f04 data 0x3f5db3d7
> [ 761.091054] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 761.097883] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f00 data 0x0000007d
> [ 761.109156] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 761.115982] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f04 data 0x00000000
> [ 761.127255] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 761.134084] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f04 data 0x00000000
> [ 761.145356] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 761.152190] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f04 data 0x00000000
> [ 761.163466] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 761.170288] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f04 data 0x00000000
> [ 761.181562] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 761.188390] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f04 data 0x00000000
> [ 761.199664] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 761.206488] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f04 data 0x00000000
> [ 761.217765] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 761.224589] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f04 data 0x00000000
> [ 761.235858] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 761.242684] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f04 data 0x3f800000
> [ 761.253952] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 761.260785] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f04 data 0x3f800000
> [ 761.272060] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 761.278885] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f04 data 0x00000000
> [ 761.290158] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 761.296986] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f04 data 0x00000000
> [ 761.308258] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 761.315084] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f04 data 0x00000000
> [ 761.326357] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 761.333183] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f04 data 0x00000000
> [ 761.344456] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 761.351278] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f04 data 0x00000000
> [ 761.362552] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 761.369384] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f04 data 0xbf800000
> [ 761.380662] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 761.387488] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f04 data 0x3f800000
> [ 761.398758] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 761.405584] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f04 data 0x3f800000
> [ 761.416857] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 761.423690] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f04 data 0x3f800000
> [ 761.434966] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 761.441788] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f04 data 0x3f800000
> [ 761.453061] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 761.459887] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f04 data 0x3f800000
> [ 761.471159] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 761.477985] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1458 data 0x00002c01
> [ 761.489258] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 761.496083] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1454 data 0x00004001
> [ 761.507365] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 761.514190] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1ac0 data 0x7e200000
> [ 761.525460] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 761.532285] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1ac4 data 0x7e200001
> [ 761.543560] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 761.550387] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0900 data 0x20000010
> [ 761.561657] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 761.568483] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1080 data 0x00000000
> [ 761.579757] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 761.586590] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1084 data 0x20223fff
> [ 761.597871] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 761.604694] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0904 data 0x00000000
> [ 761.615966] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 761.622790] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0908 data 0x20214048
> [ 761.634060] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 761.640895] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0910 data 0x20000010
> [ 761.652174] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 761.659011] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1088 data 0x00000000
> [ 761.670283] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 761.677110] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x108c data 0x20223fff
> [ 761.688383] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 761.695310] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0914 data 0x00000000
> [ 761.706582] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 761.713419] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0918 data 0x20214040
> [ 761.724698] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 761.731525] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x142c data 0x00000000
> [ 761.742795] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 761.749621] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x15dc data 0x00000007
> [ 761.760895] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 761.767721] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0d74 data 0x00000000
> [ 761.778993] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 761.785822] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0d78 data 0x00000004
> [ 761.797096] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 761.803926] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x15e0 data 0x00000000
> [ 761.815199] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 761.822023] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x12d4 data 0x00001d01
> [ 761.833298] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 761.840123] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1684 data 0x00000001
> [ 761.851397] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 761.858225] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1688 data 0x00000000
> [ 761.869500] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 761.876330] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x13a8 data 0x11111111
> [ 761.887603] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 761.894426] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1534 data 0x00000000
> [ 761.905699] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 761.912524] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x13b0 data 0x3f800000
> [ 761.923796] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 761.930622] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1570 data 0x00000000
> [ 761.941900] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 761.948726] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x166c data 0x00000000
> [ 761.960001] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 761.966828] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1518 data 0x3f800000
> [ 761.978100] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 761.984925] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1520 data 0x00000000
> [ 761.996196] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 762.003031] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1658 data 0x00000000
> [ 762.014311] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 762.021135] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0dac data 0x00001b02
> [ 762.032410] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 762.039239] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0db0 data 0x00001b02
> [ 762.050508] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 762.057333] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0db4 data 0x00000000
> [ 762.068610] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 762.075434] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1918 data 0x00000000
> [ 762.086704] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 762.093529] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x191c data 0x00000901
> [ 762.104800] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 762.111622] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1920 data 0x00000405
> [ 762.122898] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 762.129724] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x168c data 0x00000000
> [ 762.140999] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 762.147825] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0dc0 data 0x00000000
> [ 762.159097] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 762.165930] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0dc4 data 0x00000000
> [ 762.177205] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 762.184030] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0dc8 data 0x00000000
> [ 762.195303] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 762.202126] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x193c data 0x00000000
> [ 762.213399] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 762.220231] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0e04 data 0x04800000
> [ 762.231509] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 762.238337] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0e08 data 0x03600000
> [ 762.249608] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 762.256441] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1650 data 0x00000fff
> [ 762.267713] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 762.274546] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1654 data 0x00000000
> [ 762.285816] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 762.292641] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x16b8 data 0x0000000c
> [ 762.303911] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 762.310735] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x16b0 data 0x00000004
> [ 762.322004] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 762.328826] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x140c data 0x0007fd00
> [ 762.340102] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 762.346940] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x198c data 0x00000006
> [ 762.358216] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 762.365039] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1298 data 0x00000004
> [ 762.376313] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 762.383141] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x19a8 data 0x00000000
> [ 762.394414] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 762.401253] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x196c data 0x00000000
> [ 762.412531] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 762.419362] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1414 data 0x0007fd00
> [ 762.430640] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 762.437460] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x164c data 0x00000000
> [ 762.448734] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 762.455558] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1914 data 0x00000000
> [ 762.466828] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 762.473662] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x16ac data 0x0000000a
> [ 762.484939] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 762.491776] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x16bc data 0x03020100
> [ 762.503048] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 762.509871] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x16c0 data 0x07060504
> [ 762.521144] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 762.527974] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x16c4 data 0x40400908
> [ 762.539257] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 762.546089] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1904 data 0x01000404
> [ 762.557369] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 762.564195] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1908 data 0x00000004
> [ 762.575466] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 762.582291] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x190c data 0x00000000
> [ 762.593564] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 762.600404] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1910 data 0x00000000
> [ 762.611682] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 762.618508] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1988 data 0x08060406
> [ 762.629778] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 762.636613] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1540 data 0x00000000
> [ 762.647891] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 762.654722] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1544 data 0x00000000
> [ 762.665995] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 762.672820] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1548 data 0x00000000
> [ 762.684095] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 762.690916] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x154c data 0x00000000
> [ 762.702286] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 762.709120] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1798 data 0x00000000
> [ 762.720399] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 762.727222] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1510 data 0x00000000
> [ 762.738503] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 762.745324] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f00 data 0x0000007c
> [ 762.756601] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 762.763426] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f04 data 0x3ae38e39
> [ 762.774699] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 762.781522] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f04 data 0x00000000
> [ 762.792795] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 762.799618] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f04 data 0x00000000
> [ 762.810891] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 762.817711] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f04 data 0x00000000
> [ 762.828983] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 762.835800] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f04 data 0x00000000
> [ 762.847075] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 762.853897] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f04 data 0xbb17b426
> [ 762.865169] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 762.871989] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f04 data 0x00000000
> [ 762.883260] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 762.890084] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f04 data 0x00000000
> [ 762.901370] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 762.908189] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f04 data 0x00000000
> [ 762.919462] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 762.926281] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f04 data 0x00000000
> [ 762.937553] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 762.944374] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f04 data 0xbf800000
> [ 762.955647] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 762.962467] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f04 data 0x00000000
> [ 762.973740] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 762.980561] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f04 data 0xbf800000
> [ 762.991835] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 762.998657] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f04 data 0x3f800000
> [ 763.009932] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 763.016754] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f04 data 0x00000000
> [ 763.028026] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 763.034849] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f04 data 0x3f800000
> [ 763.046122] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 763.052943] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f00 data 0x0000007d
> [ 763.064218] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 763.071038] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f04 data 0x00000000
> [ 763.082313] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 763.089136] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f04 data 0x00000000
> [ 763.100410] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 763.107231] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f04 data 0x00000000
> [ 763.118505] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 763.125328] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f04 data 0x00000000
> [ 763.136602] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 763.143425] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1338 data 0x00000020
> [ 763.154696] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 763.161519] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1458 data 0x00000201
> [ 763.172794] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 763.179613] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1454 data 0x00001001
> [ 763.190885] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 763.197706] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1ac0 data 0x7e080000
> [ 763.208981] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 763.215800] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1ac4 data 0x7e080001
> [ 763.227074] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 763.233893] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1ac8 data 0x7e080002
> [ 763.245166] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 763.251988] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0900 data 0x00000000
> [ 763.263262] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 763.270083] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0910 data 0x00000000
> [ 763.281357] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 763.288181] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0920 data 0x00000000
> [ 763.299458] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 763.306276] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x15dc data 0x00000006
> [ 763.317550] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 763.324372] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1640 data 0x00000000
> [ 763.335644] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 763.342466] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1640 data 0x00000000
> [ 763.353740] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 763.360560] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1640 data 0x00000000
> [ 763.371834] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 763.378654] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1640 data 0x3f800000
> [ 763.389925] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 763.396745] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1640 data 0x00000000
> [ 763.408019] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 763.414840] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1640 data 0x00000000
> [ 763.426127] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 763.432944] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1640 data 0x00000000
> [ 763.444216] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 763.451039] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1640 data 0x00000000
> [ 763.462313] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 763.469133] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1640 data 0x00000000
> [ 763.480407] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 763.487229] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1640 data 0x3f800000
> [ 763.498501] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 763.505322] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1640 data 0x00000000
> [ 763.516595] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 763.523418] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1640 data 0x00000000
> [ 763.534692] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 763.541512] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1640 data 0x00000000
> [ 763.552796] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 763.559617] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1640 data 0x44580000
> [ 763.570899] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 763.577718] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1640 data 0x00000000
> [ 763.588991] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 763.595812] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1640 data 0x3f800000
> [ 763.607086] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 763.613907] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1640 data 0x00000000
> [ 763.625179] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 763.632000] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1640 data 0x00000000
> [ 763.643274] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 763.650098] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1640 data 0x00000000
> [ 763.661387] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 763.668205] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1640 data 0x00000000
> [ 763.679478] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 763.686297] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1640 data 0x00000000
> [ 763.697699] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 763.704524] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1640 data 0x00000000
> [ 763.715811] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 763.722634] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1640 data 0x00000000
> [ 763.733910] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 763.740733] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1640 data 0x00000000
> [ 763.752006] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 763.758827] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1640 data 0x44900000
> [ 763.770115] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 763.776933] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1640 data 0x44580000
> [ 763.788205] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 763.795024] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1640 data 0x00000000
> [ 763.806296] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 763.813116] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1640 data 0x3f800000
> [ 763.824406] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 763.831228] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1640 data 0x00000000
> [ 763.842508] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 763.849328] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1640 data 0x00000000
> [ 763.860599] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 763.867419] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1640 data 0x00000000
> [ 763.878691] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 763.885512] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1640 data 0x00000000
> [ 763.896783] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 763.903603] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1640 data 0x3f800000
> [ 763.914875] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 763.921696] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1640 data 0x00000000
> [ 763.932970] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 763.939790] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1640 data 0x00000000
> [ 763.951069] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 763.957897] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1640 data 0x00000000
> [ 763.969172] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 763.975991] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1640 data 0x44900000
> [ 763.987286] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 763.994109] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1640 data 0x00000000
> [ 764.005397] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 764.012218] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1640 data 0x00000000
> [ 764.023510] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 764.030334] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1640 data 0x3f800000
> [ 764.041623] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 764.048443] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1640 data 0x00000000
> [ 764.059732] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 764.066552] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1640 data 0x00000000
> [ 764.077834] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 764.084653] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1640 data 0x00000000
> [ 764.095939] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 764.102756] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1640 data 0x00000000
> [ 764.114044] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 764.120866] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1640 data 0x3f800000
> [ 764.132153] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 764.138976] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1640 data 0x3f800000
> [ 764.150255] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 764.157078] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1640 data 0x00000000
> [ 764.168351] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 764.175173] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1640 data 0x00000000
> [ 764.186458] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 764.193278] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x15e0 data 0x00000000
> [ 764.204547] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 764.211370] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x121c data 0x0fac6881
> [ 764.222643] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 764.229466] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0ff4 data 0x00410000
> [ 764.240754] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 764.247572] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0ff8 data 0x03480000
> [ 764.258849] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 764.265670] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0200 data 0x00000000
> [ 764.276944] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 764.283768] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0204 data 0x42e40000
> [ 764.295042] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 764.301865] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0208 data 0x000000cf
> [ 764.313137] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 764.319958] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x020c data 0x00000040
> [ 764.331230] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 764.338055] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0210 data 0x00000000
> [ 764.349338] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 764.356156] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1240 data 0x00000041
> [ 764.367428] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 764.374249] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1244 data 0x00000348
> [ 764.385523] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 764.392343] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1224 data 0x00000001
> [ 764.403615] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 764.410437] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0fe0 data 0x00000000
> [ 764.421710] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 764.428529] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0fe4 data 0x42ea0000
> [ 764.439813] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 764.446634] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0fe8 data 0x00000016
> [ 764.457910] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 764.464729] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0fec data 0x00000040
> [ 764.476002] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 764.482819] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0ff0 data 0x00000000
> [ 764.494106] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 764.500929] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1538 data 0x00000001
> [ 764.512201] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 764.519022] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1228 data 0x00000041
> [ 764.530296] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 764.537113] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x122c data 0x00000348
> [ 764.548400] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 764.555220] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1230 data 0x00010001
> [ 764.566492] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 764.573311] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x15d0 data 0x00000000
> [ 764.584584] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 764.591407] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0c00 data 0x00410000
> [ 764.602708] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 764.609528] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0c04 data 0x03480000
> [ 764.620804] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 764.627623] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0110 data 0x00000000
> [ 764.638895] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 764.645718] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0e04 data 0x00410000
> [ 764.657003] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 764.663822] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0e08 data 0x03480000
> [ 764.675095] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 764.681916] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0d90 data 0x3f800000
> [ 764.693320] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 764.700140] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x19d0 data 0x00000001
> [ 764.711423] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 764.718242] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x12e4 data 0x00000000
> [ 764.729522] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 764.736340] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0f90 data 0x00000001
> [ 764.747612] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 764.754435] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x135c data 0x00000001
> [ 764.765709] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 764.772529] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1360 data 0x00000000
> [ 764.783803] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 764.790621] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x19c4 data 0x00000000
> [ 764.801894] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 764.808715] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1a00 data 0x00001111
> [ 764.819989] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 764.826806] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x153c data 0x00000000
> [ 764.838092] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 764.844913] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x12d4 data 0x00001d01
> [ 764.856186] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 764.863006] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1684 data 0x00000001
> [ 764.874279] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 764.881099] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1688 data 0x00000000
> [ 764.892385] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 764.899206] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x13a8 data 0x11111111
> [ 764.910482] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 764.917304] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1534 data 0x00000000
> [ 764.928578] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 764.935404] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x13b0 data 0x3f800000
> [ 764.946691] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 764.953510] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1570 data 0x00000000
> [ 764.964782] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 764.971601] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x166c data 0x00000000
> [ 764.982873] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 764.989691] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1518 data 0x3f800000
> [ 765.000976] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 765.007798] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1520 data 0x00000000
> [ 765.019073] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 765.025893] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1658 data 0x00000000
> [ 765.037167] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 765.043990] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0dac data 0x00001b02
> [ 765.055277] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 765.062096] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0db0 data 0x00001b02
> [ 765.073368] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 765.080186] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0db4 data 0x00000000
> [ 765.091459] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 765.098280] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1918 data 0x00000000
> [ 765.109550] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 765.116373] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x191c data 0x00000900
> [ 765.127644] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 765.134466] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1920 data 0x00000405
> [ 765.145739] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 765.152558] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x168c data 0x00000000
> [ 765.163844] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 765.170660] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0dc0 data 0x00000000
> [ 765.181933] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 765.188756] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0dc4 data 0x00000000
> [ 765.200029] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 765.206848] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0dc8 data 0x00000000
> [ 765.218120] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 765.224939] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x193c data 0x00000000
> [ 765.236211] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 765.243032] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0e04 data 0x00410000
> [ 765.254306] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 765.261127] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0e08 data 0x03480000
> [ 765.272410] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 765.279231] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0a0c data 0x42020000
> [ 765.290503] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 765.297325] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0a10 data 0x43d20000
> [ 765.308598] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 765.315418] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0a14 data 0x3f000000
> [ 765.326688] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 765.333510] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0a00 data 0x42020000
> [ 765.344784] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 765.351605] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0a04 data 0x43d20000
> [ 765.362879] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 765.369697] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0a08 data 0x3f000000
> [ 765.380981] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 765.387800] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0c08 data 0x00000000
> [ 765.399075] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 765.405896] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x0c0c data 0x3f800000
> [ 765.417168] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 765.423992] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1650 data 0x000000ff
> [ 765.435265] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 765.442086] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x1654 data 0x00000000
> [ 765.453359] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 765.460178] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x16b8 data 0x00000008
> [ 765.471449] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 765.478271] nouveau E[ PGRAPH][0000:01:00.0] ch 2 [0x001fb34000
> Xorg[2933]] subc 5 class 0x0000 mthd 0x16b0 data 0x00000004
> [ 765.489487] nouveau E[ PFB][0000:01:00.0] trapped write at
> 0x0000000000 on channel 0x0001fac8 [Xorg[2933]] PGRAPH/DISPATCH/GRCTX
> reason: DMAOBJ_LIMIT
> [ 765.503350] nouveau E[ PGRAPH][0000:01:00.0] TRAP_DISPATCH (unknown
> 0x00000004)
> [ 765.510741] nouveau E[ PGRAPH][0000:01:00.0] ILLEGAL_MTHD ILLEGAL_CLASS
> [ 765.517558] nouveau E[ PGRAPH][0000:01:00.0] ch 3 [0x001fac8000
> Xorg[2933]] subc 0 class 0x0030 mthd 0x0000 data 0x00000000



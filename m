Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756704Ab3CNN4D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 09:56:03 -0400
Received: from mercuryimc.plus.com ([80.229.200.144]:50065 "EHLO
	centos1.newflow.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755858Ab3CNN4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 09:56:01 -0400
Message-ID: <5141D6EF.1090500@mimc.co.uk>
Date: Thu, 14 Mar 2013 13:55:59 +0000
From: Mark Jackson <mpfj-list@mimc.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: dedekind1@gmail.com
CC: "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, adrian.hunter@intel.com
Subject: Re: MTD : Kernel oops when remounting ubifs as read/write
References: <5134CEF9.5070502@mimc.co.uk>  <1363087506.3348.62.camel@sauron.fi.intel.com>  <51405F3A.3090901@mimc.co.uk>  <1363252425.11441.94.camel@sauron.fi.intel.com>  <51419E3A.8030007@mimc.co.uk>  <1363257009.11441.97.camel@sauron.fi.intel.com>  <5141B154.6050504@mimc.co.uk>  <1363260202.11441.108.camel@sauron.fi.intel.com>  <5141BC63.6060501@mimc.co.uk>  <1363263529.11441.109.camel@sauron.fi.intel.com> <1363263812.11441.112.camel@sauron.fi.intel.com> <5141D351.8060901@mimc.co.uk>
In-Reply-To: <5141D351.8060901@mimc.co.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/03/13 13:40, Mark Jackson wrote:
> On 14/03/13 12:23, Artem Bityutskiy wrote:
>> On Thu, 2013-03-14 at 14:18 +0200, Artem Bityutskiy wrote:
>>>> Is this size larger than the allocated buffer ?
>>>
>>> I believe so.
>>
>> Err, I mean, the buffer is large enough. I do not believe there is a
>> stupid bug like too small buffer. This code has worked for years and I
>> do not think it was changes much.
>>
>> The oops may be cause by memory corruption - some of your drivers may
>> corrupt memory. You need to spend more time debugging this carefully.
> 
> It can handle 64k, but not 122880 bytes ...
> 
> # mount -o remount,rw /
> [   19.208302] UBIFS: start fixing up free space
> [   19.235881] uealc crc32 : d08cb000 2048
> [   19.240015] uealc crc32 : d08cb000 4096
> [   19.244091] uealc crc32 : d08cb000 8192
> [   19.248184] uealc crc32 : d08cb000 16384
> [   19.252448] uealc crc32 : d08cb000 32768
> [   19.256772] uealc crc32 : d08cb000 65536
> [   19.260133] uealc crc32 : d08cb000 122880
> [   19.261117] Unable to handle kernel paging request at virtual address e79381bc

Unless I test in finer increments, in which case it seems to work !?!

# mount -o remount,rw /
[   25.161875] UBIFS: start fixing up free space
[   25.189572] uealc crc32 : d08cb000 1024
[   25.193653] uealc crc32 : d08cb000 2048
[   25.197709] uealc crc32 : d08cb000 3072
[   25.201819] uealc crc32 : d08cb000 4096
[   25.205886] uealc crc32 : d08cb000 5120
[   25.209982] uealc crc32 : d08cb000 6144
[   25.214054] uealc crc32 : d08cb000 7168
[   25.218129] uealc crc32 : d08cb000 8192
[   25.222238] uealc crc32 : d08cb000 9216
[   25.226323] uealc crc32 : d08cb000 10240
[   25.230528] uealc crc32 : d08cb000 11264
[   25.234711] uealc crc32 : d08cb000 12288
[   25.238928] uealc crc32 : d08cb000 13312
[   25.243119] uealc crc32 : d08cb000 14336
[   25.247313] uealc crc32 : d08cb000 15360
[   25.251541] uealc crc32 : d08cb000 16384
[   25.255744] uealc crc32 : d08cb000 17408
[   25.259982] uealc crc32 : d08cb000 18432
[   25.264193] uealc crc32 : d08cb000 19456
[   25.268406] uealc crc32 : d08cb000 20480
[   25.272657] uealc crc32 : d08cb000 21504
[   25.276881] uealc crc32 : d08cb000 22528
[   25.281136] uealc crc32 : d08cb000 23552
[   25.285367] uealc crc32 : d08cb000 24576
[   25.289633] uealc crc32 : d08cb000 25600
[   25.293873] uealc crc32 : d08cb000 26624
[   25.298115] uealc crc32 : d08cb000 27648
[   25.302394] uealc crc32 : d08cb000 28672
[   25.306644] uealc crc32 : d08cb000 29696
[   25.310928] uealc crc32 : d08cb000 30720
[   25.315188] uealc crc32 : d08cb000 31744
[   25.319485] uealc crc32 : d08cb000 32768
[   25.323753] uealc crc32 : d08cb000 33792
[   25.328025] uealc crc32 : d08cb000 34816
[   25.332331] uealc crc32 : d08cb000 35840
[   25.336612] uealc crc32 : d08cb000 36864
[   25.340924] uealc crc32 : d08cb000 37888
[   25.345212] uealc crc32 : d08cb000 38912
[   25.349538] uealc crc32 : d08cb000 39936
[   25.353837] uealc crc32 : d08cb000 40960
[   25.358138] uealc crc32 : d08cb000 41984
[   25.362481] uealc crc32 : d08cb000 43008
[   25.366794] uealc crc32 : d08cb000 44032
[   25.371140] uealc crc32 : d08cb000 45056
[   25.375462] uealc crc32 : d08cb000 46080
[   25.379823] uealc crc32 : d08cb000 47104
[   25.384155] uealc crc32 : d08cb000 48128
[   25.388490] uealc crc32 : d08cb000 49152
[   25.392862] uealc crc32 : d08cb000 50176
[   25.397207] uealc crc32 : d08cb000 51200
[   25.401583] uealc crc32 : d08cb000 52224
[   25.405936] uealc crc32 : d08cb000 53248
[   25.410326] uealc crc32 : d08cb000 54272
[   25.414688] uealc crc32 : d08cb000 55296
[   25.419084] uealc crc32 : d08cb000 56320
[   25.423455] uealc crc32 : d08cb000 57344
[   25.427827] uealc crc32 : d08cb000 58368
[   25.432238] uealc crc32 : d08cb000 59392
[   25.436621] uealc crc32 : d08cb000 60416
[   25.441033] uealc crc32 : d08cb000 61440
[   25.445423] uealc crc32 : d08cb000 62464
[   25.449852] uealc crc32 : d08cb000 63488
[   25.454254] uealc crc32 : d08cb000 64512
[   25.458658] uealc crc32 : d08cb000 65536
[   25.463097] uealc crc32 : d08cb000 66560
[   25.467508] uealc crc32 : d08cb000 67584
[   25.471953] uealc crc32 : d08cb000 68608
[   25.476372] uealc crc32 : d08cb000 69632
[   25.480823] uealc crc32 : d08cb000 70656
[   25.485251] uealc crc32 : d08cb000 71680
[   25.489712] uealc crc32 : d08cb000 72704
[   25.494147] uealc crc32 : d08cb000 73728
[   25.498584] uealc crc32 : d08cb000 74752
[   25.503058] uealc crc32 : d08cb000 75776
[   25.507505] uealc crc32 : d08cb000 76800
[   25.511988] uealc crc32 : d08cb000 77824
[   25.516443] uealc crc32 : d08cb000 78848
[   25.520935] uealc crc32 : d08cb000 79872
[   25.525399] uealc crc32 : d08cb000 80896
[   25.529899] uealc crc32 : d08cb000 81920
[   25.534369] uealc crc32 : d08cb000 82944
[   25.538876] uealc crc32 : d08cb000 83968
[   25.543359] uealc crc32 : d08cb000 84992
[   25.547844] uealc crc32 : d08cb000 86016
[   25.552366] uealc crc32 : d08cb000 87040
[   25.556859] uealc crc32 : d08cb000 88064
[   25.561383] uealc crc32 : d08cb000 89088
[   25.565885] uealc crc32 : d08cb000 90112
[   25.570423] uealc crc32 : d08cb000 91136
[   25.574935] uealc crc32 : d08cb000 92160
[   25.579479] uealc crc32 : d08cb000 93184
[   25.583997] uealc crc32 : d08cb000 94208
[   25.588517] uealc crc32 : d08cb000 95232
[   25.593115] uealc crc32 : d08cb000 96256
[   25.597648] uealc crc32 : d08cb000 97280
[   25.602226] uealc crc32 : d08cb000 98304
[   25.606766] uealc crc32 : d08cb000 99328
[   25.611340] uealc crc32 : d08cb000 100352
[   25.615978] uealc crc32 : d08cb000 101376
[   25.620652] uealc crc32 : d08cb000 102400
[   25.625300] uealc crc32 : d08cb000 103424
[   25.629984] uealc crc32 : d08cb000 104448
[   25.634637] uealc crc32 : d08cb000 105472
[   25.639325] uealc crc32 : d08cb000 106496
[   25.643988] uealc crc32 : d08cb000 107520
[   25.648650] uealc crc32 : d08cb000 108544
[   25.653370] uealc crc32 : d08cb000 109568
[   25.658047] uealc crc32 : d08cb000 110592
[   25.662764] uealc crc32 : d08cb000 111616
[   25.667449] uealc crc32 : d08cb000 112640
[   25.672168] uealc crc32 : d08cb000 113664
[   25.676858] uealc crc32 : d08cb000 114688
[   25.681581] uealc crc32 : d08cb000 115712
[   25.686276] uealc crc32 : d08cb000 116736
[   25.691010] uealc crc32 : d08cb000 117760
[   25.695717] uealc crc32 : d08cb000 118784
[   25.700462] uealc crc32 : d08cb000 119808
[   25.705177] uealc crc32 : d08cb000 120832
[   25.709929] uealc crc32 : d08cb000 121856
[   25.714654] uealc crc32 : d08cb000 122880
[   25.719414] uealc crc x
[   27.527375] UBIFS: free space fixup complete
[   27.550760] UBIFS: background thread "ubifs_bgt0_0" started, PID 660


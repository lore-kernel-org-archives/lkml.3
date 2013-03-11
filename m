Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301Ab3CKXAz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 19:00:55 -0400
Received: from smtp6-g21.free.fr ([212.27.42.6]:40387 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753839Ab3CKXAy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 19:00:54 -0400
Message-ID: <513E6217.2020309@free.fr>
Date: Tue, 12 Mar 2013 00:00:39 +0100
From: Martin Peres <martin.peres@free.fr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: airlied@linux.ie, bskeggs@redhat.com, marcin.slusarz@gmail.com,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: nouveau shuts the machine down with v3.9-rc1 (temperature (72
 C) hit the 'shutdown' threshold).
References: <20130304184022.GA8222@phenom.dumpdata.com> <5134F44C.7040700@free.fr> <20130304214110.GA17402@phenom.dumpdata.com> <5135D375.9060006@free.fr> <20130305154404.GA15271@phenom.dumpdata.com> <20130311123835.GA23154@phenom.dumpdata.com>
In-Reply-To: <20130311123835.GA23154@phenom.dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/03/2013 13:38, Konrad Rzeszutek Wilk wrote:
>> With that I am still getting the issues (even with an insance delay of 100 seconds).
>> Here is the serial log with various runs.
> Any thoughts?
Sorry for taking so long to answer but I got a one-week flu and still 
had to do my research duties :s

Anyway, as a matter of fact, I do have some thoughts. If you don't mind, 
the tests I would like you to make will be listed at the end of the message.
>> [   13.523878] initcall init_sg+0x0/0x1000 [sg] returned 0 after 5355 usecs
>> ^G^G[   13.621376] nouveau  [  PTHERM][0000:00:0d.0] programmed thresholds [ 90(2), 95(3), 145(2), 135(5) ]
>> [   13.630487] nouveau 39079] nouveau  [  PTHERM][0000:00:0d.0] Thermal management: automatic
>> [   13.646028] nouveau  [  PTHERM][0000:00:0d.0] temperature (218 C) hit the 'downclock' threshold
>> [   13.654702] nouveau  [  PTHERM][0000:00:0d.0] temperature (218 C) hit the 'critical' threshold
>> [   13.663296] nouveau  [  PTHERM][0000:00:0d.0] temperature (218 C) hit the 'shutdown' threshold
>> [   13.671992] [TTM] Zone  kernel: Available graphics memory: 1963774 kiB
> Perhaps I've some insanely stupid BIOS?

So, first of all, I indeed would like to see your vbios and I also would 
like to know the bitfield of some regs.

The easiest way to do both is to grab and compile the envytools[0].

To grab your vbios, please do the following:
nvagetbios > nv4c_vbios.rom

To get the bitfield of the thermal-related regs:
nvascan 15b0 10 > nv4c_therm_scan

Please send me both of these files and I'll see what I can do.

Sorry again for the very late answer (I'm slowly getting better).

Martin

[0] https://github.com/pathscale/envytools

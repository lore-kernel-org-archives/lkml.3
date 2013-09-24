Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687Ab3IXXfR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 19:35:17 -0400
Received: from co9ehsobe003.messaging.microsoft.com ([207.46.163.26]:46255
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754169Ab3IXXfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 19:35:15 -0400
X-Forefront-Antispam-Report: CIP:165.204.84.222;KIP:(null);UIP:(null);IPV:NLI;H:atltwp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -7
X-BigFish: VPS-7(zzbb2dI98dI9371I146fIc3f2I1102I1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz17326ah1de097h186068h8275dhz2dh839h93fhd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1f5fh1fe8h1ff5h209eh1155h)
X-WSS-ID: 0MTNLA0-08-DO3-02
X-M-MSG: 
Message-ID: <524221A5.9070808@amd.com>
Date: Tue, 24 Sep 2013 18:35:01 -0500
From: Sherry Hurwitz <sherry.hurwitz@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Jacob Shin <jacob.shin@amd.com>,
        Andreas Herrmann <herrmann.der.user@googlemail.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: Issues with AMD microcode updates
References: <20130919145834.GA4298@khazad-dum.debian.net> <20130919164409.GA9427@pd.tnic>
In-Reply-To: <20130919164409.GA9427@pd.tnic>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2013 11:44 AM, Borislav Petkov wrote:
> On Thu, Sep 19, 2013 at 11:58:34AM -0300, Henrique de Moraes Holschuh wrote:
>> Jacob, Andreas,
>>
>> I take care of the amd64 microcode update support for Debian, and I'm
>> receiving user reports of lockup issues with the AMD microcode driver in
>> several kernels.  This is about the runtime update interface,
>> /sys/devices/system/cpu/*/microcode/reload and
>> /sys/devices/system/cpu/microcode/reload.
>>
>> Basically, the issue is that the process that tries to write "1" to the
>> reload node gets stuck in "D" state on several kernel versions.
>>
>> I started by blacklisting several older kernels (e.g. I got a report of
>> 2.6.38 locking up), but recently I got a report of a lockup with kernel
>> 3.5.1.  Blacklisting everything before 3.10 is not exactly kosher, not when
>> I would have to blindly trust 3.0, 3.2 and 3.4 to not have whatever issue is
>> causing the lockups.
>>
>> IMHO that's the point where it becomes interesting to actually track down
>> the bug even if it apparently doesn't exist anymore on the more recent
>> kernels, and ensure that the stable/long-term kernels have the fix.  That
>> would also help distros blacklist microcode update on the broken kernels.
>>
>> Unfortunately, I don't own, or have access to, any boxes with an AMD
>> processor (let alone one with an AMD processor in need of a microcode
>> update) to bissect the problem.
>>
>> I'd appreciate if AMD (or anyone with an AMD processor, really) could help
>> me track this issue down.
>>
>> Debian bug reports:
>> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=717185
>> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=723081
> Well, both Andreas and Jacob don't work for AMD anymore. I could try to
> help with this but it'll be slow as I'm pretty busy with other stuff.
>
> Anyway, I'd suggest we look only on the long term kernels since they're
> the only ones which can get updates/fixes anyway.
>
> Now, how do I reproduce this? Writing 1 to .../reload on latest kernel
> works here. So I'd need a reproducer. Alternatively, I'd need a sysrq-l
> and sysrq-w from those systems with hung processes.
>
> Thanks.
>
You can direct AMD microcode issues to me now.
We are setting up some systems in the lab and trying to duplicate
the problem now.

Thanks.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752962AbaBCPOG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 10:14:06 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:56614
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750967AbaBCPOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 10:14:03 -0500
X-Forefront-Antispam-Report: CIP:62.221.5.235;KIP:(null);UIP:(null);IPV:NLI;H:xir-gw1;RD:unknown-62-221-5-235.ipspace.xilinx.com;EFVD:NLI
X-SpamScore: 1
X-BigFish: VPS1(zzbb2dI98dI9371I1432I4015Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzzz2fh95h839h947hc61hd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h190ch1946h19b4h19b5h19c3h1b0ah1be0h224fh1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h2336h2438h2461h2487h24d7h2516h19b6n1155h)
Date: Mon, 3 Feb 2014 16:13:47 +0100
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-arm-kernel@lists.infradead.org>,
        Michal Simek <michal.simek@xilinx.com>, <linux-kernel@vger.kernel.org>,
        <monstr@monstr.eu>, Mark Rutland <mark.rutland@arm.com>,
        <devicetree@vger.kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        <linux-doc@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Rob Landley <rob@landley.net>, Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCH 09/10] watchdog: xilinx: Add missing binding
References: <ed4cb31c9a549343e6b492cf62fc962d39034bd0.1391177880.git.michal.simek@xilinx.com> <9c721b89ed2ceb6997809bb3363f852277e67dc2.1391177880.git.michal.simek@xilinx.com> <201402031606.11753.arnd@arndb.de>
In-Reply-To: <201402031606.11753.arnd@arndb.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
X-RCIS-Action: ALLOW
Message-ID: <24ecacca-2714-4834-921c-b827c0e592a3@VA3EHSMHS003.ehs.local>
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/2014 04:06 PM, Arnd Bergmann wrote:
> On Friday 31 January 2014, Michal Simek wrote:
>> +Optional properties:
>> +- clock-frequency      : Frequency of clock in Hz
>> +- xlnx,wdt-enable-once : 0 - Watchdog can be restarted
>> +                         1 - Watchdog can be enabled just once
>> +- xlnx,wdt-interval    : Watchdog timeout interval in 2^<val> clock cycles,
>> +                         <val> is integer from 8 to 31.
>> +
> 
> The latter two don't really seem to be xilinx specific, it would be
> reasonable to have a standard watchdog binding that mandates a common
> format for them.
> 
> I'm not sure about the enable-once flag, which seems to just map to the
> "nowayout" watchdog option that is not a hardware feature at all
> and should probably be kept as a software setting only, rather than
> settable through DT. If it is kept, it should have a standard name and
> get turned into a boolean (present/absent) property rather than a
> 0/1 integer property.
> 
> The interval should really be specified in terms of seconds or miliseconds,
> not in clock cycles.

Intention wasn't to fix binding but document current one
which is in mainline for a long time.

Apart of this - yes, wdt-enable-once is nowayout and wdt-interval should be timeout
is seconds, and clock-frequency should go out and use CCF for getting clock.

Thanks,
Michal



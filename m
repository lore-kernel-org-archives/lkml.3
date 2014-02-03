Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179AbaBCPsR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 10:48:17 -0500
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:34913
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752603AbaBCPsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 10:48:15 -0500
X-Forefront-Antispam-Report: CIP:62.221.5.235;KIP:(null);UIP:(null);IPV:NLI;H:xir-gw1;RD:unknown-62-221-5-235.ipspace.xilinx.com;EFVD:NLI
X-SpamScore: 4
X-BigFish: VPS4(zzbb2dI98dI9371I1432I4015I853kzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzzz2fh95h839h947hc61hd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h190ch1946h19b4h19b5h19c3h1b0ah1be0h224fh1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h2336h2438h2461h2487h24ach24d7h2516h19b6n1155h)
Date: Mon, 3 Feb 2014 16:47:55 +0100
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Michal Simek <michal.simek@xilinx.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <monstr@monstr.eu>, Mark Rutland <mark.rutland@arm.com>,
        <devicetree@vger.kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        <linux-doc@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Rob Landley <rob@landley.net>, Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCH 09/10] watchdog: xilinx: Add missing binding
References: <ed4cb31c9a549343e6b492cf62fc962d39034bd0.1391177880.git.michal.simek@xilinx.com> <201402031606.11753.arnd@arndb.de> <24ecacca-2714-4834-921c-b827c0e592a3@VA3EHSMHS003.ehs.local> <3121595.GbLMuGPlvA@wuerfel>
In-Reply-To: <3121595.GbLMuGPlvA@wuerfel>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-RCIS-Action: ALLOW
Message-ID: <4c4539fe-e810-4c0a-9a01-c1e4c67ea661@AM1EHSMHS007.ehs.local>
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/2014 04:32 PM, Arnd Bergmann wrote:
> On Monday 03 February 2014 16:13:47 Michal Simek wrote:
>> Intention wasn't to fix binding but document current one
>> which is in mainline for a long time.
> 
> Ok, I see.
> 
>> Apart of this - yes, wdt-enable-once is nowayout and wdt-interval should be timeout
>> is seconds, and clock-frequency should go out and use CCF for getting clock.
> 
> Could we make a common binding then, and document that the xilinx
> watchdog can optionally provide either one?

Do you mean to have 2 DT bindings?

This binding is used from 2011-07.
It means it was generated for all hw designs at least from this time.
I would say from DT usage on Microblaze because it is not special case
in our dt generator.

xlnx,XXX are XXX parameters which you have to setup in tools
and get synthesized. This is valid for all xilinx IPs. We have full
IP description by generating xlnx,XXX parameters directly from tools
because we know all variants which can happen.

Just back to your previous post:
"I'm not sure about the enable-once flag, which seems to just map to the
"nowayout" watchdog option that is not a hardware feature at all"
this is hw feature which you can select in tools because this is fpga. :-)

Thanks,
Michal



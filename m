Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759900AbaGYJrN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 05:47:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36764 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751221AbaGYJrL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 05:47:11 -0400
Message-ID: <53D22799.8050903@suse.de>
Date: Fri, 25 Jul 2014 11:47:05 +0200
From: =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: =?UTF-8?B?U8O2cmVuIEJyaW5rbWFubg==?= <soren.brinkmann@xilinx.com>
CC: Michal Simek <michal.simek@xilinx.com>,
        Andreas Olofsson <andreas@adapteva.com>,
        Matteo Vit <matteo.vit@starwaredesign.com>,
        Sean Rickerd <srickerd@suse.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH v2 08/11] ARM: dts: zynq: Add VDMA to Parallella
References: <1406242820-20140-1-git-send-email-afaerber@suse.de> <1406242820-20140-9-git-send-email-afaerber@suse.de> <b4c4e060-2efb-4b82-be12-32c00897ec93@BY2FFO11FD023.protection.gbl>
In-Reply-To: <b4c4e060-2efb-4b82-be12-32c00897ec93@BY2FFO11FD023.protection.gbl>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sören,

Am 25.07.2014 01:22, schrieb Sören Brinkmann:
> On Fri, 2014-07-25 at 01:00AM +0200, Andreas Färber wrote:
>> Signed-off-by: Andreas Färber <afaerber@suse.de>
>> ---
>>  v2: New
>>  
>>  arch/arm/boot/dts/zynq-parallella.dts | 25 +++++++++++++++++++++++++
>>  1 file changed, 25 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/zynq-parallella.dts b/arch/arm/boot/dts/zynq-parallella.dts
>> index e60a0a9..8beaacc 100644
>> --- a/arch/arm/boot/dts/zynq-parallella.dts
>> +++ b/arch/arm/boot/dts/zynq-parallella.dts
>> @@ -32,6 +32,31 @@
>>  		bootargs = "console=ttyPS0,115200 earlyprintk root=/dev/mmcblk0p2 rootfstype=ext4 rw rootwait";
>>  		linux,stdout-path = "/amba/serial@e0001000";
>>  	};
>> +
>> +	fpga {
> Do you really want FPGA components in this DT?
> If somebody tries booting with this DT without programming with a
> corresponding bitstream, the whole system might hang.
> Just something to consider.

Well, that's related to a question that remained unanswered on v1:
whether we may need to turn this into a .dtsi to cope with variations.

The Parallella has an on-board µHDMI connector, and two bitstreams are
delivered - one for HDMI and one for headless usage. In my testing I am
using the original HDMI bitstream but serial console for lack of
upstream HDMI drivers. Do you think we need to provide
zynq-parallella-hdmi.dts and zynq-parallella-headless.dts? (It gets
worse if at some point we need to handle variations of the on-board
Epiphany chip plus the bitstreams - at least the Z7010 vs. Z7020 doesn't
affect DT AFAICT.)

Since, as noted in the cover letter, these FPGA patches are not yet
fully testable, I wouldn't mind deferring them, but wanted to get them
out for review early.

http://www.parallella.org/2014/07/14/new-parallella-product-offerings/
indicates there will be a new variation in gen2 without USB/HDMI. Would
it be valid to #include a .dts (rather than .dtsi) to override status
and keep number of Parallella files low?

Regards,
Andreas

-- 
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer; HRB 16746 AG Nürnberg

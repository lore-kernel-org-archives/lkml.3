Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750819Ab3GKEAM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 00:00:12 -0400
Received: from mail-db8lp0189.outbound.messaging.microsoft.com ([213.199.154.189]:34367
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750704Ab3GKEAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 00:00:10 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zzbb2dI98dI9371I1432Izz1f42h1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2dh2a8h668h839h947hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h190ch1946h19b4h19c3h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1155h)
Message-ID: <51DE2DB5.60608@freescale.com>
Date: Thu, 11 Jul 2013 09:29:49 +0530
From: Akhil Goyal <akhil.goyal@freescale.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.26) Gecko/20120129 Thunderbird/3.1.18
MIME-Version: 1.0
To: <gregkh@linuxfoundation.org>, <arnd@arndb.de>
CC: <akhil.goyal@freescale.com>, <lars@metafoo.de>, <robin.getz@analog.com>,
        <Michael.Hennerich@analog.com>, <lars-peter.clausen@analog.com>,
        <linux-kernel@vger.kernel.org>, <pankaj.chauhan@freescale.com>
Subject: Re: [PATCH v2 0/4] Radio device framework
References: <1373277002-14009-1-git-send-email-akhil.goyal@freescale.com>
In-Reply-To: <1373277002-14009-1-git-send-email-akhil.goyal@freescale.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/8/2013 3:19 PM, akhil.goyal@freescale.com wrote:
> From: Akhil Goyal<akhil.goyal@freescale.com>
>
> RF signal path is integral part of any system that transmits/receives RF
> (radio frequency) signals. In these systems Data is processed/converted
> to IQ samples (digital representation a RF signal) and passed to a RFIC
> (RF PHY) which converts the digital RF signal (IQ samples) to analog and
> transmits over antenna.
>
> Typically The signal path consists of multiple components:
>
> Antenna controller<->  vector signal processors<->  RFIC<->  Antenna
>
> Each of these components have specific functionalities:
>
> 1. Antenna controller: Framing of digital IQ data into protocol specific frames.
> 2. vector signal processors: For conditioning of signal.
> 3. RFIC : converts digital IQ data to analog signal which is transmitted/received on/from Air.
>
> Also it is desirable to control the complete signal path, for example:
> bringing the complete signal path up/down etc.
>
> The radio device framework introduces a way to accommodate the RF signal
> paths.  One signal path is represented as a RF device (rf0, rf1 etc), and
> it can contain multiple components which have their individual vendor
> specific drivers. The framework provides mechanism by which individual
> components can register with RF framework, and the framework will handle the binding
> of individual component devices to a RF device. RF device exports the control
> interfaces to user space, and this user space interface is independent of
> component (vendor specific) drivers.
>
> This patch set include
> 1. RF Interface: Independent of phy or antenna controller.
> 2. AIC driver: Antenna interface Controller(AIC) of Hetrogenous SOC's
> like BSC9131, BSC9132
> 4. Device tree bindings for AIC.
> 5. Device tree changes for BSC9131-AIC
>
> changes in v2:
> 1. incorporated comments for handling pointers in user space API structures.
> 2. Removed patches for AD9361 phy driver. It shall be sent once a proper
> driver is in place for AD9361 chip
> 3. Removed Device tree nodes/bindings for AD9361
> 4. Incorporated comments for proper handling of wait_events
> 5. Added Documentation for IOCTL APIs and the structures used.
> 6. Inserted paddings in user space structures.
> 7. Reorganized code for rfdev.c to remove forward declaration and broke the
> rf_ioctl() function to handle local structures correctly.
> 8. Corrected the error handling for mutex used.
>

Hi Arnd/Greg,

It has been 3-4 days for this patch set and there are no review comments 
on these patches. Please suggest a way forward for the patch set. I have 
incorporated all the review comments for v1.

-Akhil



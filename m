Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756298AbaGCMz3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 08:55:29 -0400
Received: from mo4-p05-ob.smtp.rzone.de ([81.169.146.183]:60417 "EHLO
	mo4-p05-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756013AbaGCMz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 08:55:28 -0400
X-Greylist: delayed 371 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Jul 2014 08:55:28 EDT
X-RZG-AUTH: :IW0NeWC7b/q2i6W/qstXb1SBUuFnrGoheedClaTaNdBkW0QEOcx1Ft+DpaWf0qqN8/jSv6Kcuc3PZrnFbUtY5gcAIXMk1wD4hL5m
X-RZG-CLASS-ID: mo05
Message-ID: <53B5514E.5050504@denx.de>
Date: Thu, 03 Jul 2014 14:49:18 +0200
From: Stefan Roese <sr@denx.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Jean-Michel Hautbois <jhautbois@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Lattice ECP3 FPGA with i.MX6
References: <CAL8zT=gW-OCeeOhKZzqgVSxDE5gsWt2O9nQ9mt7diDZQvvRO=w@mail.gmail.com>
In-Reply-To: <CAL8zT=gW-OCeeOhKZzqgVSxDE5gsWt2O9nQ9mt7diDZQvvRO=w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03.07.2014 14:37, Jean-Michel Hautbois wrote:
> I have a board, with a Freescale i.MX6 chip and a ECP3-35 FPGA on SPI.
> I tried to load the firmware using the lattice-ecp3-config driver, but
> it fails with this error :
>
> lattice-ecp3 spi32766.3: FPGA bitstream configuration driver registered
> lattice-ecp3 spi32766.3: Error: No supported FPGA detected (JEDEC_ID=808004c2)!
>
> In the driver, the id is :
>
> #define ID_ECP3_35 0xc2048080
>
> Obviously, there is a big/little endian issue... Do I need to instruct
> the device-tree in a specific way in order to get the bus in the
> correct order ? Or is this a known issue maybe ?

No. This driver was implemented and tested in a MPC5200 system. Most 
likely I missed some endian issues as you already noticed. I suggest you 
start with looking at this line:

	jedec_id = *(u32 *)&rxbuf[4];

And add some endian functions here, e.g. be32_to_cpu(). This might help 
with the detection. But other endian related issues might still be 
present in other parts of the driver as well.

HTP.

Thanks,
Stefan


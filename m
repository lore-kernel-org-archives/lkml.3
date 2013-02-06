Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638Ab3BFNdT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 08:33:19 -0500
Received: from multi.imgtec.com ([194.200.65.239]:18340 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751335Ab3BFNdS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 08:33:18 -0500
Message-ID: <51125B56.9050407@imgtec.com>
Date: Wed, 6 Feb 2013 13:32:06 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: linux-next <linux-next@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Heads up on a device tree change
References: <CACxGe6sCBCGfLDAGVRgP3cnmE+oyXBDdPeVXVCqrsvCh13yPiw@mail.gmail.com>
In-Reply-To: <CACxGe6sCBCGfLDAGVRgP3cnmE+oyXBDdPeVXVCqrsvCh13yPiw@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2013_02_06_13_33_14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02/13 13:11, Grant Likely wrote:
> Hi Stephen,
> 
> I've just pushed out a change which cleans up platform device
> registration to use the same path whether or not the device tree is
> used. It should be safe, but there is a risk of breakage on powerpc
> platforms.
> 
> The patch has two effects of note:
> - DT generated platform devices move from /sys/devices to under
> /sys/devices/platform. Userspace *should* be okay with this, but if
> there are any problems then I can post a workaround patch that keeps
> DT generiated platform_devices in the current location.
> - Resources on platform_devices get registered so they appear in
> /proc/iomem and /proc/ioports and so that device drivers get the added
> protection of request_region. This will cause breakage on device trees
> nodes with partially overlapping memory regions. (ie. 0x100..0x1ff and
> 0x180..0x27f). I also have a workaround for this, but I doubt that it
> will be necessary.

Hi Grant,

If I understand you correctly, the non-overlapping memory regions thing
could be a problem for me. We have a Meta based SoC that has various SoC
registers grouped together for doing GPIOs and Pin control things. I'm
still in the process of converting it to device tree, but the way I've
been handling it is to provide overlapping registers to both the gpio
and pinctl DT nodes. Each GPIO bank's registers are also interleaved
with the others, so I've been providing overlapping register ranges
(offset by 4 for each bank) to the DT node for each gpio bank too, so
each bank can function independently and the driver doesn't have to
worry about multiple banks. Does that sound like a reasonable use case?

I guess I could cheat with the length, or specify each register in it's
own memory resource, but it seems like overkill.

Cheers
James


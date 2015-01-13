Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751501AbbAMHkb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 02:40:31 -0500
Received: from mail-we0-f177.google.com ([74.125.82.177]:40353 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245AbbAMHk1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 02:40:27 -0500
Subject: Re: [PATCH v8 2/4] fpga manager: add sysfs interface document
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Content-Type: text/plain; charset=utf-8
From: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
In-Reply-To: <20150113072857.GA11760@amd>
Date: Tue, 13 Jan 2015 09:40:18 +0200
Cc: Michal Simek <michal.simek@xilinx.com>,
        atull <atull@opensource.altera.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        jgunthorpe@obsidianresearch.com, hpa@zytor.com,
        Michal Simek <monstr@monstr.eu>, rdunlap@infradead.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        devicetree@vger.kernel.org, robh+dt@kernel.org,
        Grant Likely <grant.likely@linaro.org>, iws@ovro.caltech.edu,
        linux-doc@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        philip@balister.org, rubini@gnudd.com,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>, jason@lakedaemon.net,
        kyle.teske@ni.com, nico@linaro.org, Felipe Balbi <balbi@ti.com>,
        m.chehab@samsung.com, davidb@codeaurora.org,
        Rob Landley <rob@landley.net>, davem@davemloft.net, cesarb@cesarb.net,
        sameo@linux.intel.com, akpm@linux-foundation.org,
        Linus Walleij <linus.walleij@linaro.org>, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, devel@driverdev.osuosl.org,
        Alan Tull <delicious.quinoa@gmail.com>, dinguyen@opensource.altera.com,
        yvanderv@opensource.altera.com
Content-Transfer-Encoding: 8BIT
Message-Id: <D62286C4-2800-47B6-9D69-6F92E27347AF@konsulko.com>
References: <1420575219-27061-1-git-send-email-atull@opensource.altera.com> <1420575219-27061-3-git-send-email-atull@opensource.altera.com> <20150107084819.GA1887@amd> <alpine.DEB.2.02.1501091302370.30067@linuxheads99> <20150109205643.GA5761@amd> <4D4EA2D5-68DD-49F7-9E2D-3A0A8F6AF9CA@konsulko.com> <20150110151118.GA16036@amd> <alpine.DEB.2.10.1501111009180.2556@shineypoop> <20150112084530.GA28681@amd> <bed1d7ce1b984c79acc75a47495cb959@BL2FFO11FD043.protection.gbl> <20150113072857.GA11760@amd>
To: Pavel Machek <pavel@denx.de>
X-Mailer: Apple Mail (2.1993)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

> On Jan 13, 2015, at 09:28 , Pavel Machek <pavel@denx.de> wrote:
> 
> Hi!
> 
>>>>>>>>>> +What:		/sys/class/fpga_manager/<fpga>/firmware
>>>>>>>>>> +Date:		October 2014
>>>>>>>>>> +KernelVersion:	3.18
>>>>>>>>>> +Contact:	Alan Tull <atull@opensource.altera.com>
>>>>>>>>>> +Description:	Name of the FPGA image file to load using firmware
>>>>>>>>>> class.
>>>>>>>>> 
>>>>>>>>> This one is ugly: it unneccessarily passes firmware name through the
>>>>>>>>> kernel. Just make interface and code simpler by always passing
>>>>>>>>> "socfpga-fpga-image" or something like that.
> ...
> 
>>> What is cumbersome about symlink? Why is "fake" symlink in sysfs better?
>>> 
>>>> Previous uses of the firmware layer has been to use it to load once after
>>>> bootup; this is different since some use cases will want to switch out
>>>> the FPGA image.  If someone wants there to be only one FPGA image on
>>>> the FGPA forever, they will probably not be using this framework; their
>>>> FPGA will probably be loaded before Linux boots up.
>>> 
>>> Why? I have just one image on the fpga, and would prefer to load it
>>> from Linux.
>> 
>> Pavel: These patches target staging and sysfs interface doesn't need to be stable
>> at this time. I would prefer to add these patches to staging for 3.20
>> and feel free to send the patch which fix this.
> 
> Interesting way to address patch review. "We'll merge it, and you can
> fix it up later".
> 
>> With your code will be exactly clear how you want to use it and we can
>> talk about it.
> 
> I'm pretty sure Alan knows what I want at this point, he just does not
> want to do it.
> 
> For the record, I want to drop "firmware" file, use fixed firmware
> name, and deal with multiple firmwares in userspace (using symlink or
> udev magic).
> 

That’s completely bogus. Using a fixed firmware file does not respond to
real world usage, and there are no words to describe the hacks using
symlinks and udev in an embedded product.

> I believe this is simplest solution, should be adequate, and is
> certainly less ugly than implementing fake symlink in
> /sys/.../firmware. And I have yet to hear what is wrong with that
> suggestion.
> 

Everything.

> Thanks,									

Regards

— Pantelis

> 									Pavel
> -- 
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


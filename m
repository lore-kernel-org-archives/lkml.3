Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556AbbAUUcj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 15:32:39 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:48033 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938AbbAUUcc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 15:32:32 -0500
Subject: Re: [PATCH v8 2/4] fpga manager: add sysfs interface document
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Content-Type: text/plain; charset=utf-8
From: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
In-Reply-To: <20150121202700.GB4942@obsidianresearch.com>
Date: Wed, 21 Jan 2015 22:32:23 +0200
Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        atull <atull@opensource.altera.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pavel Machek <pavel@denx.de>, hpa@zytor.com,
        Michal Simek <monstr@monstr.eu>,
        Michal Simek <michal.simek@xilinx.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        devicetree@vger.kernel.org, robh+dt@kernel.org,
        Grant Likely <grant.likely@linaro.org>, iws@ovro.caltech.edu,
        linux-doc@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        philip@balister.org, rubini@gnudd.com,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>, jason@lakedaemon.net,
        kyle.teske@ni.com, nico@linaro.org, Felipe Balbi <balbi@ti.com>,
        m.chehab@samsung.com, davidb@codeaurora.org,
        Rob Landley <rob@landley.net>, davem@davemloft.net, cesarb@cesarb.net,
        sameo@linux.intel.com, Andrew Morton <akpm@linux-foundation.org>,
        Linus Walleij <linus.walleij@linaro.org>, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, devel@driverdev.osuosl.org,
        Alan Tull <delicious.quinoa@gmail.com>, dinguyen@opensource.altera.com,
        yvanderv@opensource.altera.com
Content-Transfer-Encoding: 8BIT
Message-Id: <7E60D554-8660-4CDB-BF68-D39DD29039BE@konsulko.com>
References: <20150113162847.2778b5a5@lxorguk.ukuu.org.uk> <20150113200032.GA16205@obsidianresearch.com> <alpine.DEB.2.02.1501131455130.30192@linuxheads99> <20150113222450.GA17475@obsidianresearch.com> <alpine.DEB.2.02.1501150936390.16760@linuxheads99> <20150115184726.GA23247@obsidianresearch.com> <20150115204502.591bca1d@lxorguk.ukuu.org.uk> <A3B5BC9B-EB88-4C0E-B235-E9C86D23DC34@konsulko.com> <20150121160151.453ba403@lxorguk.ukuu.org.uk> <D466D9FF-25DA-4765-9469-128733BEBC4D@konsulko.com> <20150121202700.GB4942@obsidianresearch.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
X-Mailer: Apple Mail (2.1993)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jason,

> On Jan 21, 2015, at 22:27 , Jason Gunthorpe <jgunthorpe@obsidianresearch.com> wrote:
> 
> On Wed, Jan 21, 2015 at 06:33:12PM +0200, Pantelis Antoniou wrote:
>> Hi Alan,
>> 
>>> On Jan 21, 2015, at 18:01 , One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk> wrote:
>>> 
>>> On Thu, 15 Jan 2015 22:54:46 +0200
>>> Pantelis Antoniou <pantelis.antoniou@konsulko.com> wrote:
>>> 
>>>> Hi Alan,
>>>> 
>>>>> On Jan 15, 2015, at 22:45 , One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk> wrote:
>>>>> 
>>>>> On Thu, 15 Jan 2015 11:47:26 -0700
>>>>> Jason Gunthorpe <jgunthorpe@obsidianresearch.com> wrote:
>>>>>> It is a novel idea, my concern would be that embedding the FPGA in the
>>>>>> DT makes it permanent unswappable kernel memory.
>>>>>> Not having the kernel hold the FPGA is best for many uses.
>>>>> 
>>>>> If you have a filesysytem before the FPGA is set up then it belongs in
>>>>> the file system. As you presumably loaded the kernel from somewhere there
>>>>> ought to be a file system (even an initrd).
>>>>> 
>>>> 
>>>> Request firmware does not imply keeping it around. You can always re-request
>>>> when reloading (although there’s a nasty big of caching that needs to be
>>>> resolved with the firmware loader).
>>> 
>>> Which comes down to the same thing. Unless you can prove that there is a
>>> path to recover the firmware file that does not have any dependancies
>>> upon the firmware executing (and those can be subtle and horrid at times)
>>> you need to keep it around for suspend/resume at least and potentially
>>> any unexpected error/reset.
>>> 
>> 
>> In that case the only safe place to put it is in the kernel image itself, which
>> is something the firmware loader already supports.
> 
> My point is that the current firmware layer is overly cautious and
> FPGAs are very big. My current project on small Xilinx device has a
> 10MB programming file. The biggest Xilinx device today has a max
> bitfile size around 122MB.
> 
> So keeping that much memory pinned in the kernel when I can prove it
> is uncessary for my system (either because there is no suspend/resume
> possibility, or because I know the CPU can always access the
> filesytem) is very undesirable.
> 
> Other systems might have to take the ram hit.
> 
> Since it seems like the kernel has no way to know, we probably have
> have a way to tell it not to cache the bitfile.
> 

The firmware loader was not originally meant to handle these cases, but
I’m sure it’s not an insurmountable obstacle.

> Jason

Regards

— Pantelis


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039AbbAUQde (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 11:33:34 -0500
Received: from mail-we0-f173.google.com ([74.125.82.173]:44823 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753758AbbAUQdW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 11:33:22 -0500
Subject: Re: [PATCH v8 2/4] fpga manager: add sysfs interface document
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Content-Type: text/plain; charset=utf-8
From: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
In-Reply-To: <20150121160151.453ba403@lxorguk.ukuu.org.uk>
Date: Wed, 21 Jan 2015 18:33:12 +0200
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
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
Message-Id: <D466D9FF-25DA-4765-9469-128733BEBC4D@konsulko.com>
References: <20150107084819.GA1887@amd> <alpine.DEB.2.02.1501091302370.30067@linuxheads99> <20150109205643.GA5761@amd> <20150112210134.687176ed@lxorguk.ukuu.org.uk> <20150112214314.GA18610@obsidianresearch.com> <20150113162847.2778b5a5@lxorguk.ukuu.org.uk> <20150113200032.GA16205@obsidianresearch.com> <alpine.DEB.2.02.1501131455130.30192@linuxheads99> <20150113222450.GA17475@obsidianresearch.com> <alpine.DEB.2.02.1501150936390.16760@linuxheads99> <20150115184726.GA23247@obsidianresearch.com> <20150115204502.591bca1d@lxorguk.ukuu.org.uk> <A3B5BC9B-EB88-4C0E-B235-E9C86D23DC34@konsulko.com> <20150121160151.453ba403@lxorguk.ukuu.org.uk>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
X-Mailer: Apple Mail (2.1993)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

> On Jan 21, 2015, at 18:01 , One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk> wrote:
> 
> On Thu, 15 Jan 2015 22:54:46 +0200
> Pantelis Antoniou <pantelis.antoniou@konsulko.com> wrote:
> 
>> Hi Alan,
>> 
>>> On Jan 15, 2015, at 22:45 , One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk> wrote:
>>> 
>>> On Thu, 15 Jan 2015 11:47:26 -0700
>>> Jason Gunthorpe <jgunthorpe@obsidianresearch.com> wrote:
>>>> It is a novel idea, my concern would be that embedding the FPGA in the
>>>> DT makes it permanent unswappable kernel memory.
>>>> Not having the kernel hold the FPGA is best for many uses.
>>> 
>>> If you have a filesysytem before the FPGA is set up then it belongs in
>>> the file system. As you presumably loaded the kernel from somewhere there
>>> ought to be a file system (even an initrd).
>>> 
>> 
>> Request firmware does not imply keeping it around. You can always re-request
>> when reloading (although there’s a nasty big of caching that needs to be
>> resolved with the firmware loader).
> 
> Which comes down to the same thing. Unless you can prove that there is a
> path to recover the firmware file that does not have any dependancies
> upon the firmware executing (and those can be subtle and horrid at times)
> you need to keep it around for suspend/resume at least and potentially
> any unexpected error/reset.
> 

In that case the only safe place to put it is in the kernel image itself, which
is something the firmware loader already supports.

>> One of the ideas rolling about is to put the device tree overlay blob in
>> an EEPROM and then load it from there (not from the filesystem).
> 
> That's a fine example of one you can probably always get to and avoid
> caching. However if its in eeprom you don't need request_firmware anyway !
> 

Sure, I never said that request_firmware is the only way to get hold of a blob.
It just happens to be the most convenient one for the kernel (when the blob
resides somewhere on a filesystem).

>> Can we please not use ioctls if possible. Configfs seems to work just fine
>> for configuration and for any other higher speed API we should use read/write/mmap.
> 
> You don't have the needed state in configfs as far as I can see.
> 

Sure, but there’s no reason for it not to be there.

>> Ioctls are a pain for scripting and interpreted languages usually.
> 
> You can do ioctls in perl just fine if you are mad (and if you are
> using perl you are ;-) ) while python has a complete explicit fcntl.ioctl
> model.
> 

Sure, it can be made to work, but it is a pain.

>> Making the API handle partial reconfiguration from day one might be pushing tricky.
>> I don’t remember any case where I came across a need for it.
> 
> Agreed - I don't see the point in adding it until someone needs it and can
> describe what is needed accurately.
> 

/me nods.

> Alan

Regards

— Pantelis


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345AbaLHUxA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 15:53:00 -0500
Received: from mail-ob0-f181.google.com ([209.85.214.181]:50356 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755232AbaLHUw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 15:52:57 -0500
Message-ID: <54860FD3.6020502@landley.net>
Date: Mon, 08 Dec 2014 14:53:39 -0600
From: Rob Landley <rob@landley.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@linaro.org>, Pavel Machek <pavel@denx.de>
CC: atull <atull@opensource.altera.com>,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Simek <monstr@monstr.eu>,
        Michal Simek <michal.simek@xilinx.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Ira Snyder <iws@ovro.caltech.edu>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>, philip@balister.org,
        rubini <rubini@gnudd.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Jason <jason@lakedaemon.net>, kyle.teske@ni.com,
        Nicolas Pitre <nico@linaro.org>, Felipe Balbi <balbi@ti.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        David Brown <davidb@codeaurora.org>,
        David Miller <davem@davemloft.net>, cesarb@cesarb.net,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alan Tull <delicious.quinoa@gmail.com>, dinguyen@opensource.altera.com,
        Yves Vandervennet <yvanderv@opensource.altera.com>
Subject: Re: [PATCH v2 2/3] fpga manager: framework core
References: <1414007405-32186-1-git-send-email-atull@opensource.altera.com>	<1414007405-32186-3-git-send-email-atull@opensource.altera.com>	<20141024105200.GA20775@amd>	<B914D894-E486-4EF1-8F84-169E939C58B4@konsulko.com>	<alpine.DEB.2.02.1410240906340.23446@atx-linux-37>	<CACxGe6tiLxbCThzjOqrQg44Ue3XJuuRgti5jZY=UrssSY8=xqg@mail.gmail.com>	<20141206135533.GA19672@amd> <20141208175050.92EDAC40D73@trevor.secretlab.ca>
In-Reply-To: <20141208175050.92EDAC40D73@trevor.secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/08/2014 11:50 AM, Grant Likely wrote:
> On Sat, 6 Dec 2014 14:55:33 +0100
> , Pavel Machek <pavel@denx.de>
>  wrote:
>> Hi!
>>
>>>> I am accustomed to doing 'echo -n' for most of sysfs anyway.  Once in a
>>>> while I am a bonehead and forget the '-n' and spend a few minutes
>>>> wondering why this thing that worked last week suddenly rejects all
>>>> commands.  I'm just trying to make my user interface a bit user-friendly.
>>>>
>>>> I will take out the '\n' stripping and update the documentation.  I didn't
>>>> realize this would be controversial.
>>>
>>> Don't. You're doing the right thing by scrubbing your input. Requiring
>>> 'echo -n' is just stupid when it is so easy to make work easily.
>>
>> 'foo\nbar\n' is unusual but valid filename in linux. It is bad idea to
>> echo filenames into files in the first place... and arbitrarily
>> disallowing certain filenames is not helping.
> 
> Meh. Just because it is a valid linux filename doesn't mean this
> interface is forced to accept it. There should be tighter rules about
> how the filename can be constructed. Allowing any arbitrary path for any
> arbitrary valid linux filename makes for a large attack surface.

"echo /bin/mdev > /proc/sys/kernel/hotplug" has worked fine, without the
-n, for most of a decade now. Requiring -n on echo would be weird.

I note that the filenames in /proc/mounts have an escape syntax for
arbitrary embedded weirdness. (To see it in action, mount a path with a
space in it.) If you really want to support that, there's presumably
code that can be genericized and reappropriated so you can escape a
newline you want to keep. But if your input has a normal unescaped
trailing newline, it _should_ be ignored.

Rob

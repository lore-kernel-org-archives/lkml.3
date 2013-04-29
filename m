Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758169Ab3D2QtL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 12:49:11 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:52034 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757127Ab3D2QtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 12:49:09 -0400
MIME-Version: 1.0
In-Reply-To: <517E9907.4030106@ti.com>
References: <1363145021-14339-1-git-send-email-s-anna@ti.com>
	<CABb+yY0RYkVeo2Sb4WsDJY0jf17488FEz0d2CB994eQaSOEsVg@mail.gmail.com>
	<37C860A02101E749A747FA2D3C1E3C504A5DF7@DLEE11.ent.ti.com>
	<CABb+yY1x4x_A+QtGG9ohsLPgs8c3nEVnd_ExJBGOOR8=6YLPFA@mail.gmail.com>
	<37C860A02101E749A747FA2D3C1E3C504A63B4@DLEE11.ent.ti.com>
	<CAJe_ZhehnniZd730jjiOLrHozq8TOJZgFYLqUe4KqgBiQEu8PA@mail.gmail.com>
	<51779304.4040003@st.com>
	<CAJe_ZhdZv5LW6kdwyPtJe69mfW6t=WQ4OJnG2H4sUhibattN2A@mail.gmail.com>
	<517867E1.7050301@ti.com>
	<CAJe_ZhfDZzq+DzA9XDF3PWFUmwcZnDy-mhE4hLNHmf+V4GhOxw@mail.gmail.com>
	<5179AE2F.3040403@ti.com>
	<CAJe_Zhf4miUm4yTyuwc56kpD8Mu4=vsmX4wdQkFDT96JbKR=MQ@mail.gmail.com>
	<517B242D.7040902@ti.com>
	<CAJe_ZhdH+SCs5crguXrm6y-6bu+eGnTqeJS6cOS5H5Yz=m15Cw@mail.gmail.com>
	<517E9907.4030106@ti.com>
Date: Mon, 29 Apr 2013 22:19:08 +0530
Message-ID: <CAJe_Zhcm_jO6g2GjMEkQ=rYmav80f9bjj3OtypnRfcrh9zMRuw@mail.gmail.com>
Subject: Re: [PATCHv3 00/14] drivers: mailbox: framework creation
From: Jassi Brar <jaswinder.singh@linaro.org>
To: Suman Anna <s-anna@ti.com>
Cc: Loic PALLARDY <loic.pallardy@st.com>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        "Ohad Ben-Cohen (ohad@wizery.com)" <ohad@wizery.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "Andy Green (andy.green@linaro.org)" <andy.green@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Tony Lindgren <tony@atomide.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Omar Ramirez Luna (omar.ramirez@copitl.com)" 
	<omar.ramirez@copitl.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On 29 April 2013 21:30, Suman Anna <s-anna@ti.com> wrote:
> Hi Jassi,
>
> On 04/26/2013 11:51 PM, Jassi Brar wrote:

>>> OK, I didn't think of a no RTR interrupt-based controller. I would thing
>>> that such a controller is very rudimentary. I wonder if there are any
>>> controllers like this out there.
>>>
>> One of my controllers is like that :)
>
> I hope it does have a status register atleast, and not the "neither
> report nor sense RTR" type.
>
Actually the status is not set by the h/w, but the remote's firmware
implementation makes sure it sets a marker in the status register
after accepting data. So with some other firmware, we might not even
have the status read facility and the client will have to solely run
the TX ticker.

>> If the controller h/w absolutely can not tell the remote(sender) of a
>> received packet (as seems to be your case), its driver shouldn't even
>> try to demux the received messages. The client driver must know which
>> remotes could send it a message and how to discern them on the
>> platform. Some 'server' RX client is needed here.
>
> No demuxing, deliver the message to the different clients. It is a
> protocol agreement between the clients on what the message means. Think
> of this scenario akin to shared interrupts.
>
Please re-read. That's what I said - No demuxing by the controller driver :)

>
> The notify mechanism was the top-half on the interrupt handling. The
> faith part is coming from the fact that you expect all the clients to do
> the equivalent of the bottom-half (which would mean some duplication in
> the different clients), the OMAP scenario is such that all the different
> link interrupts (both rx & tx) are mapped onto a single physical
> interrupt. I think this may not be applicable to your usecase, wherein
> you probably expect a response back before proceeding.
>
Simply put - the RX by notifier method will fail should a client is
speed critical.
The api might provide it optionally, but direct handover should be the
default option.

Btw, I did put up an almost tested version of an API implementing most
of the features we agree upon
http://www.spinics.net/lists/kernel/msg1523873.html
http://www.spinics.net/lists/kernel/msg1523874.html

cheers.

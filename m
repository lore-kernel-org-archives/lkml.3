Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757405Ab3GOOJo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 10:09:44 -0400
Received: from co9ehsobe005.messaging.microsoft.com ([207.46.163.28]:43465
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757259Ab3GOOJn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 10:09:43 -0400
X-Forefront-Antispam-Report: CIP:192.65.42.18;KIP:(null);UIP:(null);IPV:NLI;H:mx.danahertm.com;RD:mx.danahertm.com;EFVD:NLI
X-SpamScore: -6
X-BigFish: VPS-6(z21eIz98dI9371I146fI542I1432I1418I4015Izz1f42h1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hz4ejz17326ah8275dhz2dh2a8h668h839h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h19ceh1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1155h)
From: "Rich, Jason" <jason.rich@tekcomms.com>
To: Willy Tarreau <w@1wt.eu>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: Panic at _blk_run_queue on 2.6.32
Thread-Topic: Panic at _blk_run_queue on 2.6.32
Thread-Index: Ac58y6RwiDajJiLlQbi1pm9xZ49xQgBCipKAAOOG4PA=
Date: Mon, 15 Jul 2013 14:09:32 +0000
Message-ID: <636295BFF4A001418A00F46569A2CD2B161DF7B0@US-PLNO-EXM01-P.global.tektronix.net>
References: <636295BFF4A001418A00F46569A2CD2B161CE88B@US-PLNO-EXM01-P.global.tektronix.net>
 <20130710202729.GA18877@1wt.eu>
In-Reply-To: <20130710202729.GA18877@1wt.eu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [129.196.128.144]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: tekcomms.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of Willy Tarreau
> Sent: Wednesday, July 10, 2013 3:27 PM
> To: Rich, Jason
> Cc: linux-kernel@vger.kernel.org
> Subject: Re: Panic at _blk_run_queue on 2.6.32
> 
> Hi Jason,
> 
> On Tue, Jul 09, 2013 at 05:42:29PM +0000, Rich, Jason wrote:
> > Greetings,
> > I've recently encountered an issue where multiple hosts are failing to
> > boot up about 1/5 of the time.  So far I have confirmed this issue on three
> seperate host machines.  The issue presents itself after updating 2.6.32.39 to
> patch 50 and patch 61.
> > Both patch levels result in the failure described below.  Since this occurs on
> multiple hosts, I feel I can safely rule out hardware.
> 
> First, thank you for your very detailed report. Do you think you could narrow
> this down to a specific kernel version ? Given that there are exactly 10
> versions between .39 and .50, I think that a version-level bisect would take
> 3 or 4 builds (so probably around 20 reboots).

I was out of town for a little while there, but I plan to do just that in a little while.  I will let you know what I find.  Hopefully it won't take me too terribly long.

> 
> It would help us spot the faulty patch. Right now, there are 546 patches
> between .39 and .50 so it's quite hard to find the culprit, even with your full
> trace. That does not mean we'll immediately spot it, maybe a deeper bisect
> will be needed, but it should be easier.
> 
> > It is also of note that I have not seen this behavior on the 3.4.26 kernel, or
> on any of my 32bit hosts.
> 
> This is a good news, because we're probably missing one fix from a more
> recent version that addressed a similar regression and that we might
> backport into 2.6.32.62.
> 
> > That said, I have to support this software release (which runs on the 2.6
> kernel) for at least another two years.
> 
> Be careful on this point, 2.6.32 is planned for EOL next year :
> 
>    https://www.kernel.org/category/releases.html
> 
> You might want to consider migrating to a supported distro kernel or to 3.2
> instead. That said, if you follow carefully the updates from later kernels, you
> might prefer to maintain your own backports of the patches that are relevant
> to your usage.

Thanks, we already have pulled in 3.4 to our released product, but I still have to support my product's previous releases for a time.  My goal is to patch up to .61 plus a fix to this issue and never touch the release again.   Worst case, I'll stay on 2.6.32.39 and cherry pick.  I'd really hate to do that, however.  Anyway, as stated earlier, I'll bisect and try to narrow this down.  Appreciate the help so far and really hope we just have to back patch a fix.

Jason
> 
> Best regards,
> Willy
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in the
> body of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



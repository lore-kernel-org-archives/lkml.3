Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561AbaDDPPv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 11:15:51 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:18774 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753534AbaDDPPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 11:15:49 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/HRx5x9XyGR8cTzACGz+W2mLyURKVEw80=
X-DKIM: OpenDKIM Filter v2.0.1 titan 1E3AD551EC9
Date: Fri, 4 Apr 2014 11:15:42 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: David Lang <david@lang.hm>
Cc: Levente Kurusa <levex@linux.com>,
        Teodora =?utf-8?B?QsSDbHXFo8SD?= <teobaluta@gmail.com>,
        Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>
Subject: Re: [RFC] QR encoding for Oops messages
Message-ID: <20140404151542.GB28334@titan.lakedaemon.net>
References: <1395093587-2583-1-git-send-email-teobaluta@gmail.com>
 <20140319201838.GA11403@redhat.com>
 <CACV2jQBrKBUmiYRj8L4tvWucGX5U0EqufC8BkSXoKOL1BO-Tuw@mail.gmail.com>
 <20140321132816.GW15608@titan.lakedaemon.net>
 <532DC3D3.9060008@linux.com>
 <CACV2jQBfRdQOyXF80WLoqm08-3VpWZno6UphKKPWmQD2f_yitA@mail.gmail.com>
 <20140323193839.GY15608@titan.lakedaemon.net>
 <CAAsK9AF8VevpdF-3nLC5sadV4y31cVeVWb5f2E=sV3ROu3Yk4Q@mail.gmail.com>
 <20140401142051.GO28304@titan.lakedaemon.net>
 <alpine.DEB.2.02.1404031353280.14073@nftneq.ynat.uz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1404031353280.14073@nftneq.ynat.uz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 03, 2014 at 01:57:04PM -0700, David Lang wrote:
> On Tue, 1 Apr 2014, Jason Cooper wrote:
> 
> >>Now I guess we need to think how to make it work without a
> >>framebuffer. I already suggested using the ASCII characters,
> >>but seeing the resolution of this QR code for example (147x147),
> >>made me realize that we can't shuffle that into a 80x25 textmode
> >>display. Any ideas how to fix that or should we just simply depend
> >>on a framebuffer being present?
> >
> >I think depending on the framebuffer being present (via kconfig) is
> >sane.  Folks running old systems know what they're in for, like missing
> >shiny new features. ;-)
> 
> First get it working and into acceptable form, but after that, take
> a look at the various ASCII-art tools out there. While the display
> may be limited to 80x25, that's not a hard requirement (and I'd
> happily run systems with a smaller text console if this was an
> option), and then you can look at the possibility of using
> characters that represent more than one pixel per character. While
> this may not be able to render everything perfectly, remember that
> qr codes can include redundancy to correct for bad pixels, you may
> be able to get something working.

I'm not sure this will work.  The screen space allocated to a single
character isn't square.  However, the QR pixels are square.  I see a lot
of fragile complexity ahead...

thx,

Jason.

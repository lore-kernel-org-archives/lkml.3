Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967AbaIPXRW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 19:17:22 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:34945 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753003AbaIPXRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 19:17:20 -0400
Date: Tue, 16 Sep 2014 17:17:16 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm <linux-arm-kernel@lists.infradead.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Jason Cooper <jason@lakedaemon.net>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PCI: mvebu: Fix uninitialized variable in
 mvebu_get_tgt_attr()
Message-ID: <20140916231716.GG5050@google.com>
References: <1407512045-26969-1-git-send-email-geert+renesas@glider.be>
 <20140905174122.GD8080@google.com>
 <20140905202044.4c166a43@free-electrons.com>
 <5898856.RmRf87KNto@wuerfel>
 <CAErSpo4sEQN6T9knuh4U2x9BCUODJheaAf3S8+W4U4oC-C7mMA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo4sEQN6T9knuh4U2x9BCUODJheaAf3S8+W4U4oC-C7mMA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05, 2014 at 01:00:29PM -0600, Bjorn Helgaas wrote:
> On Fri, Sep 5, 2014 at 12:34 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Friday 05 September 2014 20:20:44 Thomas Petazzoni wrote:
> >> Hum, I think I would actually prefer something like:
> >>
> >>                 if (DT_FLAGS_TO_TYPE(flags) == DT_TYPE_IO)
> >>                         rtype = IORESOURCE_IO;
> >>                 else if (DT_FLAGS_TO_TYPE(flags) == DT_TYPE_MEM32)
> >>                         rtype = IORESOURCE_MEM;
> >> +               else
> >> +                       continue;
> >>
> >> So that we're explicit with the fact that we only care about I/O and
> >> MEM32 resource types.
> >
> > Agreed, that looks better than my patch as well.
> 
> I like it better, too, but we still need the "range += rangesz" part,
> so I don't think it will work.  I suppose that could be moved to the
> update expression of the "for" loop.  Or, since we don't use "i" in
> the loop at all, maybe we could do something like this:
> 
>     for (; range < rend; range += rangesz)

Any more input on this?  I don't think I've seen anything actually acked by
Thomas or Jason.

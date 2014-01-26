Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228AbaAZSFO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 13:05:14 -0500
Received: from mail-yk0-f178.google.com ([209.85.160.178]:57827 "EHLO
	mail-yk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753173AbaAZSFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 13:05:13 -0500
Message-ID: <1390759506.6778.1.camel@laptop>
Subject: Re: [PATCH] for_each macros correctness
From: Jose Alonso <joalonsof@gmail.com>
To: Fubo Chen <fubo.chen@gmail.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Lukasz Dorau <lukasz.dorau@intel.com>,
        Maciej Patelczyk <maciej.patelczyk@intel.com>,
        Dave Jiang <dave.jiang@intel.com>, Simon Horman <horms@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Mundt <lethal@linux-sh.org>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Date: Sun, 26 Jan 2014 16:05:06 -0200
In-Reply-To: <CAJAFBLBONBLnMnC3Dq8fad4vAUPJPOjp6+5TEzdUAC=Dq6x7pQ@mail.gmail.com>
References: <1390733658.3059.10.camel@laptop>
	 <CAJAFBLBONBLnMnC3Dq8fad4vAUPJPOjp6+5TEzdUAC=Dq6x7pQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-01-26 at 14:39 +0100, Fubo Chen wrote:
> On Sun, Jan 26, 2014 at 11:54 AM, Jose Alonso <joalonsof@gmail.com> wrote:
> > I observed that there are for_each macros that do an extra memory access
> > beyond the defined area.
> > Normally this does not cause problems.
> > But, this can cause exceptions. For example: if the area is allocated at
> > the end of a page and the next page is not accessible.
> >
> > For correctness, I suggest changing the arguments of the 'for loop' like
> > others 'for_each' do in the kernel.
> 
> Does this patch fix a kernel crash when using gcc 4.8 like the patch
> in http://lkml.org/lkml/2014/1/21/146 ?

The patch for 'for_each_isci_host' is equivalent.

I followed the link above, and as I understand: The access to 
to_pci_info(pdev)->hosts[2] do not caused exception, but
the fact of hosts[2] is "logically accessed" "confused" the
gcc 4.8 compiler. (The gcc compiler do very aggressive loop
optimization and can eliminate loops executing each pass
linearly).



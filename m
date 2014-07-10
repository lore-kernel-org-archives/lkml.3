Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373AbaGJMNX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 08:13:23 -0400
Received: from smtp.citrix.com ([66.165.176.89]:43210 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753097AbaGJMNV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 08:13:21 -0400
X-IronPort-AV: E=Sophos;i="5.01,637,1400025600"; 
   d="scan'208";a="151348137"
Message-ID: <1404994390.8558.4.camel@kazak.uk.xensource.com>
Subject: Re: [PATCH v7 15/33] net: xen-netback - set name assign type
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Tom Gundersen <teg@jklm.no>
CC: netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        David Herrmann <dh.herrmann@gmail.com>, Kay Sievers <kay@vrfy.org>,
        Wei Liu <wei.liu2@citrix.com>,
        xen-devel <xen-devel@lists.xenproject.org>
Date: Thu, 10 Jul 2014 13:13:10 +0100
In-Reply-To: <CAG-2HqV+suLoSnge4dG4HUPbAS6EqC9rjy0W9G9AZqaVgRFF+A@mail.gmail.com>
References: <1404980258-30853-1-git-send-email-teg@jklm.no>
	 <1404980258-30853-16-git-send-email-teg@jklm.no>
	 <1404982886.30660.4.camel@hastur.hellion.org.uk>
	 <CAG-2HqV+suLoSnge4dG4HUPbAS6EqC9rjy0W9G9AZqaVgRFF+A@mail.gmail.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.80]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-07-10 at 12:46 +0200, Tom Gundersen wrote:
> On Thu, Jul 10, 2014 at 11:01 AM, Ian Campbell <ian.campbell@citrix.com> wrote:
> > On Thu, 2014-07-10 at 10:17 +0200, Tom Gundersen wrote:
> >> The name contains then xen handle, which is not guaranteed to be
> >> stable between restarts, so label this NET_NAME_ENUM.
> >
> > FWIW the N'th interface for domain with domid D will always be named
> > vifD.N.
> >
> > If you reboot domain D then it's domid will change to E and the new
> > device will be vifE.N.
> >
> > I don't know if that counts as predictable as far as the interface you
> > are introducing is concerned.
> 
> That was my understanding, thanks for confirming.
> 
> The idea is that the same interface on the same machine must get the
> same name between reboots in order to be considered predictable. So
> under the assumption that a rebooted domain should be considered "the
> same machine" (i.e., it still has the same local configuration,
> possibly referencing the interface names), then we should consider the
> names not predictable, so NET_NAME_ENUM.

OK, thanks. I'll defer to you understanding of what this interface is
supposed to mean: Acked-by: Ian Campbell <ian.campbell@citrix.com>

Ian.



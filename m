Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571AbaKQNqA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 08:46:00 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42839 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753426AbaKQNpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 08:45:44 -0500
Date: Mon, 17 Nov 2014 08:36:19 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: Julian Calaby <julian.calaby@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        b43-dev <b43-dev@lists.infradead.org>,
        Stefano Brivio <stefano.brivio@polimi.it>,
        Intel Linux Wireless <ilw@linux.intel.com>
Subject: Re: [PATCH 1/1 net-next] wireless: remove unnecessary sizeof(u8)
Message-ID: <20141117133618.GC3511@tuxdriver.com>
References: <1415998553-12636-1-git-send-email-fabf@skynet.be>
 <CAGRGNgWqjsDu_mQK=_agBWjOequb4b7ffgCuxRH=9d72grDYtQ@mail.gmail.com>
 <828430032.148603.1416203787175.open-xchange@webmail.nmp.skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <828430032.148603.1416203787175.open-xchange@webmail.nmp.skynet.be>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2014 at 06:56:27AM +0100, Fabian Frederick wrote:
> 
> 
> > On 16 November 2014 at 23:33 Julian Calaby <julian.calaby@gmail.com> wrote:
> >
> >
> > Hi Fabian,
> >
> > On Sat, Nov 15, 2014 at 7:55 AM, Fabian Frederick <fabf@skynet.be> wrote:
> > > sizeof(u8) is always 1.
> >
> > I thought that sizeof(*variable) was preferred over sizeof(type), so
> > shouldn't these be switched to that format instead?
> >
> > (I know that this is all no-op, but it should reduce the potential for
> > highly unlikely bugs in the future. Also, the extra processing is
> > compile-time not run-time.)
> >
> > Thanks,
> 
> Hi Julian,
> 
> Of course but char/u8/s8... allocations never use it and result would be the
> same:
> factor 1 multiplication.
> 
> Those rare occurrences (+- 30 in the whole kernel) where we have
> sizeof(u8/s8) is ambiguous.
> 
> Having a patch removing it gives a pointer...
> If the developer meant something else, he will be able to fix it.
> 
> Regards,
> Fabian

sizeof(*variable) still seems safer.  Are the compilers unable to
optimize-away a "multiply by one"?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

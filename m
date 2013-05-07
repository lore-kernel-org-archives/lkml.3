Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758550Ab3EGM4U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 08:56:20 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:42298 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757131Ab3EGM4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 08:56:19 -0400
X-IronPort-AV: E=Sophos;i="4.87,552,1363132800"; 
   d="scan'208";a="4300408"
Message-ID: <1367931376.26321.117.camel@zakaz.uk.xensource.com>
Subject: Re: [Xen-devel] [PATCH RFC v2 2/4] arm: introduce CONFIG_PARAVIRT
 and pv_time_ops
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "marc.zyngier@arm.com" <marc.zyngier@arm.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nico@linaro.org" <nico@linaro.org>, "olof@lixom.net" <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "cov@codeaurora.org" <cov@codeaurora.org>
Date: Tue, 7 May 2013 13:56:16 +0100
In-Reply-To: <alpine.DEB.2.02.1305071301040.4147@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1305061532310.4756@kaball.uk.xensource.com>
	 <1367851878-21629-2-git-send-email-stefano.stabellini@eu.citrix.com>
	 <1367918609.26321.43.camel@zakaz.uk.xensource.com>
	 <alpine.DEB.2.02.1305071301040.4147@kaball.uk.xensource.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-05-07 at 13:15 +0100, Stefano Stabellini wrote:
> On Tue, 7 May 2013, Ian Campbell wrote:
> > On Mon, 2013-05-06 at 15:51 +0100, Stefano Stabellini wrote:
> > > Introduce CONFIG_PARAVIRT on ARM.
> > 
> > What about PARAVIRT_TIME_ACCOUNTING? I'm not sure what it is but it
> > looks like a more lightweight version of pv stolen time?
>  
> PARAVIRT_TIME_ACCOUNTING selects PARAVIRT on x86 :-)

Ah, that's maybe what confused me.

TBH its not at all clear to me what distinction the core code is trying
to make with those two options, but do we not also want/need
PARAVIRT_TIME_ACCOUNTING? Having reread the help text it seems to be
some sort of "more accurate" accounting?

> > I think it would be a worthwhile change to refactor the stolen time
> > handling out from under the rather wide reaching umbrella of the x86
> > PARAVIRT option. (assuming PARAVIRT_TIME_ACCOUNTING isn't already that)
> 
> Actually PARAVIRT doesn't mean much in common code, the only thing it
> covers is stolen time.
> What I mean to say is that just because we are introducing something
> called "PARAVIRT" on ARM, it doesn't mean that it has to come with all
> sort of baggage.

I was more concerned with perceived baggage than actual trunks full of
skeletons.

Ian.


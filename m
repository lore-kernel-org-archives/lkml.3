Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751729Ab3EIIMH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 04:12:07 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:23248 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059Ab3EIIME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 04:12:04 -0400
X-IronPort-AV: E=Sophos;i="4.87,552,1363132800"; 
   d="scan'208";a="4386333"
Message-ID: <1368087121.17285.86.camel@zakaz.uk.xensource.com>
Subject: Re: [Xen-devel] [PATCH v3 4/4] xen/arm: account for stolen ticks
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: Marc Zyngier <marc.zyngier@arm.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Thu, 9 May 2013 09:12:01 +0100
In-Reply-To: <alpine.DEB.2.02.1305081712390.18865@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1305081446580.18865@kaball.uk.xensource.com>
	 <1368027714-14506-4-git-send-email-stefano.stabellini@eu.citrix.com>
	 <518A7836.4030705@arm.com>
	 <alpine.DEB.2.02.1305081712390.18865@kaball.uk.xensource.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-05-08 at 18:03 +0100, Stefano Stabellini wrote:
> > What if we have Xen support enabled but don't run as a Xen guest?
> 
> That's fine as long as the Xen runstate_memory_area interface is
> available.
> Usually I am a great fun of feature flags, so that every feature can be
> dynamically enabled or disabled and an hypervisor interface can be only
> partially implemented.
> 
> However the runstate_memory_area is very old and I would consider it
> one of the core interfaces that need to be available in order to claim
> "Xen compatibility".

I think Marc meant "what if CONFIG_XEN=y but we are running on KVM?". In
that case we wont have set either of the paravirt_steal*_enabled static
keys and so the hook won't be called.

> > > +	static_key_slow_inc(&paravirt_steal_enabled);
> > > +	static_key_slow_inc(&paravirt_steal_rq_enabled);
> > > +


Ian.


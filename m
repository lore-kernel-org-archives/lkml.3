Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936Ab3LMPv6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 10:51:58 -0500
Received: from smtp.citrix.com ([66.165.176.89]:56367 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752125Ab3LMPv4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 10:51:56 -0500
X-IronPort-AV: E=Sophos;i="4.95,479,1384300800"; 
   d="scan'208";a="84326423"
Date: Fri, 13 Dec 2013 15:51:27 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>,
        <george.dunlap@eu.citrix.com>, <ian.jackson@eu.citrix.com>,
        <mukesh.rathor@oracle.com>, <tim@xen.org>, <jbeulich@suse.com>,
        <boris.ostrovsky@oracle.com>, <david.vrabel@citrix.com>,
        Wei Liu <wei.liu2@citrix.com>
Subject: Re: [PATCH V10 05/14] xen/pvh: balloon and grant changes.
In-Reply-To: <20131213154722.GA7214@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.02.1312131550290.8667@kaball.uk.xensource.com>
References: <1386900621-27528-1-git-send-email-konrad.wilk@oracle.com> <1386900621-27528-6-git-send-email-konrad.wilk@oracle.com> <alpine.DEB.2.02.1312131147230.8667@kaball.uk.xensource.com> <20131213143620.GH2923@phenom.dumpdata.com>
 <alpine.DEB.2.02.1312131448340.8667@kaball.uk.xensource.com> <20131213145937.GB4770@phenom.dumpdata.com> <alpine.DEB.2.02.1312131530030.8667@kaball.uk.xensource.com> <20131213154722.GA7214@phenom.dumpdata.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Dec 2013, Konrad Rzeszutek Wilk wrote:
> > > > > > These changes to balloon.c are similar to my patch but:
> > > > > > 
> > > > > > - they don't prevent set_phys_to_machine from being called by
> > > > > > increase_reservation for auto_translated guests
> > > > > 
> > > > > <nods>
> > > > > > 
> > > > > > - they don't prevent wasteful balloon_scratch_page from being allocated
> > > > > > for auto_translated guests
> > > > > 
> > > > > <nods>
> > > > > > 
> > > > > > I think that it would be best to take my patch instead.
> > > > > 
> > > > > Lets focus the review on your patch then and have it part of this
> > > > > series. 
> > > > 
> > > > OK, but keep in mind that Xen on ARMv8 is currently broken without that
> > > > patch.
> > > 
> > > Hm. We could have another patch to just disable BALLOON on ARMv8 :-)
> > > 
> > > The question you have to ask - if your patch causes regression are you
> > > OK tracking/fixing it over the holidays :-) If yes, then yes - we can
> > > put that in v3.13-rc3 to make it work properly on ARMv8.
> > 
> > Damn, that was a good argument.
> > After thinking more about it, I think that I, or a member of my team,
> > can actually fix possible bugs during the holidays. Especially
> > considering that the patch doesn't alter the behavior of PV guests.
> > 
> > So in short, yes :)
> 
> Great <evil laughther>! Could you repost it with the description changes?
> Or if you OK with the changes I had proposed - just tell me "yes" and I will
> alter it.

I am OK with all the changes

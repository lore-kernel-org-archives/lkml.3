Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751702Ab3A2QOq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 11:14:46 -0500
Received: from smtp.citrix.com ([66.165.176.89]:27961 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809Ab3A2QOo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 11:14:44 -0500
X-IronPort-AV: E=Sophos;i="4.84,561,1355097600"; 
   d="scan'208";a="5486894"
Date: Tue, 29 Jan 2013 16:14:39 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: KY Srinivasan <kys@microsoft.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Olaf Hering <olaf@aepfle.de>, Jan Beulich <JBeulich@suse.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] x86: Hyper-V: register clocksource only if its
 advertised
In-Reply-To: <f4315e27ffc14047b5e2ef61eeeba036@SN2PR03MB061.namprd03.prod.outlook.com>
Message-ID: <alpine.DEB.2.02.1301291611270.10432@kaball.uk.xensource.com>
References: <1359121036-16309-1-git-send-email-olaf@aepfle.de> <761b736ff1854810bfe272961248e6d2@BLUPR03MB050.namprd03.prod.outlook.com> <20130125165443.GA15833@aepfle.de> <500ca90f5d3e4d4f80c7fb62c34d36f0@BLUPR03MB050.namprd03.prod.outlook.com>
 <20130125171923.GA19306@aepfle.de> <542f1d12e3ee46f48a85a143361c113d@SN2PR03MB061.namprd03.prod.outlook.com> <alpine.DEB.2.02.1301281737210.10432@kaball.uk.xensource.com> <510797FA02000078000BA4B8@nat28.tlf.novell.com> <20130129092652.GA9020@aepfle.de>
 <a23c7fab41444058845badb015b7dc0a@SN2PR03MB061.namprd03.prod.outlook.com> <alpine.DEB.2.02.1301291522460.10432@kaball.uk.xensource.com> <f4315e27ffc14047b5e2ef61eeeba036@SN2PR03MB061.namprd03.prod.outlook.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jan 2013, KY Srinivasan wrote:
> > > I agree with you that your patch is valid for making the Hyper-V code more
> > robust but not for dealing
> > > with general issue of Xen emulating Hyper-V.
> > 
> > What "general issue" would that be?
> 
> Not all Hyper-V specific features are advertised via a feature bit. For instance, we need to reserve
> an IDT entry to have VMBUS interrupts delivered on a per-CPU basis and this reservation is done
> after confirming that we are running on Hyper-V. With Xen emulating Hyper-V, we have an issue.
> Since Hyper-V will never emulate Xen, I am going to add a check in the Hyper-V detection code to
> deal with this issue.

I personally think that it would be much nicer to have a feature flag
somewhere to advertise per-CPU VMBUS interrupts.
However adding a check in the Hyper-V detection code is OK too for me.

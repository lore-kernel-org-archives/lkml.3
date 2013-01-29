Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757343Ab3A2Pa5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 10:30:57 -0500
Received: from smtp.citrix.com ([66.165.176.89]:49728 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756730Ab3A2Pay (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 10:30:54 -0500
X-IronPort-AV: E=Sophos;i="4.84,561,1355097600"; 
   d="scan'208";a="5478221"
Date: Tue, 29 Jan 2013 15:30:51 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: KY Srinivasan <kys@microsoft.com>
CC: Olaf Hering <olaf@aepfle.de>, Jan Beulich <JBeulich@suse.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] x86: Hyper-V: register clocksource only if its
 advertised
In-Reply-To: <a23c7fab41444058845badb015b7dc0a@SN2PR03MB061.namprd03.prod.outlook.com>
Message-ID: <alpine.DEB.2.02.1301291522460.10432@kaball.uk.xensource.com>
References: <1359121036-16309-1-git-send-email-olaf@aepfle.de> <761b736ff1854810bfe272961248e6d2@BLUPR03MB050.namprd03.prod.outlook.com> <20130125165443.GA15833@aepfle.de> <500ca90f5d3e4d4f80c7fb62c34d36f0@BLUPR03MB050.namprd03.prod.outlook.com>
 <20130125171923.GA19306@aepfle.de> <542f1d12e3ee46f48a85a143361c113d@SN2PR03MB061.namprd03.prod.outlook.com> <alpine.DEB.2.02.1301281737210.10432@kaball.uk.xensource.com> <510797FA02000078000BA4B8@nat28.tlf.novell.com> <20130129092652.GA9020@aepfle.de>
 <a23c7fab41444058845badb015b7dc0a@SN2PR03MB061.namprd03.prod.outlook.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jan 2013, KY Srinivasan wrote:
> > The patch which started this thread is still valid because it enables
> > feature B only if the featurebit for B is enabled.
> 
> Why would we need this if we have some other way of detecting that Hyper-V is being
> emulated.

I don't think that Hyper-V being emulated or not matters here.
What matters is whether the feature is available: only if it is then it
should be used.


> Furthermore, I am not sure I understand the logic here. The fact that the hypervisor
> supports PARTITION_REFERENCE_COUNTER does not necessarily mean that we should register
> a clocksource based on that reference counter. It is true that that is the case on Hyper-V today.
> However, on other hypervisors emulating Hyper-V, other standard clocksources maybe more
> appropriate.

The point is that if a feature is NOT supported, then it should NOT be
used. Only if it is supported, then Linux might consider using it. And
of course can decide not to use it.


> I agree with you that your patch is valid for making the Hyper-V code more robust but not for dealing
> with general issue of Xen emulating Hyper-V.

What "general issue" would that be?

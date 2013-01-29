Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608Ab3A2J1H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 04:27:07 -0500
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:33240 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434Ab3A2J1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 04:27:03 -0500
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmztM8TOFJii0PEz2J
X-RZG-CLASS-ID: mo00
Date: Tue, 29 Jan 2013 10:26:52 +0100
From: Olaf Hering <olaf@aepfle.de>
To: Jan Beulich <JBeulich@suse.com>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        KY Srinivasan <kys@microsoft.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Hyper-V: register clocksource only if its advertised
Message-ID: <20130129092652.GA9020@aepfle.de>
References: <1359121036-16309-1-git-send-email-olaf@aepfle.de>
 <761b736ff1854810bfe272961248e6d2@BLUPR03MB050.namprd03.prod.outlook.com>
 <20130125165443.GA15833@aepfle.de>
 <500ca90f5d3e4d4f80c7fb62c34d36f0@BLUPR03MB050.namprd03.prod.outlook.com>
 <20130125171923.GA19306@aepfle.de>
 <542f1d12e3ee46f48a85a143361c113d@SN2PR03MB061.namprd03.prod.outlook.com>
 <alpine.DEB.2.02.1301281737210.10432@kaball.uk.xensource.com>
 <510797FA02000078000BA4B8@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <510797FA02000078000BA4B8@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21.rev5636 (2013-01-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, Jan Beulich wrote:

> >>> On 28.01.13 at 18:44, Stefano Stabellini <stefano.stabellini@eu.citrix.com> wrote:
> > I think that Olaf made his point very clear: a feature A should only be
> > enabled if the corresponding flag A is set.
> > In fact it seems to me that this patch is correct on its own merits,
> > regardless of Xen does or does not.
> > 
> > The Xen tools might or might not know whether a guest is going to be
> > Linux, Windows, FreeBSD or whatever else people use nowadays.  Setting
> > viridian=1 is the safe choice, given that it shouldn't create any
> > issues: after all guests are supposed to check for feature flags before
> > using them.
> > 
> > If Xen is going to implement "Partition Reference Counter", it is also
> > going to set the corresponding flag, so the guest OS (Windows, Linux,
> > my pet OS) can check whether the feature is available and decide whether
> > it wants to use it.
> 
> While I agree in general, the specific case of the callback vector
> seems a little more difficult: As KY says, there's no feature flag
> for this (or perhaps more precisely for it being deliverable across
> all CPUs), and hence there's both the problem of detection and
> the problem of disambiguation (as otherwise both the Hyper-V
> code and the Xen code in Linux could be trying to use the same
> vector).

This is true, but belongs to that other thread about the interrupt
vector. I agree that the detection in ms_hyperv_platform() should be
extended, with a DMI check for example.

The patch which started this thread is still valid because it enables
feature B only if the featurebit for B is enabled.

Olaf

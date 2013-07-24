Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758105Ab3GXAWn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 20:22:43 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:16431 "EHLO
	smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002Ab3GXAWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 20:22:42 -0400
X-IronPort-AV: E=Sophos;i="4.89,731,1367971200"; 
   d="scan'208";a="585125542"
Date: Tue, 23 Jul 2013 17:22:36 -0700
From: Matt Wilson <msw@amazon.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, <xen-devel@lists.xensource.com>,
        Daniel Kiper <daniel.kiper@oracle.com>, <linux-kernel@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Brandon Philips <brandon@ifup.org>
Subject: Re: [Xen-devel] is kexec on Xen domU possible?
Message-ID: <20130724002235.GA15047@u109add4315675089e695.ant.amazon.com>
References: <20130719020603.GA22932@kroah.com>
 <20130719131819.GC11233@debian70-amd64.local.net-space.pl>
 <20130719151243.GA15488@kroah.com>
 <20130719183235.GA12267@debian70-amd64.local.net-space.pl>
 <20130719191449.GA1882@kroah.com>
 <51E9A85D.2060206@zytor.com>
 <20130722170307.GB14451@debian70-amd64.local.net-space.pl>
 <87wqoise9d.fsf@xmission.com>
 <51ED78EE.9020903@zytor.com>
 <20130722183315.GA29273@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130722183315.GA29273@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 22, 2013 at 11:33:15AM -0700, Greg KH wrote:
> On Mon, Jul 22, 2013 at 11:24:46AM -0700, H. Peter Anvin wrote:
> > On 07/22/2013 10:20 AM, Eric W. Biederman wrote:
> > >>>
> > >>> Also, in any virtualized environment the hypervisor can do a better job
> > >>> for things like kdump, simply because it can provide two things that are
> > >>> otherwise hard to do:
> > >>>
> > >>> 1. a known-good system state;
> > >>> 2. a known-clean kdump image.
> > >>>
> > >>> As such, I do encourage the virtualization people to (also) develop
> > >>> hypervisor-*aware* solutions for these kinds of things.
> > >>
> > >> In general I agree but if you could not change hypervisor
> > >> and/or dom0 (e.g. you are using cloud providers which are
> > >> stick to old versions of Xen) then you have no choice.
> > > 
> > > Which tends to be where kexec on panic comes in most cases.  Getting
> > > platform vendors to do something sane tends to be a multi-year political
> > > effort of dubious worth while just solving the problem locally actually
> > > gets the problem solved for those who care.
> > > 
> > 
> > It should not be a "one or the other" issue.
> 
> I don't care about kdump, I care about kexec on domU for people who are
> running on cloud providers with old versions of Xen so that they can
> control what kernel they can boot, when they want to boot it.  If kdump
> works as well, that's just a bonus, but it's down on the list of things
> for me to be concerned about.

Many Xen-based cloud providers provide a mechanism for users to boot
the kernels they want. For example you can use PV-GRUB on EC2
instances to boot a kernel that is stored within an AMI.

For more info:
  http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/UserProvidedkernels.html

--msw

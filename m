Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756511AbaHHNqZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 09:46:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54081 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244AbaHHNqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 09:46:22 -0400
Date: Fri, 8 Aug 2014 06:45:49 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Dexuan Cui <decui@microsoft.com>
Cc: "olaf@aepfle.de" <olaf@aepfle.de>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Shao <huishao@microsoft.com>,
        "Yue Zhang (OSTC DEV)" <yuezha@microsoft.com>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH] Hyperv: Trigger DHCP renew after host hibernation
Message-ID: <20140808134549.GD4427@kroah.com>
References: <DC7803B42427924284F2D5252E076A3B4476A479@SINEX14MBXC416.southpacific.corp.microsoft.com>
 <53CCD6F2.6020909@nod.at>
 <20140721091851.GA28171@aepfle.de>
 <20140721.143225.2040366896972949930.davem@davemloft.net>
 <CAFLxGvyfy1UkxN6_-c_ST7f8n7DvqYsCPKChWmt9CerWb0dh7g@mail.gmail.com>
 <EE124450C0AAF944A40DD71E61F878C99149D0@SINEX14MBXC417.southpacific.corp.microsoft.com>
 <20140808033220.GB10503@kroah.com>
 <EE124450C0AAF944A40DD71E61F878C991569A@SINEX14MBXC417.southpacific.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <EE124450C0AAF944A40DD71E61F878C991569A@SINEX14MBXC417.southpacific.corp.microsoft.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08, 2014 at 08:11:20AM +0000, Dexuan Cui wrote:
> > From: Greg KH [mailto:gregkh@linuxfoundation.org]
> > Sent: Friday, August 8, 2014 11:32 AM
> > > Hi Richard and all,
> > >
> > > IMO the most feasible and need-the-least-change solution may be:
> > > the hyperv network VSC driver passes the event
> > > RNDIS_STATUS_NETWORK_CHANGE to the udev daemon?
> > >
> > > In this way, every distro only needs to add a udev rule, which should
> > > be simple.
> > 
> > No, don't do that, again, act like any other network device, drop the
> > link and bring it up when it comes back.
> > 
> > greg k-h
> 
> Hi Greg,
> Thanks for the comment!
> 
> Do you mean tearing down the net device and re-creating it (by
> register_netdev() and unregister_netdev)?

No, don't you have link-detect for your network device?  Toggle that, I
thought patches to do this were posted a while ago...

But if you really want to tear the whole network device down and then
back up again, sure, that would also work.

good luck,

greg k-h

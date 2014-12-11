Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756314AbaLKMDo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 07:03:44 -0500
Received: from mga09.intel.com ([134.134.136.24]:6883 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932159AbaLKMDm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 07:03:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,557,1413270000"; 
   d="scan'208";a="652183839"
From: "Varlese, Marco" <marco.varlese@intel.com>
To: Jiri Pirko <jiri@resnulli.us>
CC: John Fastabend <john.fastabend@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "Fastabend, John R" <john.r.fastabend@intel.com>,
        "roopa@cumulusnetworks.com" <roopa@cumulusnetworks.com>,
        "sfeldma@gmail.com" <sfeldma@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RFC PATCH net-next 1/1] net: Support for switch port
 configuration
Thread-Topic: [RFC PATCH net-next 1/1] net: Support for switch port
 configuration
Thread-Index: AdAUhPtXGtfGamc6R3Ssf+89G79LDwAFGVwAAAB5JYAAIzgFYAACaLCAAAIO5jA=
Date: Thu, 11 Dec 2014 12:02:36 +0000
Message-ID: <C4896FB061E7DE4AAC93031BDCA044B104AC3E77@IRSMSX108.ger.corp.intel.com>
References: <C4896FB061E7DE4AAC93031BDCA044B104AC3257@IRSMSX108.ger.corp.intel.com>
 <20141210165018.GG1863@nanopsycho.orion> <54887CF7.70708@gmail.com>
 <C4896FB061E7DE4AAC93031BDCA044B104AC3914@IRSMSX108.ger.corp.intel.com>
 <20141211110115.GA1979@nanopsycho.lan>
In-Reply-To: <20141211110115.GA1979@nanopsycho.lan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [163.33.239.182]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Jiri Pirko [mailto:jiri@resnulli.us]
> Sent: Thursday, December 11, 2014 11:01 AM
> To: Varlese, Marco
> Cc: John Fastabend; netdev@vger.kernel.org;
> stephen@networkplumber.org; Fastabend, John R;
> roopa@cumulusnetworks.com; sfeldma@gmail.com; linux-
> kernel@vger.kernel.org
> Subject: Re: [RFC PATCH net-next 1/1] net: Support for switch port
> configuration
> 
> Thu, Dec 11, 2014 at 10:59:42AM CET, marco.varlese@intel.com wrote:
> >> -----Original Message-----
> >> From: John Fastabend [mailto:john.fastabend@gmail.com]
> >> Sent: Wednesday, December 10, 2014 5:04 PM
> >> To: Jiri Pirko
> >> Cc: Varlese, Marco; netdev@vger.kernel.org;
> >> stephen@networkplumber.org; Fastabend, John R;
> >> roopa@cumulusnetworks.com; sfeldma@gmail.com; linux-
> >> kernel@vger.kernel.org
> >> Subject: Re: [RFC PATCH net-next 1/1] net: Support for switch port
> >> configuration
> >>
> >> On 12/10/2014 08:50 AM, Jiri Pirko wrote:
> >> > Wed, Dec 10, 2014 at 05:23:40PM CET, marco.varlese@intel.com wrote:
> >> >> From: Marco Varlese <marco.varlese@intel.com>
> >> >>
> >> >> Switch hardware offers a list of attributes that are configurable
> >> >> on a per port basis.
> >> >> This patch provides a mechanism to configure switch ports by
> >> >> adding an NDO for setting specific values to specific attributes.
> >> >> There will be a separate patch that extends iproute2 to call the
> >> >> new NDO.
> >> >
> >> >
> >> > What are these attributes? Can you give some examples. I'm asking
> >> > because there is a plan to pass generic attributes to switch ports
> >> > replacing current specific ndo_switch_port_stp_update. In this
> >> > case, bridge is setting that attribute.
> >> >
> >> > Is there need to set something directly from userspace or does it
> >> > make rather sense to use involved bridge/ovs/bond ? I think that
> >> > both will be needed.
> >>
> >> +1
> >>
> >> I think for many attributes it would be best to have both. The in
> >> kernel callers and netlink userspace can use the same driver ndo_ops.
> >>
> >> But then we don't _require_ any specific bridge/ovs/etc module. And
> >> we may have some attributes that are not specific to any existing
> >> software module. I'm guessing Marco has some examples of these.
> >>
> >> [...]
> >>
> >>
> >> --
> >> John Fastabend         Intel Corporation
> >
> >We do have a need to configure the attributes directly from user-space and
> I have identified the tool to do that in iproute2.
> >
> >An example of attributes are:
> >* enabling/disabling of learning of source addresses on a given port
> >(you can imagine the attribute called LEARNING for example);
> >* internal loopback control (i.e. LOOPBACK) which will control how the
> >flow of traffic behaves from the switch fabric towards an egress port;
> >* flooding for broadcast/multicast/unicast type of packets (i.e.
> >BFLOODING, MFLOODING, UFLOODING);
> >
> >Some attributes would be of the type enabled/disabled while other will
> allow specific values to allow the user to configure different behaviours of
> that feature on that particular port on that platform.
> >
> >One thing to mention - as John stated as well - there might be some
> attributes that are not specific to any software module but rather have to do
> with the actual hardware/platform to configure.
> >
> >I hope this clarifies some points.
> 
> It does. Makes sense. We need to expose this attr set/get for both in-kernel
> and userspace use cases.
> 
> Please adjust you patch for this. Also, as a second patch, it would be great if
> you can convert ndo_switch_port_stp_update to this new ndo.
> 
> Thanks.
> 
> 

I was thinking of leaving the get side of things implemented via sysfs rather than implementing an NDO for it. Would this not be appropriate?

- - -
Marco Varlese


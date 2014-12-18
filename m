Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751460AbaLRSDX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 13:03:23 -0500
Received: from mga03.intel.com ([134.134.136.65]:15678 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751078AbaLRSDW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 13:03:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,602,1413270000"; 
   d="scan'208";a="626119619"
From: "Varlese, Marco" <marco.varlese@intel.com>
To: Roopa Prabhu <roopa@cumulusnetworks.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Fastabend, John R" <john.r.fastabend@intel.com>,
        Thomas Graf <tgraf@suug.ch>, Jiri Pirko <jiri@resnulli.us>,
        "sfeldma@gmail.com" <sfeldma@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RFC PATCH net-next v2 1/1] net: Support for switch port
 configuration
Thread-Topic: [RFC PATCH net-next v2 1/1] net: Support for switch port
 configuration
Thread-Index: AdAaqPMciB9+ZS56Q6O2uHwvQZyp6AAKDZcAAABJxuAAANCagAAEZHVgAAD3MgAAAECjAA==
Date: Thu, 18 Dec 2014 18:02:23 +0000
Message-ID: <C4896FB061E7DE4AAC93031BDCA044B104ADA310@IRSMSX108.ger.corp.intel.com>
References: <C4896FB061E7DE4AAC93031BDCA044B104AD7B82@IRSMSX108.ger.corp.intel.com>
 <5492E85C.6010802@cumulusnetworks.com>
 <C4896FB061E7DE4AAC93031BDCA044B104AD9E53@IRSMSX108.ger.corp.intel.com>
 <5492EFC3.8030102@cumulusnetworks.com>
 <C4896FB061E7DE4AAC93031BDCA044B104ADA16F@IRSMSX108.ger.corp.intel.com>
 <549313B8.6050102@cumulusnetworks.com>
In-Reply-To: <549313B8.6050102@cumulusnetworks.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [163.33.239.181]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed unnecessary content for ease of reading...

> >>>>> +/* Switch Port Attributes section */
> >>>>> +
> >>>>> +enum {
> >>>>> +	IFLA_ATTR_UNSPEC,
> >>>>> +	IFLA_ATTR_LEARNING,
> >>>> Any reason you want learning here ?. This is covered as part  of
> >>>> the bridge setlink attributes.
> >>>>
> >>> Yes, because the user may _not_ want to go through a bridge
> >>> interface
> >> necessarily.
> >> But, the bridge setlink/getlink interface was changed to accommodate
> 'self'
> >> for exactly such cases.
> >> I kind of understand your case for the other attributes (these are
> >> per port settings that switch asics provide).
> >>
> >> However, i don't understand the reason to pull in bridge attributes here.
> >>
> > Maybe, I am missing something so you might help. The learning attribute -
> in my case - it is like all other attributes: a port attribute (as you said, port
> settings that the switch provides per port).
> > So, what I was saying is "why the user shall go through a bridge to configure
> the learning attribute"? From my perspective, it is as any other attribute and
> as such configurable on the port.
> 
> Thinking about this some more, i don't see why any of these attributes
> (except loopback. I dont understand the loopback attribute) cant be part of
> the birdge port attributes.
> 
> With this we will end up adding l2 attributes in two places: the general link
> attributes and bridge attributes.
> 
> And since we have gone down the path of using ndo_bridge_setlink/getlink
> with 'self'....we should stick to that for all l2 attributes.
> 
> The idea of overloading ndo_bridge_set/getlink, was to have the same set of
> attributes but support both cases where the user wants to go through the
> bridge driver or directly to the switch port driver. So, you are not really going
> through the bridge driver if you use 'self' and ndo_bridge_setlink/getlink.
> 

Roopa, one of the comments I got from Thomas Graf on my v1 patch was that your patch and mine were supplementary ("I think Roopa's patches are supplementary. Not all switchdev users will be backed with a Linux Bridge. I therefore welcome your patches very much")... I also understood by others that the patch made sense for the same reason. I simply do not understand why these attributes (and maybe others in the future) could not be configured directly on a standard port but have to go through a bridge.


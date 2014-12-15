Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124AbaLOOHw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:07:52 -0500
Received: from casper.infradead.org ([85.118.1.10]:39292 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367AbaLOOHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:07:50 -0500
Date: Mon, 15 Dec 2014 14:07:49 +0000
From: Thomas Graf <tgraf@suug.ch>
To: "Varlese, Marco" <marco.varlese@intel.com>
Cc: John Fastabend <john.fastabend@gmail.com>, Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "Fastabend, John R" <john.r.fastabend@intel.com>,
        "roopa@cumulusnetworks.com" <roopa@cumulusnetworks.com>,
        "sfeldma@gmail.com" <sfeldma@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH net-next 1/1] net: Support for switch port
 configuration
Message-ID: <20141215140749.GB21952@casper.infradead.org>
References: <C4896FB061E7DE4AAC93031BDCA044B104AC3257@IRSMSX108.ger.corp.intel.com>
 <20141210165018.GG1863@nanopsycho.orion>
 <54887CF7.70708@gmail.com>
 <C4896FB061E7DE4AAC93031BDCA044B104AC3914@IRSMSX108.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C4896FB061E7DE4AAC93031BDCA044B104AC3914@IRSMSX108.ger.corp.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <tgraf@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/14 at 09:59am, Varlese, Marco wrote:
> An example of attributes are:
> * enabling/disabling of learning of source addresses on a given port (you can imagine the attribute called LEARNING for example);
> * internal loopback control (i.e. LOOPBACK) which will control how the flow of traffic behaves from the switch fabric towards an egress port;
> * flooding for broadcast/multicast/unicast type of packets (i.e. BFLOODING, MFLOODING, UFLOODING);

All of these are highly generic and should *not* be passed through
from user space to the driver directly but rather be properly
abstracted as Roopa proposed. The value of this API is abstraction.
If we introduce per device attributes for generic functions we lose
large portions of the value gained.

You mentioned you have additional attributes in mind, maybe you can
give a few examples which are not generic, i.e. do not apply to
multiple vendors.

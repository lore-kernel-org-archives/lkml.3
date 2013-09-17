Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753787Ab3IQV5O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 17:57:14 -0400
Received: from gate.crashing.org ([63.228.1.57]:42090 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752863Ab3IQV5M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 17:57:12 -0400
Message-ID: <1379455006.6148.0.camel@pasglop>
Subject: Re: "memory" binding issues
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Olof Johansson <olof@lixom.net>
Cc: frowand.list@gmail.com, Tomasz Figa <tomasz.figa@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Stephen Warren <swarren@nvidia.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 18 Sep 2013 07:56:46 +1000
In-Reply-To: <CAOesGMh0F09OAR4bepGSCE5Z5OZ56fBmDPBSfwZ+NB9RgcE0Vw@mail.gmail.com>
References: <1379300274.4098.77.camel@pasglop>
	 <1379371567.3721.46.camel@pasglop>
	 <CAOesGMgE1jiF5OHsmPQz2z66Bcqu0HeAj=taE1vmFK-0-0s2TQ@mail.gmail.com>
	 <1815499.tpfeUKmP6V@flatron> <20130917164307.GA31327@quad.lixom.net>
	 <5238C4D1.6060500@gmail.com>
	 <CAOesGMh0F09OAR4bepGSCE5Z5OZ56fBmDPBSfwZ+NB9RgcE0Vw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2013-09-17 at 14:15 -0700, Olof Johansson wrote:
> Sigh, that's horrible. OF clearly doesn't require it.

Doesn't it ?

All OF implementations will create it, you would have to explicitly
remove the encode-unit method of the parent to make it disappear...

All I can find in 1275 is:

<<
Some nodes in the device tree do not represent physical devices. These
system nodes are used instead for various
general firmware purposes. System nodes do not have physical addresses.
Their node names have a driver name
field but not a unit address field.
>>

That implies that such nodes also don't have a "reg" property (ie. "do
not have physical address").

I don't see anything else, if anything, the definition of the node name
seems to not have provisions for a missing unit address.

The only case in OF that I know where the unit address is not present is
wildcard nodes (also known as protocol nodes) which also don't have a
"reg" property such as used by some SCSI controllers when the fcode
doesn't want to probe the bus at boot and requires the unit address to
be explicitly passed in the "open" call. This is clearly not the case
here.

Or did I miss something ?

> I guess people prefer to follow ePAPR even though it's broken? That
> means someone needs to cleanup the current dts files. Any takers?

It's not broken. I don't understand why you are so adamant about
that :-)

Cheers,
Ben.




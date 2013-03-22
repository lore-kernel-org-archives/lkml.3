Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345Ab3CVT3k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 15:29:40 -0400
Received: from gate.crashing.org ([63.228.1.57]:33435 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755148Ab3CVT3j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 15:29:39 -0400
Message-ID: <1363980558.11644.8.camel@pasglop>
Subject: Re: [PATCH V2 2/2] of: remove /proc/device-tree
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Nathan Fontenot <nfont@linux.vnet.ibm.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        David Miller <davem@davemloft.net>
Date: Fri, 22 Mar 2013 20:29:18 +0100
In-Reply-To: <514C9CF1.7060505@linux.vnet.ibm.com>
References: <1363865097-32764-1-git-send-email-grant.likely@secretlab.ca>
	 <1363865097-32764-3-git-send-email-grant.likely@secretlab.ca>
	 <1363870366.3312.1.camel@pasglop>
	 <CACxGe6vSywW_iekAKmDMf5_TLLt5Hn+Jttq8kddq3vJ=AE+DQA@mail.gmail.com>
	 <CACxGe6uCKRH8jcGJW+oYt+T33XT_MGzaxmtkNdekMooGqBYTEw@mail.gmail.com>
	 <514C9CF1.7060505@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-03-22 at 13:03 -0500, Nathan Fontenot wrote:
> We don't ever free old property values, mainly I assume since we don't keep
> reference counts and can't know when it is safe to do so. The problem I
> am starting to see on pseries is that we are getting very large properties.
> One of the biggest culprits is the property on pseries systems to describe
> the memory on the system in the device tree. These are big and getting
> bigger as memory increases, additionally this property is update every
> time memory is DLPAR added or removed from the system which can lead to
> leaving a bunch of memory that should be free'ed.
> 
> Given that, is there (or has there been) any discussion on adding reference
> counts to properties in the device tree? With the myriad ways to get at
> the value of a property this may not be feasible but I would like to hear
> any thoughts from the community.

My assumption was always that the lifetime of property values is tied
the the lifetime of the node they are in. IE, we wouldn't free a
property removed from a node but we could free all properties when
the node goes away...

Not the best but would do...

refcount of properties, well ... Grant, do we get kobjects for them with
the sysfs stuff ? That could do the trick...

Ben.
 


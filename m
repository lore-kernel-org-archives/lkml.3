Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768Ab3KOTHR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 14:07:17 -0500
Received: from mail-we0-f173.google.com ([74.125.82.173]:40034 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352Ab3KOTHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 14:07:09 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH V2 2/2] of: remove /proc/device-tree
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Nathan Fontenot <nfont@linux.vnet.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        David Miller <davem@davemloft.net>
In-Reply-To: <1363980558.11644.8.camel@pasglop>
References: <1363865097-32764-1-git-send-email-grant.likely@secretlab.ca> < 1363865097-32764-3-git-send-email-grant.likely@secretlab.ca> <1363870366. 3312.1.camel@pasglop> <CACxGe6vSywW_iekAKmDMf5_TLLt5Hn+Jttq8kddq3vJ=AE+DQA@ mail.gmail.com> <CACxGe6uCKRH8jcGJW+oYt+T33XT_MGzaxmtkNdekMooGqBYTEw@mail. gmail.com> <514C9CF1.7060505@linux.vnet.ibm.com> <1363980558.11644.8.camel@ pasglop>
Date: Fri, 15 Nov 2013 16:10:39 +0000
Message-Id: <20131115161039.B727AC40568@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Mar 2013 20:29:18 +0100, Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
> On Fri, 2013-03-22 at 13:03 -0500, Nathan Fontenot wrote:
> > We don't ever free old property values, mainly I assume since we don't keep
> > reference counts and can't know when it is safe to do so. The problem I
> > am starting to see on pseries is that we are getting very large properties.
> > One of the biggest culprits is the property on pseries systems to describe
> > the memory on the system in the device tree. These are big and getting
> > bigger as memory increases, additionally this property is update every
> > time memory is DLPAR added or removed from the system which can lead to
> > leaving a bunch of memory that should be free'ed.
> > 
> > Given that, is there (or has there been) any discussion on adding reference
> > counts to properties in the device tree? With the myriad ways to get at
> > the value of a property this may not be feasible but I would like to hear
> > any thoughts from the community.
> 
> My assumption was always that the lifetime of property values is tied
> the the lifetime of the node they are in. IE, we wouldn't free a
> property removed from a node but we could free all properties when
> the node goes away...
> 
> Not the best but would do...

As a middle way, we could modify the property in-place if the size of
the new prop is <= the size of the old. Anyone foresee a problem with
that approach? It could expose race conditions between reading and
writing the new property value into the buffer and updating the length
field.

g.

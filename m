Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751171AbaCPGXi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 02:23:38 -0400
Received: from gate.crashing.org ([63.228.1.57]:42483 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750801AbaCPGXg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 02:23:36 -0400
Message-ID: <1394950946.15098.111.camel@pasglop>
Subject: Re: [PATCH v7 3/3] arm64: Add architecture support for PCI
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Liviu Dudau <Liviu.Dudau@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        linux-pci <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Will Deacon <Will.Deacon@arm.com>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>
Date: Sun, 16 Mar 2014 17:22:26 +1100
In-Reply-To: <201403142010.39886.arnd@arndb.de>
References: <1394811258-1500-1-git-send-email-Liviu.Dudau@arm.com>
	 <201403141838.08900.arnd@arndb.de>
	 <20140314180527.GZ6457@e106497-lin.cambridge.arm.com>
	 <201403142010.39886.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.11.90 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-03-14 at 20:10 +0100, Arnd Bergmann wrote:
> > As for the other two functions, I've no special attachment to where they are present
> > and I'm happy to move them into drivers/pci on the condition that the patchset doesn't
> > double in size. The reason why I'm weary of touching other architectures in a significant
> > way is the current lack of engineering bandwidth and way of testing all the architectures.
> > My low friction approach has been to introduce them in arm64 and then slowly move them
> > into core (and yes, I know about good intentions and the road to hell.)
> 
> I think everyone working on PCI is fed up with having arch-specific implementations
> of all these, and Bjorn has been very supportive of generic infrastructure in the
> past. Even just adding a generic infrastructure in a common place that is used
> only by one architecture in my mind would be a significant improvement.

I agree, it's a reasonable approach and microblaze which is simple and just "copied"
powerpc originally would be a good one to move over as well.

powerpc itself has many historical quirks and while I'm interested in a common
implementation, it will take me a bit of spare time to get through things and
figure out what can be done there and what "hooks" might still be necessary.

At this point, it's mostly a matter of:

 - I'm the one who knows the most about the powerpc PCI code as I wrote large
chunks of it

 - I'm very very very busy with some other things at the moment

So don't take my silence on these matters as a lack of interest, I think it's
definitely all going in the right direction, I just don't have much bandwidth
to consider the move of powerpc over just yet.

Cheers,
Ben.



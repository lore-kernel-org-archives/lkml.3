Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751232AbaKEXbq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 18:31:46 -0500
Received: from one.firstfloor.org ([193.170.194.197]:43418 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbaKEXbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 18:31:43 -0500
Date: Thu, 6 Nov 2014 00:31:40 +0100
From: Andi Kleen <andi@firstfloor.org>
To: "Luis R. Rodriguez" <mcgrof@suse.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "backports@vger.kernel.org" <backports@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>,
        Michal Marek <mmarek@suse.cz>, Stefan Assmann <sassmann@kpanic.de>
Subject: Re: [PATCH v2 03/13] backports: allow for different backport prefix
Message-ID: <20141105233140.GE12538@two.firstfloor.org>
References: <1415157517-15442-1-git-send-email-mcgrof@do-not-panic.com>
 <1415157517-15442-4-git-send-email-mcgrof@do-not-panic.com>
 <1415173596.2589.3.camel@sipsolutions.net>
 <20141105091610.GM12953@wotan.suse.de>
 <1415179364.2589.13.camel@sipsolutions.net>
 <20141105194215.GN12953@wotan.suse.de>
 <1415222258.7485.10.camel@sipsolutions.net>
 <20141105222159.GS12953@wotan.suse.de>
 <20141105230907.GD12538@two.firstfloor.org>
 <CAB=NE6Wu7gFh+_1ebiaWCq2cUt_SnCMB-+1Xv9ZuZtBafdg0Vg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAB=NE6Wu7gFh+_1ebiaWCq2cUt_SnCMB-+1Xv9ZuZtBafdg0Vg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The only thing that was not clear to me from reviewing the module
> namespace stuff a while ago was the original intent, but I confess I
> actually only looked at the technical details to see if it was
> applicable to the backports case, do you recall the original
> motivation ?

The original intent was to provide a cleaner export symbol API.

There are roughly two classes of exported symbols:

- Generally usable, well designed, interfaces intended to be used by multiple
modules (e.g. functions for drivers to register themselves or
library functions)

- Special purpose exports that are only really for a single
module, but are not intended as a general interface. These interfaces
are usually not really clean and reusable.

The idea was to mark the later special purpose exports with the name of the
module that is supposed to them. They wouldn't be available
to everybody else and wouldn't become part of the general
kernel module API.

-Andi


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760226AbaGPS6B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 14:58:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53684 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753854AbaGPS56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 14:57:58 -0400
Date: Wed, 16 Jul 2014 12:02:32 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: "Bridgman, John" <John.Bridgman@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>,
        "Lewycky, Andrew" <Andrew.Lewycky@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>
Subject: Re: [PATCH 00/83] AMD HSA kernel driver
Message-ID: <20140716190232.GB31046@kroah.com>
References: <019CCE693E457142B37B791721487FD9180A193B@storexdag01.amd.com>
 <20140713035535.GB5301@gmail.com>
 <D89D60253BB73A4E8C62F9FD18A939CA0103C0EB@storexdag02.amd.com>
 <20140713164901.GB10624@gmail.com>
 <53C396D3.9000600@vodafone.de>
 <CAPM=9txM=0Rd8sP56X1v2sXhAYiRJDoz-j8+N0wXpam-+kYJ8Q@mail.gmail.com>
 <D89D60253BB73A4E8C62F9FD18A939CA01050131@storexdag02.amd.com>
 <20140715173704.GA3421@gmail.com>
 <D89D60253BB73A4E8C62F9FD18A939CA01050211@storexdag02.amd.com>
 <CAKMK7uHzfb5nPbpoO1-gQp=wzRdWoNggXnEkQj9Pnkr6hKZB4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKMK7uHzfb5nPbpoO1-gQp=wzRdWoNggXnEkQj9Pnkr6hKZB4g@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 10:21:14AM +0200, Daniel Vetter wrote:
> On Tue, Jul 15, 2014 at 7:53 PM, Bridgman, John <John.Bridgman@amd.com> wrote:
> [snip away the discussion about hsa device discover, I'm hijacking
> this thread just for the event/fence stuff here.]
> 
> > ... There's an event mechanism still to come - mostly for communicating fences and shader interrupts back to userspace, but also used for "device change" notifications, so no polling of sysfs.
> 
> That could would be interesting. On i915 my plan is to internally use
> the recently added struct fence from Maarten. For the external
> interface for userspace that wants explicit control over fences I'm
> leaning towards polishing the android syncpt stuff (currently in
> staging). But in any case I _really_ want to avoid that we end up with
> multiple different and incompatible explicit fencing interfaces on
> linux.

I agree, and I'll say it stronger than that, we WILL NOT have different
and incompatible fencing interfaces in the kernel.  That way lies
madness.

John, take a look at what is now in linux-next, it should provide what
you need here, right?

thanks,

greg k-h

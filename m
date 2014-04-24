Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089AbaDXLET (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 07:04:19 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:47868 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753907AbaDXLEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 07:04:15 -0400
Date: Thu, 24 Apr 2014 12:03:21 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Steve Capper <steve.capper@linaro.org>
Cc: Will Deacon <will.deacon@arm.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "robherring2@gmail.com" <robherring2@gmail.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "gerald.schaefer@de.ibm.com" <gerald.schaefer@de.ibm.com>
Subject: Re: [PATCH V2 0/5] Huge pages for short descriptors on ARM
Message-ID: <20140424110321.GN26756@n2100.arm.linux.org.uk>
References: <1397648803-15961-1-git-send-email-steve.capper@linaro.org> <20140424102229.GA28014@linaro.org> <20140424103639.GC19564@arm.com> <20140424104232.GK26756@n2100.arm.linux.org.uk> <CAPvkgC3P8iZp5nECiGHdeGzRwmdh=ouiAREqKwk1tYzZxHTWvg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPvkgC3P8iZp5nECiGHdeGzRwmdh=ouiAREqKwk1tYzZxHTWvg@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 11:55:56AM +0100, Steve Capper wrote:
> On 24 April 2014 11:42, Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> > On Thu, Apr 24, 2014 at 11:36:39AM +0100, Will Deacon wrote:
> >> I guess I'm after some commitment that this is (a) useful to somebody and
> >> (b) going to be tested regularly, otherwise it will go the way of things
> >> like big-endian, where we end up carrying around code which is broken more
> >> often than not (although big-endian is more self-contained).
> >
> > It may be something worth considering adding to my nightly builder/boot
> > testing, but I suspect that's impractical as it probably requires a BE
> > userspace, which would then mean that the platform can't boot LE.
> >
> > I suspect that we will just have to rely on BE users staying around and
> > reporting problems when they occur.
> 
> The huge page support is for standard LE, I think Will was saying that
> this will be like BE if no-one uses it.

We're not saying that.

What we're asking is this: *Who* is using hugepages today?

What we're then doing is comparing it to the situation we have today with
BE, where BE support is *always* getting broken because no one in the main
community tests it - not even a build test, nor a boot test which would
be required to find the problems that (for example) cropped up in the
last merge window.

> It's somewhat unfair to compare huge pages on short descriptors with
> BE. For a start, the userspace that works with LPAE will work on the
> short-descriptor kernel too.

That sounds good, but the question is how does this get tested by
facilities such as my build/boot system, or Olof/Kevin's system?
Without that, it will find itself in exactly the same situation that
BE is in, where problems aren't found until after updates are merged
into Linus' tree.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933023AbaBUQbf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 11:31:35 -0500
Received: from plane.gmane.org ([80.91.229.3]:46093 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932264AbaBUQbe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 11:31:34 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Grant Edwards <grant.b.edwards@gmail.com>
Subject: Re: locking changes in tty broke low latency feature
Date: Fri, 21 Feb 2014 16:31:03 +0000 (UTC)
Message-ID: <le7v07$9gn$1@ger.gmane.org>
References: <20140218093829.GC1741@redhat.com>
 <5303DABD.9000302@hurleysoftware.com> <20140219130308.GC1851@redhat.com>
 <le2nmd$p1$1@ger.gmane.org> <5304EC33.5040502@hurleysoftware.com>
 <20140219191717.486ac4d0@alan.etchedpixels.co.uk>
 <53051276.2070601@hurleysoftware.com>
 <20140219214242.406e705b@alan.etchedpixels.co.uk>
 <5305664C.7080701@hurleysoftware.com>
 <20140221153946.2bda2ef0@alan.etchedpixels.co.uk>
 <53077799.6030700@hurleysoftware.com>
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: c-24-118-110-103.hsd1.mn.comcast.net
User-Agent: slrn/1.0.1 (Linux)
Cc: linux-serial@vger.kernel.org, linux-rt-users@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-02-21, Peter Hurley <peter@hurleysoftware.com> wrote:

> I think the consensus is to leave the low_latency facility in, but
> remove it's connection to the tty buffers.
>
> If the known-to-be-already-in-non-interrupt-context drivers want,
> I can add a different function for executing flush_to_ldisc()
> directly. But I don't want to do that without a use-case and test
> subject.

Three of the drivers I maintain have modes where they handle all rx
data in non-interrupt contexts, but I'm not convinced (or even
suspicious) that there would be any noticeable benefit from such a
function.  If, at some point in the future, it becomes apparent that
there is "too much latency" in certain cases then perhaps it can be
looked at again -- but I think doing it now is premature optimization.
That said, all things being equal, it would be nice to avoid anything
that would make such an addition impossible in the future.

>> First question though comes before all of this - and that is do we need
>> low_latency at all any more or is the current scheduling logic now good
>> enough to do the job anyway.
>
> Right.
>
> Based on my recent test, I think low_latency doesn't need to be a
> knob for the tty core.

I Agree: there doesn't seem to be any evidence that it's needed by the
tty/ldisc layer.

> Drivers can continue to use it to mess with their rx fifo settings
> and such like.

Excellent.  One of my serial_core drivers still has (in it's default
configuration) 10ms of latency that I can choose to eliminate on a
per-port bases (at the cost of extra CPU cycles) when the low_latency
flag is set.

> I plan on sending Greg a patch to do just that, probably this weekend.

Cool.  Thanks much for your attention to this.

-- 
Grant


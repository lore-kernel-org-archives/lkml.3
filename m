Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757959Ab3CULnW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 07:43:22 -0400
Received: from mail-ea0-f178.google.com ([209.85.215.178]:60487 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932344Ab3CULnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 07:43:15 -0400
Date: Thu, 21 Mar 2013 12:43:08 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Michal Marek <mmarek@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Tejun Heo <tj@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org
Subject: Re: [PATCH RFC 1/5] kconfig: implement weak reverse-dependencies
Message-ID: <20130321114307.GA6716@netboy.at.omicron.at>
References: <20130321082256.21557.68351.stgit@zurg>
 <20130321102200.GB2341@netboy.at.omicron.at>
 <514AE9A3.5090209@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <514AE9A3.5090209@openvz.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 03:06:11PM +0400, Konstantin Khlebnikov wrote:
> 
> As I see this technology requires special dedicated server in the local
> network, thus it's unusable in most situations. But it starts working
> without any actions from the user (please fix me if I'm wrong).

Perhaps you don't have a very clear picture of how this PTP stuff
works. Even when the PHC and time stamping code is compiled in, it
does *not* start working unless the end user turns it on, via the
SIOCSHWTSTAMP and SO_TIMESTAMPING options.

See: Documentation/networking/timestamping.txt
     Documentation/ptp/ptp.txt
 
> Thus this code enables some rarely used parts of hardware.
> After seeing several weird bugs in ethernet devices I prefer to
> keep unused/unwanted features off.

Just compiling drivers into kernel does not really change the behavior
of the hardware. The only drawback I know of is that it adds (minimal)
overhead into the packet processing paths, but that is a software
issue.

I don't mean to start a big discussion here. The question of whether
to have PHC support a compile time option should be discussed on the
netdev list (added on CC just in case).

Thanks,
Richard



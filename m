Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756504AbaCYSBU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 14:01:20 -0400
Received: from asavdk3.altibox.net ([109.247.116.14]:48141 "EHLO
	asavdk3.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755990AbaCYSBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 14:01:15 -0400
Date: Tue, 25 Mar 2014 19:01:10 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        linux-kbuild@vger.kernel.org
Subject: Re: [RFC] dma-buf: Implement test module
Message-ID: <20140325180110.GA3532@ravnborg.org>
References: <1386858989-1487-1-git-send-email-treding@nvidia.com>
 <20131212144210.GA1527@ulmo.nvidia.com>
 <20131213020258.GC13333@kroah.com>
 <20140325161722.GA23842@ulmo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140325161722.GA23842@ulmo>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> There are two things that don't work too well with this. First this
> causes the build to break if the build machine doesn't have the new
> public header (include/uapi/linux/dma-buf.h) installed yet. So the only
> way to make this work would be by building the kernel once with SAMPLES
> disabled, install the headers and then build again with SAMPLES enabled.
> Which really isn't very nice.
> 
> One other option that I've tried is to modify the include path so that
> the test program would get the in-tree copy of the public header file,
> but that didn't build properly either because the header files aren't
> properly sanitized and therefore the compiler complains about it
> (include/uapi/linux/types.h).
> 
> One other disadvantage of carrying the sample program in the tree is
> that there's only infrastructure to build programs natively on the build
> machine. That's somewhat unfortunate because if you want to run the test
> program on a different architecture you have to either compile the
> kernel natively on that architecture (which isn't very practical on many
> embedded devices) or cross-compile manually.
> 
> I think a much nicer solution would be to add infrastructure to cross-
> compile these test programs, so that they end up being built for the
> same architecture as the kernel image (i.e. using CROSS_COMPILE).
> 
> Adding Michal and the linux-kbuild mailing list, perhaps this has been
> discussed before, or maybe somebody has a better idea on how to solve
> this.
I actually looked into this some time ago.
May try to dust off the patch.
IIRC the kernel provided headers were used for building - not the one installed on the machine.
And crosscompile were supported.

	Sam

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300Ab3KKTdR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 14:33:17 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42620 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755270Ab3KKTdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 14:33:00 -0500
Date: Mon, 11 Nov 2013 19:32:36 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jonathan Austin <jonathan.austin@arm.com>
Cc: Ming Lei <tom.leiming@gmail.com>, Michal Marek <mmarek@suse.cz>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Axel Lin <axel.lin@ingics.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: kernel BUG at kernel/kallsyms.c:222!
Message-ID: <20131111193236.GB16735@n2100.arm.linux.org.uk>
References: <CACVXFVNHryPXy2NQhPwXkoCeLUXQSgrWmgBkMNtGD_=X_62_5Q@mail.gmail.com> <CAFRkauDGiy3yZOwKFWMEJvYUe0OoXMEZHKaxogZHdgzMxexdHA@mail.gmail.com> <CACVXFVMAnewCkSNNke3kf1-yO+JCc_HBRp8iaLBPJ+14G79Haw@mail.gmail.com> <87y54vzszo.fsf@rustcorp.com.au> <CAFRkauBYUq3UAjqLvkuDVEz5BVyDpC0DuVRGTe4K+kcoCX17GA@mail.gmail.com> <CACVXFVMvvG1unnR0rsmBMdp9p19Q3JRbURxZF-UWxvrThDPKTw@mail.gmail.com> <CAFRkauCW3FDSuh4t0gvmSWH1m0+qaG0XSoBxmk30Wq1FMy7iFw@mail.gmail.com> <CACVXFVMzOzD+D-MQCUBvC80d4zS-TJfcucKuUvzerGs6gT1fEg@mail.gmail.com> <CACVXFVOnVXcVdRCm=OfPjpvvWCiXi8GRV+9ViOGmSZ3tTf6WDg@mail.gmail.com> <528110B1.4060402@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <528110B1.4060402@arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 11, 2013 at 05:15:29PM +0000, Jonathan Austin wrote:
> I've tested the patch below and it solves the ARM side of things - so
> gives you an option other than a complete revert. Happy to put this in to
> RMK's patch system if you'd prefer not to have to revert and he's happy
> with the patch.

I think this is the right solution because it then means that this symbol
has the same meaning whether on MMU or !MMU - and getting rid of these
kinds of gratuitous variances are the only way that !MMU is going to
become less fragile.

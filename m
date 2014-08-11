Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517AbaHKNaf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 09:30:35 -0400
Received: from verein.lst.de ([213.95.11.211]:41470 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751506AbaHKNae (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 09:30:34 -0400
Date: Mon, 11 Aug 2014 15:30:30 +0200
From: Torsten Duwe <duwe@lst.de>
To: Amit Shah <amit.shah@redhat.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, jgarzik@bitpay.com,
        Virtualization List <virtualization@lists.linux-foundation.org>,
        Amos Kong <akong@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
        linux-kernel@vger.kernel.org,
        Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
Subject: Re: [PATCH 1/2] rngd: add udev rule to source from hwrng if
	virtio-rng present
Message-ID: <20140811133030.GA27247@lst.de>
References: <cover.1407416628.git.amit.shah@redhat.com> <dd2ddb8458e5ab5cffceb7fac2e3f71e9e2197f3.1407416628.git.amit.shah@redhat.com> <53E3D3FF.70707@linux.intel.com> <20140808090715.GG14400@grmbl.mre> <53E54533.8030109@linux.intel.com> <20140811071527.GB4184@grmbl.mre>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140811071527.GB4184@grmbl.mre>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2014 at 12:45:27PM +0530, Amit Shah wrote:
> 
> What's the suggested value for rng->quality, though, for virtio-rng
> that I can use to ensure the kthread starts?
> 
> Should I use the 700 (70%) as proposed in the original patchset?  I'm
> not exactly sure how that value will be used as well..

There is no such thing as a suggested value, every number is wrong
to some degree.  The quality is an estimation of how random your
source really is; it's a property of your hardware. If the device is
virtual you're in trouble ;-)

Either you have a way to query the underlying real hardware, or
you do your whitening and entropy estimation in the backend driver --
then you can claim 100%.

	Torsten


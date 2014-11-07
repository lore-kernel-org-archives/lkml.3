Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593AbaKGNBa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 08:01:30 -0500
Received: from dotsec.net ([62.75.224.215]:56969 "EHLO styx.dotsec.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752563AbaKGNB1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 08:01:27 -0500
Date: Fri, 7 Nov 2014 13:59:31 +0100
From: Alban <albeu@free.fr>
To: Mark Rutland <mark.rutland@arm.com>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Alban Bedel <albeu@free.fr>
Subject: Re: [PATCH] OF: Add support for built in FDT blob
Message-ID: <20141107135931.376caf98@tock>
In-Reply-To: <20141107120933.GA5487@leverpostej>
References: <1415358849-25879-1-git-send-email-albeu@free.fr>
	<20141107120933.GA5487@leverpostej>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SA-Score: -1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Nov 2014 12:09:33 +0000
Mark Rutland <mark.rutland@arm.com> wrote:

> Hi,
> 
> On Fri, Nov 07, 2014 at 11:14:09AM +0000, Alban Bedel wrote:
> > Allow embedding an FDT blob in the kernel image, this is mostly
> > useful to run new kernels on boards with old bootloaders.
> 
> I am very much not keen on embedding a DTB within a kernel. It's far
> nicer for the two to remain separate blobs, with a small shim to set
> up the DTB address.
> 
> On ARM we have appended DTB for this purpose, which is at least better
> than embedding the DT inside of the kernel.

I looked at that but that seemed quiet complicated to implement, not to
mention that it needed quiet a lot of arch specific code. On the other
hand having the DTB built in like this was trivial and would be portable
to every architecture, so that seemed like the best way to me.

> What architecture and bootloader are you using that necessitate this?

MIPS with an antic u-boot version patched by the board vendor to use
some non standard image format. Updating the boot loader is currently
not an option because of the lack of documentation for the board/SoC.

Alban

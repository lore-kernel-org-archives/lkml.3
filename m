Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548Ab3AUWJ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 17:09:56 -0500
Received: from gate.crashing.org ([63.228.1.57]:51479 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751287Ab3AUWJy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 17:09:54 -0500
Message-ID: <1358806170.6868.0.camel@pasglop>
Subject: Re: Query on I/O accessors used by Xilinx SystemACE Driver
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Alexey Brodkin <Alexey.Brodkin@synopsys.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michal Simek <monstr@monstr.eu>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 22 Jan 2013 09:09:30 +1100
In-Reply-To: <50FD40B3.804@synopsys.com>
References: <50FD40B3.804@synopsys.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-01-21 at 18:50 +0530, Vineet Gupta wrote:
> I'm not an expert in that driver or the specific needs of those accessors on
> respective arches, but was wondering, if it would be possible to convert the
> driver to use the vanilla IO accessors (read{b,w,l}. Microblaze at least,  seem to
> be defining them as straight wrappers over the standard raw accessors.
> 
> Ben, Geert could you please comment ?

If your HW is little-endian, then by all means use the standard accessors, either
readb,w,l or the iomap.h ones (ioread*)

Cheers,
Ben.



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751330AbaKXFTj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 00:19:39 -0500
Received: from gate.crashing.org ([63.228.1.57]:52709 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750835AbaKXFTh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 00:19:37 -0500
Message-ID: <1416806356.4998.18.camel@kernel.crashing.org>
Subject: Re: linuxppc-dev list <linuxppc-dev@ozlabs.org>
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        Alex Deucher <alexdeucher@gmail.com>, Takashi Iwai <tiwai@suse.de>
Date: Mon, 24 Nov 2014 16:19:16 +1100
In-Reply-To: <1416805719.4998.15.camel@kernel.crashing.org>
References: <1416805719.4998.15.camel@kernel.crashing.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-11-24 at 16:08 +1100, Benjamin Herrenschmidt wrote:
> Hi Linus !
> 
> This series fix a nasty issue with radeon adapters on powerpc servers,
> it's all CC'ed stable and has the relevant maintainers ack's/reviews.

Hrm... git request-pull can't find the commit on the server (it's been
quite a while now, maybe some mirroring issue), so didn't put the
branch name in properly.

The branch name is "merge", ie:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

Cheers
Ben.

> Basically, some (radeon) adapters have issues with MSI addresses above
> 1T (only support 40-bits). We had powerpc specific quirk but it only
> listed a specific revision of an adapter that we shipped with our
> machines and didn't properly handle the audio function which some distros
> enable nowadays.
> 
> So we made the quirk generic and fixed both the graphic and audio drivers
> properly to use it.
> 
> Without that, ppc64 server machines will crash at boot with a radeon adapter.
> 
> Note: This has been brewing for a while, it just needed a last respin which
> got delayed due to us moving ozlabs to a new location in town and other such
> things taking priority.
> 
> Cheers,
> Ben.



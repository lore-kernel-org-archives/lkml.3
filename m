Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932724Ab3FEVS5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 17:18:57 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36743 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932584Ab3FEVSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:18:54 -0400
Date: Wed, 5 Jun 2013 22:16:37 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: "jonsmirl@gmail.com" <jonsmirl@gmail.com>,
        devicetree-discuss <devicetree-discuss@ozlabs.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        debian-arm@lists.debian.org,
        ARM Linux Mailing List <linux-arm-kernel@lists.infradead.org>,
        Luke Kenneth Casson Leighton <lkcl@lkcl.net>,
        Linux on small ARM machines 
	<arm-netbook@lists.phcomp.co.uk>,
        debian-release@lists.debian.org, debian-kernel@lists.debian.org
Subject: Re: getting allwinner SoC support upstream (was Re: Uploading
	linux (3.9.4-1))
Message-ID: <20130605211637.GH18614@n2100.arm.linux.org.uk>
References: <CAPweEDx3mAy40BZrzrKPRbvg7vKMj7KevDQ3m_v4p6Yo50eSGg@mail.gmail.com> <CAKON4OxDD5orX2w-_+d5kawTGXbE3KKj2QLERo9m7=NiUSXhgQ@mail.gmail.com> <51AFA6DD.3000202@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51AFA6DD.3000202@wwwdotorg.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 05, 2013 at 03:00:13PM -0600, Stephen Warren wrote:
> 2) Having U-Boot itself read a DT and configure itself, just like the
> kernel does. This is relatively new, and only supported by a few boards
> (all Tegra to some extent, and a couple each Samsung Exynos and Xilinx
> boards). I suspect/guess this is the kind of thing that Luke was
> referring to re: U-Boot fex integration.

Reading what I have of this thread, this is just another case of
$company runs of and does their own unique way of doing something,
which is in a totally different direction from that path chosen by
Linux kernel developers, and Linux kernel developers are _expected_
to roll over and accept $company's unique way of doing it.

$company could have assisted with the DT effort, helping to sort out
the common arch issues (which haven't been all that much), converting
drivers to DT and such like.  But no, instead they've gone off and
created their own thing.

I wonder how many more of these cases there needs to be before people
get the message that Linux kernel developers *do* *not* like this
behaviour, and if you do this, then chances are you're going to be
stuck with having code which isn't able to be merged into mainline.

And I don't buy the argument that we were still sorting out DT.  DT has
been well defined for many many years before we started using it on ARM.
It has been used for years on both PowerPC and Sparc architectures to
describe their hardware, and all of the DT infrastructure was already
present in the kernel.  What was left for us were:

* converting our platform-data based drivers to use data from DT.
* come up with ways of dealing with SoC issues such as clock
  representation, pin muxing and such like in DT.

But no... all that had to be created in this custom fex stuff which now
presents a barrier with getting support for something merged.

And somehow people make out that this is _our_ problem...

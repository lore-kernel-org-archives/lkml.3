Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861Ab3JVOYd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 10:24:33 -0400
Received: from smtp.citrix.com ([66.165.176.89]:41410 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751688Ab3JVOYc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 10:24:32 -0400
X-IronPort-AV: E=Sophos;i="4.93,548,1378857600"; 
   d="scan'208";a="66043285"
Message-ID: <1382451868.18283.21.camel@hastur.hellion.org.uk>
Subject: Re: EFI and multiboot2 devlopment work for Xen
From: Ian Campbell <ian.campbell@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Jan Beulich <JBeulich@suse.com>, <ross.philipson@citrix.com>,
        <stefano.stabellini@eu.citrix.com>, <grub-devel@gnu.org>,
        <david.woodhouse@intel.com>, <richard.l.maliszewski@intel.com>,
        <xen-devel@lists.xen.org>, <boris.ostrovsky@oracle.com>,
        Daniel Kiper <daniel.kiper@oracle.com>,
        Peter Jones <pjones@redhat.com>, <linux-kernel@vger.kernel.org>,
        <keir@xen.org>
Date: Tue, 22 Oct 2013 15:24:28 +0100
In-Reply-To: <20131022140947.GA17829@phenom.dumpdata.com>
References: <20131021125756.GA3626@debian70-amd64.local.net-space.pl>
	 <20131021135437.GD1283@fenchurch.internal.datastacks.com>
	 <20131021185758.GD3626@debian70-amd64.local.net-space.pl>
	 <1382433990.1657.66.camel@hastur.hellion.org.uk>
	 <5266620602000078000FCA48@nat28.tlf.novell.com>
	 <1382435127.1657.70.camel@hastur.hellion.org.uk>
	 <526668A502000078000FCA7B@nat28.tlf.novell.com>
	 <20131022134252.GA27302@phenom.dumpdata.com>
	 <1382449985.18283.12.camel@hastur.hellion.org.uk>
	 <20131022140947.GA17829@phenom.dumpdata.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-4+b1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-10-22 at 10:09 -0400, Konrad Rzeszutek Wilk wrote:

> So it can be booted the same way as xen.efi. But my understanding is
> that folks prefer a bootloader instead of loading the bzImage in an
> NVRAM of a platform with pre-set parameters. Hence that mechanism
> is not used by the majority of users.

My understanding is that they prefer a bootloader which can launch Linux
as a PE/COFF image, i.e. the linuxefi thing.

> Instead the majority of users would like to use a bootloader, like
> GRUB2. And there are certain restrictions - if you launch from it
> an PE/COFF application GRUB2 will call ExitBootServices. But if
> you launch the Linux image (so using the linuxefi), it WILL NOT
> call ExitBootServices.

"linuxefi" won't call ExitBootServices but it will launch as a PE/COFF
application not as a "Linux image", that's right isn't it? I think that
is the whole point of it.

The "launch as a Linux image" grub command is called just "linux" (and
"kernel" may be a synonym).

> But I say that (about ExitBootServices) - and I can't find it in
> the GRUB2 code, so perhaps I am mistaken.

linuxefi isn't in the upstream grub2 tree -- all the distros are
carrying it as a patch. So if you are grepping upstream you won't find
it.

Ian.


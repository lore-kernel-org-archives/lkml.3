Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271Ab3JVOTk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 10:19:40 -0400
Received: from mga02.intel.com ([134.134.136.20]:64453 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752319Ab3JVOTj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 10:19:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="396766084"
From: "Woodhouse, David" <david.woodhouse@intel.com>
To: Ian Campbell <ian.campbell@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Jan Beulich <JBeulich@suse.com>,
        "ross.philipson@citrix.com" <ross.philipson@citrix.com>,
        "stefano.stabellini@eu.citrix.com" <stefano.stabellini@eu.citrix.com>,
        "grub-devel@gnu.org" <grub-devel@gnu.org>,
        "Maliszewski, Richard L" <richard.l.maliszewski@intel.com>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
        Daniel Kiper <daniel.kiper@oracle.com>,
        "Peter Jones" <pjones@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "keir@xen.org" <keir@xen.org>
Subject: Re: EFI and multiboot2 devlopment work for Xen
Thread-Topic: EFI and multiboot2 devlopment work for Xen
Thread-Index: AQHOzl025cADmYb3WkedBDuSo7z4BJn/HKwAgABUwACAAPKqAIAAAVcAgAAD9ICAAAPxgIAAPmUAgAAC24CAABf4ug==
Date: Tue, 22 Oct 2013 14:18:52 +0000
Message-ID: <7gf8ufyngxh0extp8a0ifnrp.1382451526144@email.android.com>
References: <20131021125756.GA3626@debian70-amd64.local.net-space.pl>
	 <20131021135437.GD1283@fenchurch.internal.datastacks.com>
	 <20131021185758.GD3626@debian70-amd64.local.net-space.pl>
	 <1382433990.1657.66.camel@hastur.hellion.org.uk>
	 <5266620602000078000FCA48@nat28.tlf.novell.com>
	 <1382435127.1657.70.camel@hastur.hellion.org.uk>
	 <526668A502000078000FCA7B@nat28.tlf.novell.com>
	 <20131022134252.GA27302@phenom.dumpdata.com>,<1382449985.18283.12.camel@hastur.hellion.org.uk>
In-Reply-To: <1382449985.18283.12.camel@hastur.hellion.org.uk>
Reply-To: "Woodhouse, David" <david.woodhouse@intel.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I wonder why Linux can't make the EFI calls to fetch them itself?

It can. It does. It prefers to. This is what the "EFI boot stub" is all about. But grub2 is crack-inspired and likes to do all kinds of crap that it shouldn't. It is an exercise in complexity for complexity's sake. The 'linuxefi' method is actually not really Linux-specific; it just boots an EFI executable (which the bzImage *is* when compiled that way).

Seriously, forget bootloaders (especially grub2) and make it a COFF/PE executable.  Then everything should just work, including Secure Boot etc.

And bootloaders can still load that, of course.

--
dwmw2
(Apologies for HTML and top-posting; Android mailer is broken.)



-------- Original message --------
From: Ian Campbell <ian.campbell@citrix.com>
Date: 22/10/2013 2:53 PM (GMT+00:00)
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Jan Beulich <JBeulich@suse.com>,ross.philipson@citrix.com,stefano.stabellini@eu.citrix.com,grub-devel@gnu.org,"Woodhouse, David" <david.woodhouse@intel.com>,"Maliszewski, Richard L" <richard.l.maliszewski@intel.com>,xen-devel@lists.xen.org,boris.ostrovsky@oracle.com,Daniel Kiper <daniel.kiper@oracle.com>,Peter Jones <pjones@redhat.com>,linux-kernel@vger.kernel.org,keir@xen.org
Subject: Re: EFI and multiboot2 devlopment work for Xen


On Tue, 2013-10-22 at 09:42 -0400, Konrad Rzeszutek Wilk wrote:

> Looking at the Fedora GRUB2 source, the 'struct linux_kernel_header' is defined
> in the linux/Documentation/x86/boot.txt and hpa is pretty strict
> about making it backwards compatible. It also seems to support Xen!
>
> (Interestingly enough we do have this structure in the code: see
> setup_header in arch/x86/bzimage.c)

There will be another usage in tools/libxc/...bzimage too

FWIW I think we only use this stuff for the magic number/version and the
payload_offset/length fields, which we do in order to extract the
payload (ELF file) for booting dom0 and domU. It's not AFAIK used for
booting Xen itself or lets say, that's not why I added it ;-)).

> Which in the GRUB2 is being constructed by parsing the EFI
> data structures. But Linux concentrates on the EFI parts and mostly
> ignores the rest. So this is more about passing those EFI values
> downstream.

I wonder why Linux can't make the EFI calls to fetch them itself?

Ian.


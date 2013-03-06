Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644Ab3CFTv6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 14:51:58 -0500
Received: from smtprelay-h31.telenor.se ([213.150.131.4]:58372 "EHLO
	smtprelay-h31.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754417Ab3CFTv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 14:51:57 -0500
X-SENDER-IP: [85.230.168.206]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah9WAA6eN1FV5qjOPGdsb2JhbABEh1wBvGUDAYFZFwMBAQEBODSCKgEBBAE6HCMQCAMhJQ8FJQoaiCAKCLw0BBWNdoEBB4JfYQOWSoYIjXI
X-IronPort-AV: E=Sophos;i="4.84,797,1355094000"; 
   d="scan'208";a="287624945"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Wed, 6 Mar 2013 20:54:57 +0100
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Yinghai Lu <yinghai@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.9-rc1
Message-ID: <20130306195457.GA449@polaris.bitmath.org>
References: <CA+55aFx0HcOXKpxmZzM5jcbAaOroxafomX5ggMFV4A=py1qh-Q@mail.gmail.com>
 <20130306080642.GA535@polaris.bitmath.org>
 <51370990.5040508@linux.intel.com>
 <20130306100743.GA407@polaris.bitmath.org>
 <CAE9FiQXT4O3GOzm_OoFJG=vc=5LpfBkTEbAO_3xjerBGS_Gy=A@mail.gmail.com>
 <20130306193612.GA513@polaris.bitmath.org>
 <51379A4F.4020200@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51379A4F.4020200@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> Can you check bootloader like grub.efi ?
> > 
> > I checked, same story. I tried without EFI_STUB, no joy. I ran with
> > and without nouveau, just in case. Without the patch, everything
> > works. With the patch, nothing works, and no output at all.
> > 
> > With a bit of luck, I could maybe get the first lines of output using
> > grub.efi, but frankly I cannot remember if that ever worked on this
> > machine.
> > 
> 
> A simpler one is efilinux:
> 
> https://github.com/mfleming/efilinux

Sadly, that one does not seem to boot at all on this machine (picked
it up in arch linux, so obvisouly it works for someone).

I have started applying portions of the patch to see what
happens. Adding early_alloc_pgt_buf() in setup_arch() seems to work,
which limits the problem to the actual init function.

Henrik

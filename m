Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751127AbaFWAJB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 20:09:01 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:60456 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750785AbaFWAJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 20:09:00 -0400
X-Sasl-enc: rTbUHULdmf97+guD3u73XRwLvQunpSyj2MSCAqF4s97h 1403482138
Date: Sun, 22 Jun 2014 21:08:47 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guido =?iso-8859-1?Q?Mart=EDnez?= <guido@vanguardiasur.com.ar>
Subject: Re: [PATCH] init: Introduce 'noinitramfs' kernel parameter
Message-ID: <20140623000847.GA31648@khazad-dum.debian.net>
References: <1403415685-21455-1-git-send-email-ezequiel@vanguardiasur.com.ar>
 <20140622145329.GA19936@khazad-dum.debian.net>
 <20140622212959.GA766@arch.cereza>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140622212959.GA766@arch.cereza>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Jun 2014, Ezequiel Garcia wrote:
> On 22 Jun 11:53 AM, Henrique de Moraes Holschuh wrote:
> > On Sun, 22 Jun 2014, Ezequiel Garcia wrote:
> > > This commit adds a new kernel parameter to provide such option, following the
> > > naming of the current 'initrd' which serves a similar purpose, for an initial
> > > RAM disk.
> > 
> > How does it interact with the early initramfs?
> > 
> > Maybe we should have the options to ignore both, ignore just the early
> > initramfs (to skip microcode updates and ACPI table updates), and ignore
> > just the main initramfs?
> > 
> 
> I must admit I don't have much experience with any "earlier" initramfs.
> Maybe you can point me at some links about this?

Search for kernel code that includes the linux/earlycpio.h header file.  The
implementation is at lib/earlycpio.c.

I am sorry I don't have a better reference to point you to.

> Unless I'm missing something, this "early" initramfs is an userspace artifact
> in the construction of the initramfs, so the kernel has no way to distinguish

No, it is an uncompressed cpio archive which is parsed extremely early, for
critical system firmware (currently: processor microcode updates and ACPI
table overrides).

Documentation of its two current users is at:

Documentation/x86/early-microcode.txt
Documentation/acpi/initrd_table_override.txt

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752031AbaHaULl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 16:11:41 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:59605 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751235AbaHaULj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 16:11:39 -0400
X-Sasl-enc: PWyc6yXRFN6368tOib8FhUX71ENmpB4PGzKqOWlZEHkg 1409515898
Date: Sun, 31 Aug 2014 17:11:26 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@alien8.de>, Fenghua Yu <fenghua.yu@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: early microcode: how to disable at runtime?
Message-ID: <20140831201126.GB12628@khazad-dum.debian.net>
References: <20140809231911.GA4843@khazad-dum.debian.net>
 <20140831194548.GA12628@khazad-dum.debian.net>
 <54037C07.8060703@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54037C07.8060703@zytor.com>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 31 Aug 2014, H. Peter Anvin wrote:
> On 08/31/2014 12:45 PM, Henrique de Moraes Holschuh wrote:
> > Currently, there is no way to disable early microcode update at runtime.  If
> > an early initramfs with microcode update data is available, it will always
> > be used.
> > 
> > This can be a very big deal when things go wrong: it is hard for the regular
> > user to recover from an initramfs image that crashes the system, and the
> > early initramfs has no "disable" trigger.
> > 
> > In the general case, booting from rescue media will be required to fix the
> > system.
> > 
> > Unfortunately, the BSP microcode update is handled before early_param() is
> > available, so a kernel command line parameter to disable early microcode
> > updates for the BSP isn't easily possible.
> > 
> > Other than duplicating much of the code in parse_early_param/parse_args to
> > search for a "noearlymcu" parameter, is there any other way we could add a
> > disable switch for the early microcode update system?
> > 
> 
> Probably more like something more like arch/x86/boot/cmdline.c.  Maybe
> we could even make it sharable.

Looks like that would work, yes.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

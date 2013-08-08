Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934218Ab3HHKRi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 06:17:38 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:37727 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934193Ab3HHKRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 06:17:36 -0400
Date: Thu, 8 Aug 2013 11:17:30 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Andrew Fish <afish@apple.com>
Cc: edk2-devel@lists.sourceforge.net, Laszlo Ersek <lersek@redhat.com>,
        linux-efi@vger.kernel.org, Gleb Natapov <gleb@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Brian Richardson <brian.richardson@intel.com>,
        Colin Ian King <colin.king@canonical.com>
Subject: Re: [edk2] Corrupted EFI region
Message-ID: <20130808101730.GJ2515@console-pimps.org>
References: <51FFD5B0.9080000@redhat.com>
 <20130805164731.GG31845@pd.tnic>
 <52001896.1030509@redhat.com>
 <20130805220808.GC14067@pd.tnic>
 <20130806141036.GD14891@pd.tnic>
 <520116D1.2010000@redhat.com>
 <20130807151935.GJ17920@pd.tnic>
 <CCFD3CBD-62B0-4046-B96D-18CB1A815F72@apple.com>
 <20130807201908.GG2515@console-pimps.org>
 <D5982201-6DC4-469F-812A-74A8402ADEE9@apple.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D5982201-6DC4-469F-812A-74A8402ADEE9@apple.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 Aug, at 02:10:28PM, Andrew Fish wrote:
> Well the issue I see is I don't think OS X or Windows are doing this.
> So I'm guessing there is some unique thing beings done on the Linux
> side and we don't have good tests to catch bugs in the EFI
> implementations. If the Linux loader hides the bugs and we don't hit
> them with other operating systems they are never going to get fixed.
> It would be good if we could track down some of these issues and make
> a request for some tests that can help catch these issues. The tests
> would be part of UEFI.org, but since some of us play in both worlds we
> can forward the known issues to the UEFI test work group. 

I'm all for helping to develop tests that catch these kind of bugs.
What's the next step?

> Is it possible to have a switch to turn off the not required behavior
> (hiding EFI implementation bugs) so that bad platforms could be
> detected? This would be a good thing to try on platforms at the
> upcoming UEFI Plugfest hosted by the Linux Foundation and the UEFI
> Forum, so the bad behavior can be detected and the vendors can fix the
> issue. 

We don't tend to provide switches for the kernel to turn off workarounds
because users run the risk of inadvertently stopping their machines from
booting correctly. Also, because the major distributions will always
enable the workarounds, the kernel would need to be built manually to
see any kind of informative error message.

What we do have though is the Firmware Testsuite - fwts,

  https://wiki.ubuntu.com/Kernel/Reference/fwts

I know that Brian (Cc'd) has been doing some excellent advocacy work,
getting people at plugfetsts to run this testsuite which tests for
implementation bugs from within a Linux environment.

> PS Also maybe it would be possible to key this work around behavior on
> the EFI/UEFI version. So for example no work-around after UEFI v2.3.1?

That would really depend on who has seen this bug and on which
platforms. Is there a particular reason that mapping the boot services
regions as-is would cause problems?

-- 
Matt Fleming, Intel Open Source Technology Center

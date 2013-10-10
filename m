Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755146Ab3JJWmF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 18:42:05 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:33770 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751857Ab3JJWmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 18:42:02 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18a09QdlIMbsF+PiYYOd8h6
Date: Thu, 10 Oct 2013 15:41:57 -0700
From: Tony Lindgren <tony@atomide.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Prakash Manjunathappa <prakash.pm@ti.com>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        Linux-OMAP <linux-omap@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: Re: [PATCH 3/6] pinctrl: single: Prepare for supporting SoC
 specific features
Message-ID: <20131010224157.GJ29913@atomide.com>
References: <20131003054104.8941.88857.stgit@localhost>
 <20131003054218.8941.19273.stgit@localhost>
 <20131007173531.GX8949@atomide.com>
 <CACRpkdZ1CeSXJngo0gKpnag-=mT3FB-byJi3JSAWiS8hbHqBJA@mail.gmail.com>
 <20131009151015.GZ8313@atomide.com>
 <CACRpkdbX6RqP=ikap_4pq3BOuEt_7ZWv4JwS2NfhDn2up841Pg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdbX6RqP=ikap_4pq3BOuEt_7ZWv4JwS2NfhDn2up841Pg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Walleij <linus.walleij@linaro.org> [131010 08:43]:
> On Wed, Oct 9, 2013 at 5:10 PM, Tony Lindgren <tony@atomide.com> wrote:
> 
> > I was thinking I'll set up an immutable branch for the three
> > pinctrl patches against -rc4 then both you and I can merge
> > them in as needed. Does that work for you?
> 
> Hm it's fair enough to have them in your tree if they do
> not collide ... especially if you want to do some of my
> suggested follow-up moving the ioring handling down into
> pinctrl-single on top of that.

OK, the PRM changes will have to wait until omap3 is DT only,
probably not until v3.14.
 
> > I can also do a test merge with pinctrl/for-next also to make
> > sure there are no conflicts.
> 
> Sure, as long as that works you should be safe.

Seems to merge with no conflicts and build just fine. Here's
the signed tag for the three pinctrl-single patches for you
to pull in too in case you are planning to make some pinctrl
wide changes. Let's consider those commits immutable now, if
I need to fix something I will post them as separate patches.

Regards,

Tony



The following changes since commit d0e639c9e06d44e713170031fe05fb60ebe680af:

  Linux 3.12-rc4 (2013-10-06 14:00:20 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap tags/pinctrl-single-for-linus-for-v3.13-signed

for you to fetch changes up to dc7743aa3c49fabbc6dc9edbcf7df74d776ac32e:

  pinctrl: single: Add support for auxdata (2013-10-10 15:30:47 -0700)

----------------------------------------------------------------
Changes to pinctrl-single to allow handling the wake-up
interrupts that most omaps have in each pinctrl register.

As I need these merged also into the omap tree, it was
agreed that I set them up into a separate branch for
both pinctrl tree and linux-omap tree to merge as needed.

----------------------------------------------------------------
Tony Lindgren (3):
      pinctrl: single: Prepare for supporting SoC specific features
      pinctrl: single: Add support for wake-up interrupts
      pinctrl: single: Add support for auxdata

 .../devicetree/bindings/pinctrl/pinctrl-single.txt |  11 +
 drivers/pinctrl/pinctrl-single.c                   | 383 ++++++++++++++++++++-
 include/linux/platform_data/pinctrl-single.h       |  12 +
 3 files changed, 397 insertions(+), 9 deletions(-)
 create mode 100644 include/linux/platform_data/pinctrl-single.h

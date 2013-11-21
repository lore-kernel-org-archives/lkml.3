Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522Ab3KULnj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 06:43:39 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:47056 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754479Ab3KULng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 06:43:36 -0500
X-Sasl-enc: oQS+E/921CR25lZLMpHy7LYIDStp9O/qBLuS0YrKYzUK 1385034215
Date: Thu, 21 Nov 2013 09:43:32 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Jingoo Han <jg1.han@samsung.com>, "'Kyungmin Park'" <kmpark@infradead.org>,
        "'Henrique de Moraes Holschuh'" <ibm-acpi@hmh.eng.br>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kay@vrfy.org, "'Richard Purdie'" <rpurdie@rpsys.net>,
        ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH] video: backlight: Remove backlight sysfs uevent
Message-ID: <20131121114332.GA23710@khazad-dum.debian.net>
References: <20131111235700.GA29987@july>
 <002901cedf3c$a7e77a00$f7b66e00$%han@samsung.com>
 <20131112005628.GA2914@khazad-dum.debian.net>
 <1384990859.20536.4.camel@x230>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384990859.20536.4.camel@x230>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Nov 2013, Matthew Garrett wrote:
> On Mon, 2013-11-11 at 22:56 -0200, Henrique de Moraes Holschuh wrote:
> > On Tue, 12 Nov 2013, Jingoo Han wrote:
> > > 'thinkpad_acpi.c' uses the 'BACKLIGHT_UPDATE_SYSFS'.
> > > Henrique, can we remove it?
> > 
> > Can't you fix this by rate-limiting, or otherwise adding an attribute that
> > backlight devices should set when they need to supress change events?
> 
> It looks like this is just to force synchronisation to sysfs when using
> the /proc interface? In which case we should probably just kill
> the /proc interface.

Well, we can remove the thinkpad-acpi /proc interface as far as I'm
concerned, and that would do away with the use of BACKLIGHT_UPDATE_SYSFS by
thinkpad-acpi.  It is a major userspace ABI break, but removing everything
under /proc/acpi is one of the very few ABI breaks we actually have the
green light to do.

However, the patchset is not about this.

With this patchset applied, as far as I can tell anything that used to be
uevent-driven by the backlight class will break: when a process changes the
backlight using sysfs, other processes will not be notified of the change
anymore.  This patchset seems to break backlight uevent support in such a
way that basically renders the entire thing useless and you might as well
just remove uevent support entirely.

It is also an userspace ABI break, which we do not do lightly.

So, as far as I'm concerned, this patchset should be rejected in its present
form.  IMO, either one that preserves BACKLIGHT_UPDATE_SYSFS and fixes the
urgent issue, or one that removes uevent support entirely from the backlight
class should be proposed instead.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

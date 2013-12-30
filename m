Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932228Ab3L3UHF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 15:07:05 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:46197 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932204Ab3L3UHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 15:07:02 -0500
X-Sasl-enc: 7aLXfn1SKsarLLdi3Sl1/Kpw1904wUAqPCL9YDu5yQut 1388434020
Date: Mon, 30 Dec 2013 18:06:58 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Julian Andres Klode <jak@jak-linux.org>,
        Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        "open list:THINKPAD ACPI EXT..." 
	<ibm-acpi-devel@lists.sourceforge.net>,
        "open list:THINKPAD ACPI EXT..." 
	<platform-driver-x86@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] thinkpad_acpi: Add support for controlling charge
 thresholds
Message-ID: <20131230200658.GA1808@khazad-dum.debian.net>
References: <1384178195-12218-1-git-send-email-jak@jak-linux.org>
 <20131228211026.GA14725@jak-x230>
 <20131228221003.GA24911@khazad-dum.debian.net>
 <20131230132619.GA24241@jak-x230>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131230132619.GA24241@jak-x230>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Dec 2013, Julian Andres Klode wrote:
> I think that a more generic approach is a good idea, but
> I don't think creating a new power supply device would be the right

...

> We could extend the existing battery devices and then get paths like
> 	/sys/class/power_supply/BAT0/start_charge_thresh
> which looks `natural'. There is one problem with that approach, though:

I'm fine with extending battery devices, in fact I agree that it would be a
better place to add these attributes to.

> A ThinkPad supports multiple batteries: In my case, I could add a slice
> battery. But the ACPI driver only exposes a BAT0 device without a slice
> being attached (I assume a BAT1 will pop-up if you add a slice battery,

Thinkpad batteries are static, BAT1 is always BAT1 for the firmware,
regardless of whether BAT0 is present or not.  Their parameters can always
be set as well, since they're stored in the EC and not in the battery pack
uC.  And the EC doesn't care whether the battery is present or not.

> but can't test it, as I don't own one). This means that you can only
> configure the slice battery when it's plugged in. I don't know if its
> a good idea to work like this.

We could change the ACPI battery driver to optionally allow a platform
driver (or a dmi table) to order it to register batteries that are not
present at boot, and set that flag for thinkpads.

> Another problem is that I don't know any other systems supporting charge
> thresholds, and I don't want to dictate interfaces built for ThinkPads
> as a generic way. 

All SBS batteries support it, which means most notebooks do.  Whether they
expose it or not, and whether their platform drivers know about it or not in
order to expose these parameters to the kernel and to userspace, is a
separate issue.

Refer to: http://www.sbs-forum.org/

So yes, we can and should add these as generic *optional* parameters for
generic batteries.  How to best add it to the ACPI battery driver is
something to think about.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

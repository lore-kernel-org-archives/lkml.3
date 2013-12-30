Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932349Ab3L3V6s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 16:58:48 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:60447 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932330Ab3L3V6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 16:58:46 -0500
X-Sasl-enc: cbdyxi0yZgQjXntsphfnfx49ssKGqA/USceIQetTW2dL 1388440725
Date: Mon, 30 Dec 2013 19:58:43 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Julian Andres Klode <jak@jak-linux.org>,
        Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        "open list:THINKPAD ACPI EXT..." 
	<ibm-acpi-devel@lists.sourceforge.net>,
        "open list:THINKPAD ACPI EXT..." 
	<platform-driver-x86@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] thinkpad_acpi: Add support for controlling charge
 thresholds
Message-ID: <20131230215843.GB4938@khazad-dum.debian.net>
References: <1384178195-12218-1-git-send-email-jak@jak-linux.org>
 <1384178195-12218-2-git-send-email-jak@jak-linux.org>
 <20131230132915.GB24241@jak-x230>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131230132915.GB24241@jak-x230>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Dec 2013, Julian Andres Klode wrote:
> On Mon, Nov 11, 2013 at 02:56:30PM +0100, Julian Andres Klode wrote:
> > Add support for battery charge thresholds in new Sandy Bridge and Ivy Bridge
> > ThinkPads. Based on the unofficial documentation in tpacpi-bat.
> > 
> > The threshold files support the values '0' for the controller's default,
> > and 1-99 as percentages. Values outside of that range are rejected. The
> > behaviour of '0' might be confusing, especially for the stop case where
> > it basically seems to mean '100'.
> 
> Thinking more about this, it might make more sense to simply accept a 100
> value and not accept a 0 value in the stop case (I tried multiple times to
> write 100 to a stop_charge_thresh file, because that feels more natural).
> 
> Having a 0 mean 100% is just odd. So stop_charge_thresh should simply
> accepts integer values in the range [1, 100] (and start_charge_thresh
> should continue accept [0, 99], as 0 really means 0 there).

Indeed.  Just return EINVAL for a stop threshold of 0.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932562AbaDVOCH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 10:02:07 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:64153 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756231AbaDVOBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 10:01:55 -0400
Date: Tue, 22 Apr 2014 15:05:26 +0100
From: Leif Lindholm <leif.lindholm@linaro.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <robherring2@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linaro Patches <patches@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 0/3] of: dts: enable memory@0 quirk for PPC32 only
Message-ID: <20140422140526.GK5904@bivouac.eciton.net>
References: <1397756521-29387-1-git-send-email-leif.lindholm@linaro.org>
 <CAL_JsqL8B2ZY7ACXKX3J8VN5ukjKWuycgfDZpp4kYzBxg6BLmQ@mail.gmail.com>
 <20140418124821.GE5904@bivouac.eciton.net>
 <CAL_JsqKdFyhHfkcC1E9QuKjQTrXwoELYG+CFTpgf2-jqDvxGmA@mail.gmail.com>
 <20140422130829.CA29DC4042C@trevor.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140422130829.CA29DC4042C@trevor.secretlab.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 02:08:29PM +0100, Grant Likely wrote:
> > I would prefer to see a "WARN_ON(!IS_ENABLED(CONFIG_PPC32));" added here.
> 
> I completely agree.

OK. So do we keep this around on unaffected architectures in perpetuity?

Or can there be some cut-off date when the majority of DT-enabled
platforms can stop including this workaround which permits new incorrect
DTs to be implemented so long as they are incorrect in this particular
way?

> > Really, I would like to see quirks like this fixed up out of line from
> > the normal flow somewhat like how PCI quirks are handled. So in this
> > example, we would just add the missing property to the dtb for the
> > broken platform before doing the memory scan. That does then require
> > libfdt which is something I'm working on.
> 
> In fact, for Leif's purposes, I would rather have a flag when booting via
> UEFI, and make the kernel skip the memory node parsing if the UEFI
> memory map is available. Then the stub doesn't need to do any munging of
> the DTB at all.

The reason for me doing that is because we (including you) agreed at
the discussion held during LCU13 that this was the safest way of
preventing "mischief" like userland trying to read information from
/proc/device-tree...

/
    Leif

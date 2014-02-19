Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134AbaBSHeC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 02:34:02 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:33963 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbaBSHeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 02:34:00 -0500
Date: Wed, 19 Feb 2014 07:33:39 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Aaron Lu <aaron.lu@intel.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Oleksij Rempel <linux@rempel-privat.de>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH] drm/i915/opregion: work around buggy firmware that
 provides 8+ output devices
Message-ID: <20140219073339.GA30685@srcf.ucam.org>
References: <52FAE504.8020001@intel.com>
 <20140212103156.GC5298@nuc-i3427.alporthouse.com>
 <52FC8C01.1040002@intel.com>
 <20140213100814.GM14909@nuc-i3427.alporthouse.com>
 <CAKMK7uGN3Of2VU6_LsSLh041kkx4TrhyH0H8zvE-PRvOtzJgfg@mail.gmail.com>
 <53045DD1.5010406@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53045DD1.5010406@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 19, 2014 at 03:31:29PM +0800, Aaron Lu wrote:

> DID2 is in system memory region and has some assigned value like 0x400
> when we read it. For this case it is easy since there is only one output
> device that is of type LVDS so we can match it to connector of type eDP
> or LVDS, suppose there is only one such connector. But for output
> devices' whose _ADR has the value of 0x301, 0x302, etc. I have no idea
> how to match them up to the connectors of that type as we can't be sure
> the probe order we have used in i915 driver is the same as BIOS'.

Non-standard _ADR values are assigend by the GPU vendor, so Intel should 
be able to provide you with the correct interpretations.

-- 
Matthew Garrett | mjg59@srcf.ucam.org

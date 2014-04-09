Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934251AbaDISH2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 14:07:28 -0400
Received: from mga01.intel.com ([192.55.52.88]:20342 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933458AbaDISHW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 14:07:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,827,1389772800"; 
   d="scan'208";a="517689423"
Date: Wed, 9 Apr 2014 11:00:32 -0700
From: David Cohen <david.a.cohen@linux.intel.com>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: wim@iguana.be, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org
Subject: Re: [PATCH 2/2] x86: intel-mid: add watchdog platform code for
 Merrifield
Message-ID: <20140409180031.GA23460@psi-dev26.jf.intel.com>
References: <1396990744-10695-1-git-send-email-david.a.cohen@linux.intel.com>
 <1396990744-10695-3-git-send-email-david.a.cohen@linux.intel.com>
 <20140409134223.6444a598@alan.etchedpixels.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140409134223.6444a598@alan.etchedpixels.co.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2014 at 01:42:23PM +0100, One Thousand Gnomes wrote:
> On Tue,  8 Apr 2014 13:59:04 -0700
> David Cohen <david.a.cohen@linux.intel.com> wrote:
> 
> > This patch adds platform code for Intel Merrifield.
> > Since the watchdog is not part of SFI table, we have no other option but
> > to manually register watchdog's platform device (argh!).
> 
> Before going too far down that path have you considered compiling in a
> devicetree instead ?

This is the only device missing from SFI table I am aware of.
The original implementation is to register the watchdog without a
device/driver match. i.e. directly from the init call. Then the init
call has a conditional check if it's Merrifield with
intel_mid_identify_cpu() to avoid it being registered in !Merrifield
platforms. But I want to lock this intel_mid_identify_cpu() inside
intel_mid platform code, since it's too ugly to stay inside drivers.

If we figure out there's more devices missing from SFI table, then we
could revisit here and consider another approach.

Br, David

> 
> Alan

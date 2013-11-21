Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455Ab3KUXiq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 18:38:46 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:38610 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753784Ab3KUXip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 18:38:45 -0500
Date: Thu, 21 Nov 2013 23:38:31 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: jerry.hoemann@hp.com
Cc: rob@landley.net, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, matt.fleming@intel.com, yinghai@kernel.org,
        akpm@linux-foundation.org, bp@suse.de, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        penberg@kernel.org, mingo.kernel.org@gmail.com, vgoyal@redhat.com
Subject: Re: [RFC v2 0/2] Early use of boot service memory
Message-ID: <20131121233831.GB32121@srcf.ucam.org>
References: <1385067686-73500-1-git-send-email-jerry.hoemann@hp.com>
 <20131121230744.GA31592@srcf.ucam.org>
 <20131121233104.GF1106@anatevka.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131121233104.GF1106@anatevka.fc.hp.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 21, 2013 at 04:31:04PM -0700, jerry.hoemann@hp.com wrote:

> I tried this back on 3.11 kernel and reserve_crashkernel after free of
> boot services failed.  I will admit to not digging in too deeply as to
> why it failed.

Hm. If the problem is fragmentation, then yeah, I can imagine this 
causing problems. In that case we could take a two-pass approach - find 
a gap that *will* be big enough, reserve everything that isn't currently 
reserved, and then reserve the rest after ExitBootServices()?

-- 
Matthew Garrett | mjg59@srcf.ucam.org

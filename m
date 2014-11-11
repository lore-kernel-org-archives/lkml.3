Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728AbaKKI4T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 03:56:19 -0500
Received: from mail.skyhub.de ([78.46.96.112]:44861 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751713AbaKKI4R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 03:56:17 -0500
Date: Tue, 11 Nov 2014 09:56:12 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>,
        Chen Yucong <slaoub@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/2] x86, mce, severity: extend the the mce_severity
 mechanism to handle UCNA/DEFERRED error
Message-ID: <20141111085612.GA31490@pd.tnic>
References: <1415410821-15063-1-git-send-email-slaoub@gmail.com>
 <1415410821-15063-2-git-send-email-slaoub@gmail.com>
 <546136C8.5060104@amd.com>
 <20141110221728.GA23419@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F329282FA@ORSMSX114.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F329282FA@ORSMSX114.amr.corp.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2014 at 11:32:12PM +0000, Luck, Tony wrote:
> But then I tested it ...
> 
> I injected a UC error to memory - then did a simple byte write to the target line.
> This resulted in two banks logging errors:
> 
> [  124.638045] poll: CPU54 saw ec00000000010092 in bank 7
> [  124.639006] poll: severity = 0
> [  124.647333] poll: CPU54 saw b800000000200179 in bank 3
> [  124.648322] poll: severity = 1
> 
> The bank 7 error reported as severity 0 because EN=0 ... so we took no action for it.

How come EN is 0? Bank7 error reporting is not enabled? Why? Or the
error injection thing doesn't do it?

> The bank 3 error got past that hurdle, then through the next BIT(8) set indicates a
> cache error. Fell at the last check because ADDRV=0.

I guess you could tweak the injection path to write in a default address
so that that check gets bypassed...

> I think the severity table entry for the "EN" check should have been skipped
> when calling from the CMCI handler. Then we would have seen severity=1
> from the bank 7 error.  It would have passed the other tests too (BIT(7) and
> ADDRV).

... but this is yet another example that this severity table is hard to
extend and handle.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--

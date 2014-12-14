Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157AbaLNPkL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 10:40:11 -0500
Received: from mga01.intel.com ([192.55.52.88]:43797 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750824AbaLNPkJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 10:40:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,575,1413270000"; 
   d="scan'208";a="637391094"
Date: Sun, 14 Dec 2014 17:40:03 +0200
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Stefan Berger <stefanb@linux.vnet.ibm.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        josh@joshtriplett.org, christophe.ricard@gmail.com,
        jason.gunthorpe@obsidianresearch.com, linux-api@vger.kernel.org,
        trousers-tech@lists.sourceforge.net,
        Will Arthur <will.c.arthur@intel.com>
Subject: Re: [PATCH v10 8/8] tpm: TPM 2.0 FIFO Interface
Message-ID: <20141214154003.GA13338@intel.com>
References: <1418413600-5400-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <1418413600-5400-9-git-send-email-jarkko.sakkinen@linux.intel.com>
 <548DA33A.4010300@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <548DA33A.4010300@linux.vnet.ibm.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 14, 2014 at 09:48:26AM -0500, Stefan Berger wrote:
> On 12/12/2014 02:46 PM, Jarkko Sakkinen wrote:
> >Detect TPM 2.0 by sending idempotent TPM 2.x command. Ordinals for
> >TPM 2.0 are higher than TPM 1.x commands so this should be fail-safe.
> >Using STS3 is unreliable because some chips just report 0xff and not
> >what the spec says.
> 
> TPM TIS 1.2 can report either 0xff or 0x00 for sts3 since that part of
> register was not defined for this version but only for a later version. So,
> unless the TIS 1.3 for TPM 2.0 is broken, it should report a bit _pattern_
> (not plain 0x00 or 0xff) that you could apply the suggested mask to and
> check then.

I propose this: lets keep the bit ugly but approach for now and when 
there are TPM2 FIFOs available in the market move to your workaround. 
I think that would be the most reasonable middle road here.

>     Stefan

/Jarkko

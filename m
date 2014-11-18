Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962AbaKRJ3U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 04:29:20 -0500
Received: from mga14.intel.com ([192.55.52.115]:45710 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752715AbaKRJ3R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 04:29:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="418045932"
Date: Tue, 18 Nov 2014 11:29:11 +0200
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        josh.triplett@intel.com, christophe.ricard@gmail.com,
        jason.gunthorpe@obsidianresearch.com, linux-api@vger.kernel.org,
        trousers-tech@lists.sourceforge.net
Subject: Re: [PATCH v7 06/10] tpm: fix: move sysfs attributes to the correct
 place.
Message-ID: <20141118092911.GA17459@intel.com>
References: <1415713513-16524-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <1415713513-16524-7-git-send-email-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415713513-16524-7-git-send-email-jarkko.sakkinen@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2014 at 03:45:09PM +0200, Jarkko Sakkinen wrote:
> The sysfs attributes of the TPM device were created to the platform
> device directory that owns the character device instead of placing
> them correctly to the directory of the character device,
> 
> They were also created in a racy way so that character device might
> become visible before sysfs attributes become available.
> 
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

For this patch there are at least these open items:

- Paths in Documentation/ABI/stable/sysfs-class-tpm should be updated.
- I moved attributes described in the documentation to the character
  device sysfs-directory from platform device sysfs directory. I don't
  believe this is a mentionable breakage because they weren't machine
  readable anyway. This should be however explicitly stated in the
  commit message.
- What should be done with PPI sysfs attributes? They are also in wrong
  place.
- What should be done with the BIOS log? They are also in wrong place.

I think this patch is really the key change to sort out before pulling the
patch set to the maintainer tree. 

/Jarkko

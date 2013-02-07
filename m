Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422808Ab3BGWln (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 17:41:43 -0500
Received: from mga01.intel.com ([192.55.52.88]:51041 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422700Ab3BGWlm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 17:41:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,625,1355126400"; 
   d="scan'208";a="284213345"
Date: Thu, 7 Feb 2013 23:41:19 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Tomas Winkler <tomas.winkler@intel.com>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [char-misc-next 08/11] mei: nfc: Initial nfc implementation
Message-ID: <20130207224119.GC5072@sortiz-mobl>
References: <1360270997-7639-1-git-send-email-tomas.winkler@intel.com>
 <1360270997-7639-9-git-send-email-tomas.winkler@intel.com>
 <201302072226.42375.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201302072226.42375.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Thu, Feb 07, 2013 at 10:26:42PM +0000, Arnd Bergmann wrote:
> On Thursday 07 February 2013, Tomas Winkler wrote:
> > 
> > From: Samuel Ortiz <sameo@linux.intel.com>
> > 
> > NFC ME client is exported through mei bus to be consumed by the
> > NFC subsystem.
> > 
> > NFC is represented by two mei clients: An info one and the actual
> > NFC one. In order for correct connection we first need to retrieve the
> > firmware information from the info client.
> > 
> > Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
> > Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> 
> Shouldn't this be moved to the drivers/nfc directory? Generally speaking,
> all drivers nowadays tend to live in the directories of the subsystems
> they are implementing support for, not the subsystems that they are
> implemented with.
This is a bit on the edge: This part of the MEI bus code doesn't implement
support for any NFC chipset in particular but for the MEI specific commands to
send and receive NFC HCI payloads.
So the drivers under driver/nfc call into the MEI bus I/O API which then call
this code to encapsulate the HCI payload into MEI (HECI) commands. The
microread driver in my nfc-next git.kernel.org tree uses the MEI bus API for
example.
Moreover this code actually talks to the ME at init time to understand which
exact NFC chipset is living behind the ME and add the correct device string to
the bus. So it really needs to access the MEI internal API to do so.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/

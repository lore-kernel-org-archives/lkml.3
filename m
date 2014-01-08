Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754933AbaAHAcU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 19:32:20 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60799 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754403AbaAHAcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 19:32:09 -0500
Date: Tue, 7 Jan 2014 16:32:37 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Marius Silaghi <msilaghi@fit.edu>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Lan Tianyu <tianyu.lan@intel.com>,
        Xenia Ragiadakou <burzalodowa@gmail.com>,
        Jiri Kosina <trivial@kernel.org>
Subject: Re: [PATCH] usbcore: fix BABBLE failed enumeration of legacy USB2
 devices on USB3 bus
Message-ID: <20140108003237.GF13062@kroah.com>
References: <02270BA454DB7548ABE8E2EBF31D46D96FC7B4C5@EX10-BE1.fit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <02270BA454DB7548ABE8E2EBF31D46D96FC7B4C5@EX10-BE1.fit.edu>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 24, 2013 at 04:19:18AM +0000, Marius  Silaghi wrote:
> From: Marius C Silaghi <msilaghi@fit.edu>
> 
> This patch is generated against the last kernel version in the github kernel repository.

We work off of the git.kernel.org trees, not github :)


> Some older families of USB2 cameras (STC-XXXXXUSB) do not support querying only the first 8 bytes of their 
> device descriptor and therefore fail at enumeration on USB3 HCDs, with babble error -75 as they send more than
> the expected 8 bytes. The proposed patch extends the mechanism used for non USB3 HCDs in the first part of 
> the same function, and  successively tries to query both the 8 byte prefix of the device descriptor, as well as 
> the whole device descriptor (in case the old style query of the 8 byte prefix fails).
> In fact, for the cameras I try to fix, the preferred condition is the negation of the one in the proposed patch,  
> "if (!USE_NEW_SCHEME(retry_counter))", to try first the version successful on this case, but I keep the 
> current order of the "if" branches to ensure clean continuation of support for other supported devices.
> 
> Signed-off-by: Marius C Silaghi <msilaghi@fit.edu>

I'll let Sarah take this patch, if it passes her testing.

thanks,

greg k-h

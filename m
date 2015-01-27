Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949AbbA0LJd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 06:09:33 -0500
Received: from mga02.intel.com ([134.134.136.20]:46743 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752514AbbA0LJ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 06:09:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,474,1418112000"; 
   d="scan'208";a="668278038"
Date: Tue, 27 Jan 2015 13:09:25 +0200
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Baolu Lu <baolu.lu@linux.intel.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/8] usb: dwc3: add ULPI interface support
Message-ID: <20150127110925.GE28539@kuha.fi.intel.com>
References: <1422025978-178336-1-git-send-email-heikki.krogerus@linux.intel.com>
 <1422025978-178336-7-git-send-email-heikki.krogerus@linux.intel.com>
 <20150123162443.GH8585@saruman.tx.rr.com>
 <20150126114610.GA28539@kuha.fi.intel.com>
 <20150126193528.GF6660@saruman.tx.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150126193528.GF6660@saruman.tx.rr.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> look at your patch again. In case DWC3_ULPI isn't enabled, this file
> won't be linked at all. You're using stubs, so taht's fine.
> 
> In case it _is_ enabled, you're breaking out early if you can't register
> ulpi interface, meaning you're exitting probe() (which, in fact, seems
> wrong as I want to be able to run dwc3 with ULPI enabled on a platform
> that was configured with ULPI+UTMI, but uses UTMI PHY).
> 
> I still think this patch won't work in all cases.

OK. So in case of ULPI+UTMI we'll try the ulpi interface, and if it
fails, fall back to UTMI. Or can we use some other method to determine
to which interface the PHY is really attached to in that case?


Thanks,

-- 
heikki

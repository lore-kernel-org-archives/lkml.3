Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658Ab3H1GjO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 02:39:14 -0400
Received: from s3.sipsolutions.net ([144.76.43.152]:58273 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278Ab3H1GjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 02:39:13 -0400
Message-ID: <1377671947.13797.2.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH] debugfs: provide debugfs_create_x64() when disabled
From: Johannes Berg <johannes@sipsolutions.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Huang Ying <ying.huang@intel.com>
Date: Wed, 28 Aug 2013 08:39:07 +0200
In-Reply-To: <20130828050857.GA17192@kroah.com>
References: <1377503910-6919-1-git-send-email-johannes@sipsolutions.net>
	 <20130828050857.GA17192@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-08-27 at 22:08 -0700, Greg Kroah-Hartman wrote:
> On Mon, Aug 26, 2013 at 09:58:30AM +0200, Johannes Berg wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> > 
> > commit 15b0beaa332b3923cc ("Add x64 support to debugfs") added
> > debugfs_create_x64(), but forgot to provide it when debugfs is
> > disabled, causing problems when code tries to use it even then.
> > Provide the appropriate static inline.
> 
> That's funny, given that it's been this way for over 3 years without
> anyone noticing :)

Heh. I only noticed because the ath9k driver was broken and selected
mac80211 debugfs without regard for DEBUG_FS configuration, and thus it
failed compile on this. This is a Kconfig bug, so I don't really need
this inline and it will never get used, but I figured debugfs has all
inlines so it should have this one as well.

johannes


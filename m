Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442Ab3JCXqM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 19:46:12 -0400
Received: from imap.thunk.org ([74.207.234.97]:41883 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751121Ab3JCXqK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 19:46:10 -0400
Date: Thu, 3 Oct 2013 19:45:45 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: "Dilger, Andreas" <andreas.dilger@intel.com>
Cc: Greg KH <greg@kroah.com>, Peng Tao <tao.peng@emc.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: lustre: why does cfs_get_random_bytes() exist?
Message-ID: <20131003234545.GA19796@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	"Dilger, Andreas" <andreas.dilger@intel.com>,
	Greg KH <greg@kroah.com>, Peng Tao <tao.peng@emc.com>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20131003193442.GB8000@thunk.org>
 <CE732F62.74A88%andreas.dilger@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CE732F62.74A88%andreas.dilger@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 03, 2013 at 11:06:58PM +0000, Dilger, Andreas wrote:
> 
> The Lustre cfs_get_random_bytes() incorporates (via cfs_rand()) a seed
> which
> also hashes in the addresses from any network interfaces that are
> configured.
> Conversely, cfs_rand() also is seeded at startup from get_random_bytes() in
> case a hardware RNG is available.  This ensures even with identical initial
> conditions cfs_get_random_bytes() gets a different random stream on each
> node.

With modern kernels, the /dev/random driver has the
add_device_randomness() interface which is used to mix in
personalization information, which includes the network MAC address.
So that particular concern should be covered without the hack of
mixing in cfs_rand().

> I'm not against cleaning this up, if there is some mechanism for the
> startup code to add in the node interface addresses into the entropy
> pool, and this is also used to perturb the prandom_u32() sequence
> after that point.

That's handled too, via the late initcall prandom_reseed().

Cheers,

					- Ted

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751607AbaD0WiD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 18:38:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36877 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450AbaD0WiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 18:38:01 -0400
Date: Sun, 27 Apr 2014 15:38:47 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Oleg Drokin <green@linuxhacker.ru>
Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Dmitry Eremin <dmitry.eremin@intel.com>
Subject: Re: [PATCH 1/5] staging/lustre/lnet: fix potential null pointer
 dereference
Message-ID: <20140427223847.GB1563@kroah.com>
References: <1398633446-16719-1-git-send-email-green@linuxhacker.ru>
 <1398633446-16719-2-git-send-email-green@linuxhacker.ru>
 <20140427230548.347fbb21@alan.etchedpixels.co.uk>
 <0B38703A-0903-469F-B2A3-D71E7E1D19E9@linuxhacker.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0B38703A-0903-469F-B2A3-D71E7E1D19E9@linuxhacker.ru>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 27, 2014 at 06:19:59PM -0400, Oleg Drokin wrote:
> On Apr 27, 2014, at 6:05 PM, One Thousand Gnomes wrote:
> 
> >> Reviewed-by: John L. Hammond <john.hammond@intel.com>
> >> Reviewed-by: Isaac Huang <he.huang@intel.com>
> >> Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
> >> ---
> >> drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c | 4 ++--
> >> 1 file changed, 2 insertions(+), 2 deletions(-)
> >> 
> >> diff --git a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c
> >> index 21d36ee..516f623 100644
> >> --- a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c
> >> +++ b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c
> >> @@ -829,14 +829,14 @@ ksocknal_select_ips(ksock_peer_t *peer, __u32 *peerips, int n_peerips)
> >> 				best_npeers = iface->ksni_npeers;
> >> 			}
> >> 
> >> +			LASSERT(best_iface != NULL);
> >> +
> > 
> > And this solves the problem how ???
> 
> This does not really solve anything.
> Just moves the check to where it's actually going to do anything instead of the check being guarded by the NULL pointer access earlier on.
> Could have been removed instead of course to just get an oops at all times.

Then please just remove it, or, even better yet, fix it properly if
there is a way that this pointer can be NULL.

greg k-h

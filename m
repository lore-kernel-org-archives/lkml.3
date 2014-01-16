Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751521AbaAPUvk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 15:51:40 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47690 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbaAPUvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 15:51:37 -0500
Date: Thu, 16 Jan 2014 20:51:29 +0000
From: Luis Henriques <luis.henriques@canonical.com>
To: David Miller <davem@davemloft.net>
Cc: bhutchings@solarflare.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        linux-net-drivers@solarflare.com
Subject: Re: [PATCH 3.12 40/77] sfc: Add length checks to
 efx_xmit_with_hwtstamp() and efx_ptp_is_ptp_tx()
Message-ID: <20140116205129.GC6429@hercules>
References: <20140114002753.640936297@linuxfoundation.org>
 <1389660315.2025.169.camel@bwh-desktop.uk.level5networks.com>
 <20140116105026.GA6429@hercules>
 <20140116.114206.1690186344823616829.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140116.114206.1690186344823616829.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 16, 2014 at 11:42:06AM -0800, David Miller wrote:
> From: Luis Henriques <luis.henriques@canonical.com>
> Date: Thu, 16 Jan 2014 10:50:26 +0000
> 
> > On Tue, Jan 14, 2014 at 12:45:15AM +0000, Ben Hutchings wrote:
> >> On Mon, 2014-01-13 at 16:28 -0800, Greg Kroah-Hartman wrote:
> >> > 3.12-stable review patch.  If anyone has any objections, please let me know.
> >> > 
> >> > ------------------
> >> > 
> >> > From: Ben Hutchings <bhutchings@solarflare.com>
> >> > 
> >> > [ Upstream commit e5a498e943fbc497f236ab8cf31366c75f337ce6 ]
> >> > 
> >> > efx_ptp_is_ptp_tx() must be robust against skbs from raw sockets that
> >> > have invalid IPv4 and UDP headers.
> >> > 
> >> > Add checks that:
> >> > - the transport header has been found
> >> > - there is enough space between network and transport header offset
> >> >   for an IPv4 header
> >> > - there is enough space after the transport header offset for a
> >> >   UDP header
> >> > 
> >> > Fixes: 7c236c43b838 ('sfc: Add support for IEEE-1588 PTP')
> >> 
> >> All the PTP fixes for sfc (40-44 in this series) logically apply to
> >> 3.10.y as well.  David, did you find conflicts there?
> 
> Yes, there were rejects which were beyond my ability to resolve.

For the 3.11 kernel, only cd6fe65 ("sfc: Maintain current frequency
adjustment when applying a time offset") required some rework -- basically,
replacing MCDI_SET_QWORD() by two MCDI_SET_DWORD()).  All the others we're
(almost) clean cherry-picks.

Cheers,
--
Luis

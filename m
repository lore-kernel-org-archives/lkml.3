Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856AbaGIUUM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 16:20:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47788 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325AbaGIUUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 16:20:11 -0400
Date: Wed, 9 Jul 2014 13:24:35 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Michalis Pappas <mpappas@fastmail.fm>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: gdm72xx: conditionally compile debug code
Message-ID: <20140709202435.GA27001@kroah.com>
References: <1404219616-1788-1-git-send-email-mpappas@fastmail.fm>
 <1404219616-1788-2-git-send-email-mpappas@fastmail.fm>
 <20140709185142.GA13271@kroah.com>
 <53BD9D67.8090806@fastmail.fm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53BD9D67.8090806@fastmail.fm>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2014 at 08:52:07PM +0100, Michalis Pappas wrote:
> On 07/09/2014 07:51 PM, Greg KH wrote:
> > On Tue, Jul 01, 2014 at 02:00:15PM +0100, Michalis Pappas wrote:
> >> Signed-off-by: Michalis Pappas <mpappas@fastmail.fm>
> >> ---
> >>  drivers/staging/gdm72xx/gdm_qos.c   | 2 ++
> >>  drivers/staging/gdm72xx/gdm_sdio.c  | 7 +++++++
> >>  drivers/staging/gdm72xx/gdm_usb.c   | 7 +++++++
> >>  drivers/staging/gdm72xx/gdm_wimax.c | 6 ++++++
> >>  drivers/staging/gdm72xx/gdm_wimax.h | 2 ++
> >>  5 files changed, 24 insertions(+)
> >>
> >> diff --git a/drivers/staging/gdm72xx/gdm_qos.c b/drivers/staging/gdm72xx/gdm_qos.c
> >> index b08c8e1..7900981 100644
> >> --- a/drivers/staging/gdm72xx/gdm_qos.c
> >> +++ b/drivers/staging/gdm72xx/gdm_qos.c
> >> @@ -88,7 +88,9 @@ static void free_qos_entry_list(struct list_head *free_list)
> >>  		total_free++;
> >>  	}
> >>  
> >> +	#if defined(GDM72xx_DEBUG)
> >>  	pr_debug("%s: total_free_cnt=%d\n", __func__, total_free);
> >> +	#endif
> > 
> > Ick, no, never put #ifdef in .c code if you can help it.  For stuff like
> > this, just rely on the dynamic debug core and use the pr_debug and
> > dev_dbg() calls, like the driver is doing, so all should be fine.
> >
> 
> But how about those cases where debug code consists of more than a
> simple call to pr_debug() / dev_dbg()?

Then that code is wrong :)

> For instance consider dump_eth_packet(), defined in gdm_wimax.c. This
> function is called every time a packet is received or transmitted, and
> calls other helper functions too (get_protocol_name(),
> get_ip_protocol_name(), get_port_name()).
> 
> Doesn't all this debug logic provide an overhead to the tx / rx functions?

Yes, so much so it doesn't make sense to even have that type of
function, right?

greg k-h

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932520Ab3BSI7E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 03:59:04 -0500
Received: from smtp.eu.citrix.com ([46.33.159.39]:42788 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932441Ab3BSI7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 03:59:02 -0500
X-IronPort-AV: E=Sophos;i="4.84,693,1355097600"; 
   d="scan'208";a="1593463"
Message-ID: <1361264324.1051.61.camel@zakaz.uk.xensource.com>
Subject: Re: [Xen-devel] [PATCH] xen: netback: remove redundant xenvif_put
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Jan Beulich <JBeulich@suse.com>
CC: David Miller <davem@davemloft.net>,
        "drjones@redhat.com" <drjones@redhat.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Date: Tue, 19 Feb 2013 08:58:44 +0000
In-Reply-To: <51233FF502000078000BF4AE@nat28.tlf.novell.com>
References: <1361219360-29176-1-git-send-email-drjones@redhat.com>
	 <20130219.005356.2288460992654639558.davem@davemloft.net>
	 <51233FF502000078000BF4AE@nat28.tlf.novell.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-02-19 at 08:03 +0000, Jan Beulich wrote:
> >>> On 19.02.13 at 06:53, David Miller <davem@davemloft.net> wrote:
> > From: Andrew Jones <drjones@redhat.com>
> > Date: Mon, 18 Feb 2013 21:29:20 +0100
> > 
> >> netbk_fatal_tx_err() calls xenvif_carrier_off(), which does
> >> a xenvif_put(). As callers of netbk_fatal_tx_err should only
> >> have one reference to the vif at this time, then the xenvif_put
> >> in netbk_fatal_tx_err is one too many.
> >> 
> >> Signed-off-by: Andrew Jones <drjones@redhat.com>
> > 
> > Applied.
> 
> But this is wrong from all we can tell,

Yes, please can this be reverted.

>  we discussed this before
> (Wei pointed to the discussion in an earlier reply). The core of
> it is that the put here parallels the one in netbk_tx_err(), and
> the one in xenvif_carrier_off() matches the get from
> xenvif_connect() (which normally would be done on the path
> coming through xenvif_disconnect()).

Perhaps Andrew was looking at the tree before "xen-netback: correctly
return errors from netbk_count_requests()" which fixed a different case
of a double put which may have appeared to be fixed by this change too.

Ian.

> And anyway - shouldn't changes to netback require an ack from
> Ian?
> 
> Jan
> 



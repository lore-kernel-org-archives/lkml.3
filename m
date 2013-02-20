Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758768Ab3BTJXy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 04:23:54 -0500
Received: from smtp.eu.citrix.com ([46.33.159.39]:3841 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756527Ab3BTJXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 04:23:52 -0500
X-IronPort-AV: E=Sophos;i="4.84,699,1355097600"; 
   d="scan'208";a="1642247"
Message-ID: <1361352229.1051.144.camel@zakaz.uk.xensource.com>
Subject: Re: [Xen-devel] [PATCH] xen: netback: remove redundant xenvif_put
From: Ian Campbell <Ian.Campbell@citrix.com>
To: David Miller <davem@davemloft.net>
CC: "JBeulich@suse.com" <JBeulich@suse.com>,
        "drjones@redhat.com" <drjones@redhat.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Date: Wed, 20 Feb 2013 09:23:49 +0000
In-Reply-To: <20130219.130607.100487415380997622.davem@davemloft.net>
References: <20130219.005356.2288460992654639558.davem@davemloft.net>
	 <51233FF502000078000BF4AE@nat28.tlf.novell.com>
	 <1361264324.1051.61.camel@zakaz.uk.xensource.com>
	 <20130219.130607.100487415380997622.davem@davemloft.net>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-02-19 at 18:06 +0000, David Miller wrote:
> From: Ian Campbell <Ian.Campbell@citrix.com>
> Date: Tue, 19 Feb 2013 08:58:44 +0000
> 
> > On Tue, 2013-02-19 at 08:03 +0000, Jan Beulich wrote:
> >> >>> On 19.02.13 at 06:53, David Miller <davem@davemloft.net> wrote:
> >> > From: Andrew Jones <drjones@redhat.com>
> >> > Date: Mon, 18 Feb 2013 21:29:20 +0100
> >> > 
> >> >> netbk_fatal_tx_err() calls xenvif_carrier_off(), which does
> >> >> a xenvif_put(). As callers of netbk_fatal_tx_err should only
> >> >> have one reference to the vif at this time, then the xenvif_put
> >> >> in netbk_fatal_tx_err is one too many.
> >> >> 
> >> >> Signed-off-by: Andrew Jones <drjones@redhat.com>
> >> > 
> >> > Applied.
> >> 
> >> But this is wrong from all we can tell,
> > 
> > Yes, please can this be reverted.
> 
> Done and I've annotated the revert commit message with as much
> information as possible.

Thanks, 629821d9b looks good to me.

May be worth considering the patch in
<1361281636.1051.100.camel@zakaz.uk.xensource.com> if we get many more
of these queries...

Ian.


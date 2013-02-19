Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932487Ab3BSI6S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 03:58:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38423 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932426Ab3BSI6Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 03:58:16 -0500
Date: Tue, 19 Feb 2013 09:58:03 +0100
From: Andrew Jones <drjones@redhat.com>
To: "Jan Beulich" <JBeulich@suse.com>
Cc: "David Miller" <davem@davemloft.net>, <ian.campbell@citrix.com>,
        <xen-devel@lists.xensource.com>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, liuw@liuw.name
Subject: Re: [Xen-devel] [PATCH] xen: netback: remove redundant xenvif_put
Message-ID: <20130219095803.17b28ec3@hawk.usersys.redhat.com>
In-Reply-To: <51233FF502000078000BF4AE@nat28.tlf.novell.com>
References: <1361219360-29176-1-git-send-email-drjones@redhat.com>
	<20130219.005356.2288460992654639558.davem@davemloft.net>
	<51233FF502000078000BF4AE@nat28.tlf.novell.com>
Organization: Red Hat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Feb 2013 08:03:49 +0000
"Jan Beulich" <JBeulich@suse.com> wrote:

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
> But this is wrong from all we can tell, we discussed this before
> (Wei pointed to the discussion in an earlier reply). The core of
> it is that the put here parallels the one in netbk_tx_err(), and
> the one in xenvif_carrier_off() matches the get from
> xenvif_connect() (which normally would be done on the path
> coming through xenvif_disconnect()).

I see the balance described by Ian in [1] now. Sorry that I missed
that previous discussion and generated this noise.

[1] http://marc.info/?l=xen-devel&m=136084174026977&w=2

drew

> 
> And anyway - shouldn't changes to netback require an ack from
> Ian?
> 
> Jan
> 


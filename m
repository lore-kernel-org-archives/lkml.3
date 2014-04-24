Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102AbaDXX1g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 19:27:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40455 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753517AbaDXX1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 19:27:34 -0400
Date: Thu, 24 Apr 2014 16:30:27 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: "Karicheri, Muralidharan" <m-karicheri2@ti.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "Balbi, Felipe" <balbi@ti.com>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH] serial: uart: add hw flow control support configuration
Message-ID: <20140424233027.GA21443@kroah.com>
References: <1397243877-23234-1-git-send-email-m-karicheri2@ti.com>
 <3E54258959B69E4282D79E01AB1F32B70471B198@DFLE11.ent.ti.com>
 <20140423152717.7100f604@alan.etchedpixels.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140423152717.7100f604@alan.etchedpixels.co.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 03:27:17PM +0100, One Thousand Gnomes wrote:
> > >-	if (up->capabilities & UART_CAP_AFE && port->fifosize >= 32) {
> > >+	if ((up->capabilities & UART_CAP_AFE && (port->fifosize >= 32)) ||
> > >+	    port->flags & UPF_HARD_FLOW) {
> > 
> > [Alan] Surely you want brackets on the port->flags & UPF_HARD_FLOW ??
> > 
> > The C precedence table shows following order:=
> > -> & ||
> > 
> > So flags will be accessed first and then AND-ed with  UPF_HARD_FLOW and
> > result will be OR-ed with left side expression value. So no need for bracket IMO.
> 
> Yep... agreed.

Perhaps, but please put them there so we all _know_ what it is doing is
correct.

greg k-h

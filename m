Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595AbaEJTc6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 15:32:58 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:37325 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038AbaEJTc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 15:32:56 -0400
X-Originating-IP: 50.43.32.211
Date: Sat, 10 May 2014 12:32:46 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Jann Horn <jann@thejh.net>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: Re: [PATCH] drivers/char/mem.c: Add /dev/ioports, supporting 16-bit
 and 32-bit ports
Message-ID: <20140510193246.GA12079@thin>
References: <20140509191914.GA7286@jtriplet-mobl1>
 <20140510070742.GE6099@debjann.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140510070742.GE6099@debjann.fritz.box>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 10, 2014 at 09:07:42AM +0200, Jann Horn wrote:
> On Fri, May 09, 2014 at 12:19:16PM -0700, Josh Triplett wrote:
> > +	if (port > 65535)
> > +		return 0;
> > +	switch (count) {
> [...]
> > +	case 4:
> > +		if (__put_user(inl(port), buf) < 0)
> > +			return -EFAULT;
> 
> What if I attempt a four-byte read at 65535? That would access four
> out-of-bounds bytes, right?

No, it would do an ind instruction on port 65535.

- Josh Triplett

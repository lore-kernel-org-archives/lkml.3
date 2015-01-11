Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993AbbAKNbP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 08:31:15 -0500
Received: from mail-yk0-f172.google.com ([209.85.160.172]:53172 "EHLO
	mail-yk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863AbbAKNbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 08:31:13 -0500
Date: Sun, 11 Jan 2015 05:31:08 -0800
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Johan Hovold <johan@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [RESEND PATCH v2 1/2] usb: serial: handle -EPROTO quietly in
 generic_read_bulk
Message-ID: <20150111133108.GA4497@hudson.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	Johan Hovold <johan@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
References: <1419066698-2684-1-git-send-email-jmmahler@gmail.com>
 <1420937073-20835-2-git-send-email-jmmahler@gmail.com>
 <20150111113618.GA23221@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150111113618.GA23221@localhost>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johan,

On Sun, Jan 11, 2015 at 12:36:18PM +0100, Johan Hovold wrote:
> On Sat, Jan 10, 2015 at 04:44:32PM -0800, Jeremiah Mahler wrote:
> > If a USB serial device is unplugged while there is an active program
> > using the device it will spam the logs with -EPROTO (71) messages as it
> > attempts to retry.
> 
> Can you change this to "might spam", as which error message, and if it is
> at all printed, depends on host controller and what (hub) devices are
> used.
> 
Ah, yes, good point.

> > Most serial usb drivers (metro-usb, pl2303, mos7840, ...) only output
> > these messages for debugging.  The generic driver treats these as
> > errors.
> > 
> > Change the default output for the generic serial driver from error to
> > debug.
> 
> Please also correct the commit summary (Subject) so that it matches what
> this revised patch now does (you silence all non-critical error
> messages).
> 
True, it is more than just -EPROTO now.

> Fix this up and I'll take both patches.
> 
> Thanks,
> Johan

Thanks for the suggestions.

v3 coming up.

-- 
- Jeremiah Mahler

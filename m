Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901AbaCYS3I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 14:29:08 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:45762 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754033AbaCYS3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 14:29:04 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18teHyyOOjCrVIuLIgzvDd3
Date: Tue, 25 Mar 2014 11:28:56 -0700
From: Tony Lindgren <tony@atomide.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-serial@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, peter@hurleysoftware.com,
        m-karicheri2@ti.com, b32955@freescale.com,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 10/11] Revert "serial: omap: unlock the port lock"
Message-ID: <20140325182856.GA31906@atomide.com>
References: <1395343807-21618-1-git-send-email-balbi@ti.com>
 <1395343807-21618-10-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395343807-21618-10-git-send-email-balbi@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Felipe Balbi <balbi@ti.com> [140320 12:39]:
> This reverts commit 0324a821029e1f54e7a7f8fed48693cfce42dc0e.
> 
> That commit tried to fix a deadlock problem when using
> hci_ldisc, but it turns out the bug was in hci_ldsic
> all along where it was calling ->write() from within
> ->write_wakeup() callback.
> 
> The problem is that ->write_wakeup() was called with
> port lock held and ->write() tried to grab the same
> port lock.

Should this and the next patch be earlier in the series
as a fix for the v3.15-rc cycle? Should they be cc: stable
as well?

Regards,

Tony

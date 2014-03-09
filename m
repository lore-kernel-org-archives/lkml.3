Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752313AbaCIDAW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 22:00:22 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53409 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914AbaCIDAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 22:00:21 -0500
Date: Sat, 8 Mar 2014 19:00:56 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Chase Southwood <chase.southwood@yahoo.com>
Cc: devel@driverdev.osuosl.org, abbotti@mev.co.uk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] Staging: comedi: convert while loops to timeouts
 in
Message-ID: <20140309030056.GA10867@kroah.com>
References: <1393922628-27903-1-git-send-email-chase.southwood@yahoo.com>
 <1394242984-32567-1-git-send-email-chase.southwood@yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394242984-32567-1-git-send-email-chase.southwood@yahoo.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2014 at 07:43:04PM -0600, Chase Southwood wrote:
> This patch changes a handful of while loops to timeouts to prevent
> infinite looping on hardware failure. A couple such loops are in a
> function (s626_debi_transfer()) which is called from critical sections,
> so comedi_timeout() is unusable for them, and an iterative timeout is
> used instead. For the while loops in a context where comedi_timeout() is
> allowed, a new callback function, s626_send_dac_eoc(), has been defined
> to evaluate the conditions that the while loops are testing.  The new
> callback employs a switch statement based on a simple new enum so that
> it is usable for all of the different conditions tested in while loops
> in s626_send_dac().  The proper comedi_timeout() calls are then used.

Your subject seems to be missing a word at the end of it :(

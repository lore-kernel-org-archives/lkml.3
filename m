Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756721AbaGIXxM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 19:53:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49232 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755347AbaGIXxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 19:53:11 -0400
Date: Wed, 9 Jul 2014 16:57:36 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, Joe Perches <joe@perches.com>,
        Kay Sievers <kay@vrfy.org>
Subject: Re: [PATCH v2] drivers/base: Fix length checks in
 create_syslog_header()/dev_vprintk_emit()
Message-ID: <20140709235736.GA31914@kroah.com>
References: <1402267903.23860.45.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1402267903.23860.45.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 08, 2014 at 11:51:43PM +0100, Ben Hutchings wrote:
> snprintf() returns the number of bytes that could have been written
> (excluding the null), not the actual number of bytes written.  Given a
> long enough subsystem or device name, these functions will advance
> beyond the end of the on-stack buffer in dev_vprintk_exit(), resulting
> in an information leak or stack corruption.  I don't know whether such
> a long name is currently possible.
> 
> In case snprintf() returns a value >= the buffer size, do not add
> structured logging information.  Also WARN if this happens, so we can
> fix the driver or increase the buffer size.
> 
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
> v2: use dev_WARN() not dev_WARN_ON()

This patch breaks the build in a huge way:

drivers/base/core.c: In function ‘create_syslog_header’:
drivers/base/core.c:2049:16: error: expected ‘)’ before numeric constant
  dev_WARN(dev, 1, "device/subsystem name too long");
                  ^

is the start of it, it goes on for a page or so after that :(

greg k-h

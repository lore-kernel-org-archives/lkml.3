Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285AbaGQTWN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 15:22:13 -0400
Received: from sibelius.xs4all.nl ([83.163.83.176]:26022 "EHLO
	glazunov.sibelius.xs4all.nl" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752118AbaGQTWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 15:22:12 -0400
X-Greylist: delayed 2030 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Jul 2014 15:22:11 EDT
Date: Thu, 17 Jul 2014 20:48:11 +0200 (CEST)
Message-Id: <201407171848.s6HImBb4027900@glazunov.sibelius.xs4all.nl>
From: Mark Kettenis <mark.kettenis@xs4all.nl>
To: "Theodore Ts'o" <tytso@mit.edu>
CC: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        beck@openbsd.org
Subject: Re: [PATCH, RFC] random: introduce getrandom(2) system call
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014, Theodore Ts'o wrote:
> 
> The getrandom(2) system call is a superset of getentropy(2).  When we
> add the support for this into glibc, it won't be terribly difficult
> nor annoying to drop the following in alongside the standard support
> needed for any new system call:
> 
> int getentropy(void *buf, size_t buflen)
> {
> 	int	ret;
> 
> 	ret = getentropy(buf, buflen, 0);
> 	return (ret > 0) ? 0 : ret;
> }

I'm sure you meant to use getrandom() there ;)

Since for LibreSSL we'd want a getentropy() that cannot fail the
getrandom() call should use GRND_BLOCK flag.  Actually it makes sense
(to me) to make blocking the default behaviour and have a
BRND_NONBLOCK flag.  Much in the same way as you need to specify
O_NONBLOCK if you want non-blocking behaviour for files.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759275AbbA2ByL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:54:11 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38457 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754280AbbA2ByI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:54:08 -0500
Date: Wed, 28 Jan 2015 22:07:51 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Tom Zanussi <tom.zanussi@linux.intel.com>
Cc: josh@joshtriplett.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/10] drivers/char: Support compiling out /dev/zero
Message-ID: <20150128210751.GA14006@amd>
References: <cover.1422035184.git.tom.zanussi@linux.intel.com>
 <79846ac644fe9103ef9b7cb0ab69e6f196f27853.1422035184.git.tom.zanussi@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <79846ac644fe9103ef9b7cb0ab69e6f196f27853.1422035184.git.tom.zanussi@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2015-01-23 12:37:11, Tom Zanussi wrote:
> Some embedded systems with tightly controlled userspace have no use
> for /dev/zero, and could benefit from the size savings gained by
> omitting it.  Add a new EMBEDDED config option to disable it.
> 
> bloat-o-meter (based on tinyconfig):
> 
> add/remove: 0/3 grow/shrink: 0/1 up/down: 0/-391 (-391)
> function                                     old     new   delta
> chr_dev_init                                 162     147     -15
> mmap_zero                                     16       -     -16
> zero_fops                                    116       -    -116
> zero_bdi                                     244       -    -244
> 
> Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>

I'm not sure that 400 bytes are worth additional Kconfig noise. .. and
pretty much everyone needs /dev/zero...

								Pavel
								
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

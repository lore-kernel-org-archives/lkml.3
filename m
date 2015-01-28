Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762890AbbA2CrH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:47:07 -0500
Received: from mail-lb0-f178.google.com ([209.85.217.178]:36265 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762878AbbA2CrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:47:04 -0500
Date: Wed, 28 Jan 2015 17:10:07 +0100
From: Johan Hovold <johan@kernel.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 3.12 140/176] gpio: sysfs: fix gpio device-attribute leak
Message-ID: <20150128161007.GC2433@localhost>
References: <cover.1422455352.git.jslaby@suse.cz>
 <e66a96f38a5a35c96eadcabbe20921ad32ed087a.1422455352.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e66a96f38a5a35c96eadcabbe20921ad32ed087a.1422455352.git.jslaby@suse.cz>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2015 at 03:29:30PM +0100, Jiri Slaby wrote:
> From: Johan Hovold <johan@kernel.org>
> 
> 3.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ===============
> 
> commit 0915e6feb38de8d3601819992a5bd050201a56fa upstream.
> 
> The gpio device attributes were never destroyed when the gpio was
> unexported (or on export failures).
> 
> Use device_create_with_groups() to create the default device attributes
> of the gpio class device. Note that this also fixes the
> attribute-creation race with userspace for these attributes.
> 
> Remove contingent attributes in export error path and on unexport.
> 
> Fixes: d8f388d8dc8d ("gpio: sysfs interface")
> Signed-off-by: Johan Hovold <johan@kernel.org>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>

There was a mistake in the 3.14 (and 3.12) backport. A fixed v2 backport
has been posted in this thread:

	https://marc.info/?l=linux-kernel&m=142241055931689&w=2

Johan

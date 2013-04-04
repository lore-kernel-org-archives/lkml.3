Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763190Ab3DDQdU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 12:33:20 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:38584 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762975Ab3DDQdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 12:33:18 -0400
Date: Thu, 4 Apr 2013 09:33:13 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: oskar.andero@sonymobile.com
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        Aleksej Makarov <aleksej.makarov@sonymobile.com>
Subject: Re: [PATCH] input: don't call input_dev_release_keys() in resume
Message-ID: <20130404163313.GA12302@core.coreip.homeip.net>
References: <1362664882-16194-1-git-send-email-oskar.andero@sonymobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362664882-16194-1-git-send-email-oskar.andero@sonymobile.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oskar,

On Thu, Mar 07, 2013 at 03:01:22PM +0100, oskar.andero@sonymobile.com wrote:
> From: Aleksej Makarov <aleksej.makarov@sonymobile.com>
> 
> When waking up the platform by pressing a specific key, sending a
> release on that key makes it impossible to react on the event in
> user-space.
> 

No, we can not simply not release keys after resume from suspend, as
this leads to keys being stuck. Consider you are holding an 'I' key on
your external USB keyboard and close your laptop's lid. Then you release
the key and leave. Later you come back, open the lid waking the laptop
and observe endless stream of 'I' in your open terminal.

Maybe we should release the keys during suspend time? I am not sure how
Android infrastructure will react to this though...

Thanks.

-- 
Dmitry

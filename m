Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757122Ab3EHPwI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 11:52:08 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51787 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756601Ab3EHPwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 11:52:05 -0400
MIME-Version: 1.0
In-Reply-To: <1367996197-32748-2-git-send-email-tiwai@suse.de>
References: <1367996197-32748-1-git-send-email-tiwai@suse.de>
	<1367996197-32748-2-git-send-email-tiwai@suse.de>
Date: Wed, 8 May 2013 23:52:02 +0800
Message-ID: <CACVXFVM2ZFYeJND7nxGhyGU7cG08Hta5qBZMAz+rDhxM1kRWZA@mail.gmail.com>
Subject: Re: [PATCH 1/3] firmware: Avoid superfluous usermodehelper lock
From: Ming Lei <ming.lei@canonical.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 8, 2013 at 2:56 PM, Takashi Iwai <tiwai@suse.de> wrote:
> When a firmware file can be loaded directly, there is no good reason
> to lock usermodehelper.  It's needed only when the direct fw load
> fails and falls back to the user-mode helper.

I remembered that we discussed the problem before, :-)

Some crazy drivers might call request_firmware inside resume callback
(for example, USB devices might be rebind in resume), with
usermodehelper_read_lock, we can find the mistake easily and log it.

I am wondering if it is good to remove the usermodehelper lock.

Could you let us know any benefit to do it?

Thanks,
--
Ming Lei

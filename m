Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757316Ab3EWCl0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 22:41:26 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51302 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757012Ab3EWClZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 22:41:25 -0400
MIME-Version: 1.0
In-Reply-To: <1369240118-5459-2-git-send-email-tiwai@suse.de>
References: <1369240118-5459-1-git-send-email-tiwai@suse.de>
	<1369240118-5459-2-git-send-email-tiwai@suse.de>
Date: Thu, 23 May 2013 10:41:21 +0800
Message-ID: <CACVXFVPU68Raj_ikvx7pCMzP_tA0R68QK=A=FrUz3C2KhKdUXw@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] firmware: Avoid deadlock of usermodehelper lock at shutdown
From: Ming Lei <ming.lei@canonical.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 23, 2013 at 12:28 AM, Takashi Iwai <tiwai@suse.de> wrote:
> When a system goes to reboot/shutdown, it tries to disable the
> usermode helper via usermodehelper_disable().  This might be blocked
> when a driver tries to load a firmware beforehand and it's stuck by
> some reason.  For example, dell_rbu driver loads the firmware in
> non-hotplug mode and waits for user-space clearing the loading sysfs
> flag.  If user-space doesn't clear the flag, it waits forever, thus
> blocks the reboot, too.
>
> As a workaround, in this patch, the firmware class driver registers a
> reboot notifier so that it can abort all pending f/w bufs before
> issuing usermodehelper_disable().
>
> Signed-off-by: Takashi Iwai <tiwai@suse.de>

Acked-by: Ming Lei <ming.lei@canonical.com>

thanks,
--
Ming Lei

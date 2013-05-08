Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932116Ab3EHP4z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 11:56:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51834 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932091Ab3EHP4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 11:56:53 -0400
MIME-Version: 1.0
In-Reply-To: <1367996197-32748-3-git-send-email-tiwai@suse.de>
References: <1367996197-32748-1-git-send-email-tiwai@suse.de>
	<1367996197-32748-3-git-send-email-tiwai@suse.de>
Date: Wed, 8 May 2013 23:56:51 +0800
Message-ID: <CACVXFVMRC2L9nBgxTv+20L2gPsRkkkraFTSL19u+KFnunoix6w@mail.gmail.com>
Subject: Re: [PATCH 2/3] firmware: Avoid deadlock of usermodehelper lock at shutdown
From: Ming Lei <ming.lei@canonical.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 8, 2013 at 2:56 PM, Takashi Iwai <tiwai@suse.de> wrote:
> When a system goes to reboot/shutdown, it tries to disable the
> usermode helper via usermodehelper_disable().  This might be blocked
> when a driver tries to load a firmware beforehand and it's stuck by
> some reason.

IMO, it is better to find why the loading is stuck. Also we already provides
the timeout sysfs file to help to deal with the situation.

>
> In this patch, the firmware class driver registers a reboot notifier
> so that it can abort all pending f/w bufs.  Also enable a flag for
> avoiding the call of usermodehelper after the reboot/shutdown starts.

With this patch, maybe we only hide the real problem.

Thanks,
--
Ming Lei

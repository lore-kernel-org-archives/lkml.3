Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832Ab3KKHoq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 02:44:46 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53159 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979Ab3KKHol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 02:44:41 -0500
MIME-Version: 1.0
In-Reply-To: <1383652626-30437-2-git-send-email-tiwai@suse.de>
References: <1383652626-30437-1-git-send-email-tiwai@suse.de>
	<1383652626-30437-2-git-send-email-tiwai@suse.de>
Date: Mon, 11 Nov 2013 15:44:38 +0800
Message-ID: <CACVXFVMAoKrVVG6fAfmSCGE7QuntF=uwA21bGNrEQEZnfheD2g@mail.gmail.com>
Subject: Re: [PATCH 1/2] firmware: Introduce request_firmware_direct()
From: Ming Lei <ming.lei@canonical.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Prarit Bhargava <prarit@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        amd64-microcode@amd64.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Takashi,

On Tue, Nov 5, 2013 at 7:57 PM, Takashi Iwai <tiwai@suse.de> wrote:
> When CONFIG_FW_LOADER_USER_HELPER is set, request_firmware() falls
> back to the usermode helper for loading via udev when the direct
> loading fails.  But the recent udev takes way too long timeout (60
> seconds) for non-existing firmware.  This is unacceptable for the
> drivers like microcode loader where they load firmwares optionally,
> i.e. it's no error even if no requested file exists.
>
> This patch provides a new helper function, request_firmware_direct().
> It behaves as same as request_firmware() except for that it doesn't
> fall back to usermode helper but returns an error immediately if the
> f/w can't be loaded directly in kernel.
>
> Without CONFIG_FW_LOADER_USER_HELPER=y, request_firmware_direct() is
> just an alias of request_firmware(), due to obvious reason.
>
> Tested-by: Prarit Bhargava <prarit@redhat.com>
> Signed-off-by: Takashi Iwai <tiwai@suse.de>

The patch is fine, except it should be against -next, so you can feel
free to add my Acked-by in your next submission.

Thanks,
--
Ming Lei

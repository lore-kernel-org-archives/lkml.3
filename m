Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751844AbbASCX7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 21:23:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36442 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179AbbASCX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 21:23:58 -0500
Date: Mon, 19 Jan 2015 10:23:50 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Feng Tang <feng.tang@intel.com>
Cc: John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        Colin Cross <ccross@android.com>,
        Heesub Shin <heesub.shin@samsung.com>,
        Mitchel Humpherys <mitchelh@codeaurora.org>
Subject: Re: [PATCH 2/2] staging: android: ion: Add pss info for each
 ion_client
Message-ID: <20150119022350.GB1094@kroah.com>
References: <1421632825-1538-1-git-send-email-feng.tang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421632825-1538-1-git-send-email-feng.tang@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2015 at 10:00:25AM +0800, Feng Tang wrote:
> In real ION buffer usage, many of the ion buffer are shared
> by several clients(imported and exported), and current ion
> debugfs only provides size of all buffers a client may use.
> This patch will considers the sharing and adds a "pss" info
> for each ion_client, which will help on profiling the ion
> memory usage.
> 
> Actually we can do more aggressively in android world, in
> which the "surfaceflinger" is a main proxy to help other
> apps to do the ion buffer allocation, and we can consider
> this and extract "surfaceflinger" related size out. And
> this could be the next step.
> 
> Signed-off-by: Feng Tang <feng.tang@intel.com>
> ---
>  drivers/staging/android/ion/ion.c |   25 +++++++++++++++++--------
>  1 file changed, 17 insertions(+), 8 deletions(-)

I really need others to review and test this with their systems before I
can accept it.  So I'll have to wait for an ack from John or Colin or
someone else...

thanks,

greg k-h

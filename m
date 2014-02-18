Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095AbaBRTBV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 14:01:21 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48042 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950AbaBRTBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 14:01:20 -0500
Date: Tue, 18 Feb 2014 11:02:45 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        Colin Cross <ccross@android.com>,
        Android Kernel Team <kernel-team@android.com>
Subject: Re: [PATCH 01/14] staging: binder: Fix death notifications
Message-ID: <20140218190245.GA27455@kroah.com>
References: <1392674322-9036-1-git-send-email-john.stultz@linaro.org>
 <1392674322-9036-2-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1392674322-9036-2-git-send-email-john.stultz@linaro.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 17, 2014 at 01:58:29PM -0800, John Stultz wrote:
> From: Arve Hjønnevåg <arve@android.com>
> 
> The change (008fa749e0fe5b2fffd20b7fe4891bb80d072c6a) that moved the
> node release code to a separate function broke death notifications in
> some cases. When it encountered a reference without a death
> notification request, it would skip looking at the remaining
> references, and therefore fail to send death notifications for them.
> 
> Cc: Greg KH <gregkh@linuxfoundation.org>
> Cc: Colin Cross <ccross@android.com>
> Cc: Arve Hjønnevåg <arve@android.com>
> Cc: Android Kernel Team <kernel-team@android.com>
> Signed-off-by: Arve Hjønnevåg <arve@android.com>
> Signed-off-by: John Stultz <john.stultz@linaro.org>
> ---
>  drivers/staging/android/binder.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

As this broke in 3.10, shouldn't this go to staging-linus and get
backported to the stable trees too?

thanks,

greg k-h

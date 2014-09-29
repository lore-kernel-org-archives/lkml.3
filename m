Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102AbaI2Uwy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 16:52:54 -0400
Received: from ou.quest-ce.net ([195.154.187.82]:59955 "EHLO ou.quest-ce.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750970AbaI2Uwx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 16:52:53 -0400
Message-ID: <1412013833.9750.12.camel@localhost.localdomain>
From: Yann Droneaud <ydroneaud@opteya.com>
To: Heinrich Schuchardt <xypron.glpk@gmx.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Colin Cross <ccross@android.com>, John Stultz <john.stultz@linaro.org>,
        Daniel Vetter <daniel@ffwll.ch>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Masanari Iida <standby24x7@gmail.com>,
        Daeseok Youn <daeseok.youn@gmail.com>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Yann Droneaud <ydroneaud@opteya.com>
In-Reply-To: <1411807958-1522-1-git-send-email-xypron.glpk@gmx.de>
References: <1411807958-1522-1-git-send-email-xypron.glpk@gmx.de>
Organization: OPTEYA
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Sep 2014 20:03:53 +0200
Mime-Version: 1.0
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a01:e35:2e9f:6ac0:1d34:d55:2d28:af2e
X-SA-Exim-Mail-From: ydroneaud@opteya.com
Subject: Re: [PATCH 1/1] staging : android : sync : get_unused_fd
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on ou.quest-ce.net)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Le samedi 27 septembre 2014 à 10:52 +0200, Heinrich Schuchardt a écrit :
> sync.h recommends to use get_unused_fd which does not set
> O_CLOEXEC while the rest of the android tree uses
> get_unused_fd_flags and sets O_CLOEXEC.
> 
> The patch adjust the comment.
> 

I'd like to add this patch to my patchset which try to remove
get_unused_fd() in favor of get_unused_fd_flags():

http://lkml.kernel.org/r/cover.1411562410.git.ydroneaud@opteya.com

But having O_CLOEXEC is welcome but not strictly needed,
so I think the patch should be reworked to not require O_CLOEXEC.

> Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
> ---
>  drivers/staging/android/sync.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/android/sync.h b/drivers/staging/android/sync.h
> index 66b0f43..a21b79f 100644
> --- a/drivers/staging/android/sync.h
> +++ b/drivers/staging/android/sync.h
> @@ -293,7 +293,8 @@ void sync_fence_put(struct sync_fence *fence);
>   * @fence:	fence to install
>   * @fd:		file descriptor in which to install the fence
>   *
> - * Installs @fence into @fd.  @fd's should be acquired through get_unused_fd().
> + * Installs @fence into @fd.  @fd's should be acquired through
> + * get_unused_fd_flags(O_CLOEXEC).

I think it will be better to have something like:

    get_unused_fd_flags(flags), with flags either provided by userspace
    or set to O_CLOEXEC.


>   */
>  void sync_fence_install(struct sync_fence *fence, int fd);
>  

Regards.

-- 
Yann Droneaud
OPTEYA



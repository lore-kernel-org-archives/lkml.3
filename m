Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756410AbaFSBL7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 21:11:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43641 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628AbaFSBL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 21:11:57 -0400
Date: Wed, 18 Jun 2014 18:15:56 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: linux-arch@vger.kernel.org, thellstrom@vmware.com,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, robdclark@gmail.com,
        thierry.reding@gmail.com, ccross@google.com, daniel@ffwll.ch,
        sumit.semwal@linaro.org, linux-media@vger.kernel.org
Subject: Re: [REPOST PATCH 4/8] android: convert sync to fence api, v5
Message-ID: <20140619011556.GE10921@kroah.com>
References: <20140618102957.15728.43525.stgit@patser>
 <20140618103711.15728.97842.stgit@patser>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140618103711.15728.97842.stgit@patser>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 12:37:11PM +0200, Maarten Lankhorst wrote:
> Just to show it's easy.
> 
> Android syncpoints can be mapped to a timeline. This removes the need
> to maintain a separate api for synchronization. I've left the android
> trace events in place, but the core fence events should already be
> sufficient for debugging.
> 
> v2:
> - Call fence_remove_callback in sync_fence_free if not all fences have fired.
> v3:
> - Merge Colin Cross' bugfixes, and the android fence merge optimization.
> v4:
> - Merge with the upstream fixes.
> v5:
> - Fix small style issues pointed out by Thomas Hellstrom.
> 
> Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
> Acked-by: John Stultz <john.stultz@linaro.org>
> ---
>  drivers/staging/android/Kconfig      |    1 
>  drivers/staging/android/Makefile     |    2 
>  drivers/staging/android/sw_sync.c    |    6 
>  drivers/staging/android/sync.c       |  913 +++++++++++-----------------------
>  drivers/staging/android/sync.h       |   79 ++-
>  drivers/staging/android/sync_debug.c |  247 +++++++++
>  drivers/staging/android/trace/sync.h |   12 
>  7 files changed, 609 insertions(+), 651 deletions(-)
>  create mode 100644 drivers/staging/android/sync_debug.c

With these changes, can we pull the android sync logic out of
drivers/staging/ now?

thanks,

greg k-h

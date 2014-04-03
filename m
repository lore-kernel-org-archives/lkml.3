Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619AbaDCUWD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 16:22:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39914 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753581AbaDCUV6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 16:21:58 -0400
Message-ID: <533DC2CC.5090408@zytor.com>
Date: Thu, 03 Apr 2014 13:21:32 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: =?UTF-8?B?VGhvbWFzIELDpGNobGVy?= <thomas@archlinux.org>, tj@kernel.org
CC: d@falconindy.com, linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        P@draigbrady.com, alexandre.f.demers@gmail.com,
        "3.14" <stable@vger.kernel.org>
Subject: Re: [PATCH] fs: Don't return 0 from get_anon_bdev
References: <20140403191617.GB2472@mtj.dyndns.org> <1396554595-11796-1-git-send-email-thomas@archlinux.org>
In-Reply-To: <1396554595-11796-1-git-send-email-thomas@archlinux.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2014 12:49 PM, Thomas Bächler wrote:
> Commit 9e30cc9595303b27b48 removed an internal mount. This
> has the side-effect that rootfs now has FSID 0. Many
> userspace utilities assume that st_dev in struct stat
> is never 0, so this change breaks a number of tools in
> early userspace.
> 
> Since we don't know how many userspace programs are affected,
> make sure that FSID is at least 1.
> 
> References: http://article.gmane.org/gmane.linux.kernel/1666905
> References: http://permalink.gmane.org/gmane.linux.utilities.util-linux-ng/8557
> Cc: 3.14 <stable@vger.kernel.org>
> Signed-off-by: Thomas Bächler <thomas@archlinux.org>
> ---
>  fs/super.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Acked-by: H. Peter Anvin <hpa@zytor.com>

It is worth noting that zero has been documented as a null device number
since at least 1995, probably more like 1993.

	-hpa



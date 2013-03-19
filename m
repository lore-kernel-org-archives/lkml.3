Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757660Ab3CSXRm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 19:17:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41512 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755351Ab3CSXRl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 19:17:41 -0400
Message-ID: <5148F1F7.7080706@zytor.com>
Date: Tue, 19 Mar 2013 16:17:11 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: William Hubbs <williamh@gentoo.org>
CC: linux-kernel@vger.kernel.org, w.d.hubbs@gmail.com, rob@landley.net,
        mpagano@gentoo.org, ryao@gentoo.org, gregkh@gentoo.org,
        torvalds@linux-foundation.org
Subject: Re: [PATCH] init: fix name of root device in /proc/mounts
References: <1359672699-23540-1-git-send-email-w.d.hubbs@gmail.com> <510AFCA1.5000700@zytor.com> <1360032141.12062.12@driftwood> <a6a99589-ac94-4cfc-a871-095431bfd8ef@email.android.com> <20130319222822.GA2338@linux1>
In-Reply-To: <20130319222822.GA2338@linux1>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2013 03:28 PM, William Hubbs wrote:
> All,
> 
> I haven't heard any more on this patch, so I wanted to ping the
> thread again and find out the status.
> 
> The original message is linked below[1].
> 
> The issue is that /dev/root appears in /proc/mounts if you do not
> boot with an initramfs, but /dev/root is not a device node. In the
> past, udev created a symbolic link from /dev/root to the
> appropriate block device, but it does not do this any longer. Also,
> devtmpfs does not create this symbolic link.
> 
> This is causing bugs with software that depends on the existence
> of /dev/root [2] for example.
> 
> Do you need any more information on this patch, or is there some
> reason it can't go in?
> 

Seems okay to me, although even better would be to use the udev name
of the device in question.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.


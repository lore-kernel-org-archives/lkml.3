Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757737Ab3CTAYt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 20:24:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41999 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752769Ab3CTAYs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 20:24:48 -0400
Message-ID: <514901C4.3040301@zytor.com>
Date: Tue, 19 Mar 2013 17:24:36 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: William Hubbs <w.d.hubbs@gmail.com>
CC: linux-kernel@vger.kernel.org, rob@landley.net, mpagano@gentoo.org,
        ryao@gentoo.org, gregkh@gentoo.org, torvalds@linux-foundation.org
Subject: Re: [PATCH] init: fix name of root device in /proc/mounts
References: <1359672699-23540-1-git-send-email-w.d.hubbs@gmail.com> <510AFCA1.5000700@zytor.com> <1360032141.12062.12@driftwood> <a6a99589-ac94-4cfc-a871-095431bfd8ef@email.android.com> <20130319222822.GA2338@linux1> <5148F1F7.7080706@zytor.com> <20130320002017.GA2810@linux1>
In-Reply-To: <20130320002017.GA2810@linux1>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2013 05:20 PM, William Hubbs wrote:
> 
> I'm not following what you mean.
> 
> The problem is that "/dev/root" should not be in /proc/mounts, 
> since there is always another entry that points to the root file
> system.
> 

You are getting the name from the root= command line option.

The other option is to take the name from the mounted device number,
and look up the udev name (which is known by the kernel).  That way it
works even if the user specifies a numeric device, or the default
device is used.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865AbaDAUSl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 16:18:41 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:54993 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720AbaDAUSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 16:18:40 -0400
Date: Tue, 01 Apr 2014 16:18:38 -0400 (EDT)
Message-Id: <20140401.161838.1562296825577866979.davem@davemloft.net>
To: dan.carpenter@oracle.com
Cc: vegard.nossum@oracle.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] isdnloop: NUL-terminate strings from userspace
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140401123534.GE18506@mwanda>
References: <533A990D.2040609@oracle.com>
	<20140401110255.GH24150@order.stressinduktion.org>
	<20140401123534.GE18506@mwanda>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 01 Apr 2014 13:18:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Tue, 1 Apr 2014 15:35:34 +0300

> I don't understand what you think the point of strlcpy() is, if it's not
> to deal with source strings which aren't NUL terminated.

If strlcpy() is meant to handle non-NULL terminated strings, then it's
kernel doc needs to be adjusted.

/**
 * strlcpy - Copy a %NUL terminated string into a sized buffer
 * @dest: Where to copy the string to
 * @src: Where to copy the string from
 * @size: size of destination buffer
 *
 * Compatible with *BSD: the result is always a valid
 * NUL-terminated string that fits in the buffer (unless,
 * of course, the buffer size is zero). It does not pad
 * out the result like strncpy() does.
 */

That says to me that 'src' is expected to be NULL terminated.

Furthermore, I like YOSHIFUJI Hideaki's idea that we should
actually validate the string and return -EINVAL if it is not
given to us NULL terminated.

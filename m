Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753595AbbAVRZN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 12:25:13 -0500
Received: from rrcs-76-79-27-186.west.biz.rr.com ([76.79.27.186]:52280 "EHLO
	rrcs-76-79-27-186.west.biz.rr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753294AbbAVRZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 12:25:09 -0500
Date: Thu, 22 Jan 2015 11:25:02 -0600
From: Jeff Epler <jepler@unpythonic.net>
To: Anshul Garg <aksgarg1989@gmail.com>
Cc: akpm@linux-foundation.org, levex@linux.com, felipe.contreras@gmail.com,
        linux-kernel@vger.kernel.org, anshul.g@samsung.com
Subject: Re: [PATCH] lib/kstrtox.c clean kstrtoll function
Message-ID: <20150122172501.GE40116@unpythonic.net>
References: <aksgarg1989@gmai.com>
 <1421934850-77446-1-git-send-email-aksgarg1989@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421934850-77446-1-git-send-email-aksgarg1989@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2015 at 05:54:10AM -0800, Anshul Garg wrote:
> -		if ((long long)(-tmp) >= 0)
> -			return -ERANGE;
> -		*res = -tmp;
...
> +	if ((long long)tmp < 0)
> +		return -ERANGE;
> +	*res = sign * tmp;

I don't believe overflow handling is correct anymore with this patch.
Did you try with the input as the most negative possible unsigned long?

Jeff

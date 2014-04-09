Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758483AbaDILjZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 07:39:25 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:47773 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758373AbaDILjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 07:39:24 -0400
Date: Wed, 9 Apr 2014 14:39:04 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Daeseok Youn <daeseok.youn@gmail.com>
Cc: gregkh@linuxfoundation.org, sachin.kamat@linaro.org,
        devel@driverdev.osuosl.org, grygorii.strashko@ti.com,
        lisa@xenapiadmin.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: speakup: fix misuse of kstrtol() in
 handle_goto()
Message-ID: <20140409113904.GE4912@mwanda>
References: <2039876.xlVvlD6iFL@daeseok-laptop.cloud.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2039876.xlVvlD6iFL@daeseok-laptop.cloud.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2014 at 07:45:46PM +0900, Daeseok Youn wrote:
> 
> A string of goto_buf has a number followed by x or y.
> e.g. "3x" means move 3 lines down.
> The kstrtol() returns an error(-EINVAL) with this string so
> go_pos has unsigned a value of that error.
> And also "*cp" has not expected value.
> 

Good catch.  This was introduced when we changed the simple_strtoul() to
kstrtol().

Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>

Did you find this bug by testing or through reading the code?

regards,
dan carpenter


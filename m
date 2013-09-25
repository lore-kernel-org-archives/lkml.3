Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854Ab3IYXoH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 19:44:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51105 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070Ab3IYXoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 19:44:04 -0400
Date: Wed, 25 Sep 2013 16:44:03 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Iker Pedrosa <ikerpedrosam@gmail.com>
Cc: pavel@ucw.cz, devel@driverdev.osuosl.org, harsh1kumar@gmail.com,
        linux-kernel@vger.kernel.org, mujeeb.adil@gmail.com,
        dan.carpenter@oracle.com
Subject: Re: [PATCH v2 08/24] Staging: winbond: reg: changed sleep function
 from msleep to usleep
Message-ID: <20130925234403.GA4242@kroah.com>
References: <1379339024-12157-1-git-send-email-ikerpedrosam@gmail.com>
 <1379339024-12157-9-git-send-email-ikerpedrosam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1379339024-12157-9-git-send-email-ikerpedrosam@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 16, 2013 at 03:43:28PM +0200, Iker Pedrosa wrote:
> According to the documentation it is not recommended to use msleep for 1ms - 20ms because it may sleep longer than 20ms. So, it is recommended to use usleep instead.
> 
> In the first revision Greg KH pointed out that this change broke the build. In my computer it builds properly so if someone has the same problem please copy the output so that I can figure out what is the problem.

Please wrap your changelog comments.

The error is:
drivers/staging/winbond/reg.c: In function ‘Uxx_power_on_procedure’:
drivers/staging/winbond/reg.c:887:3: error: implicit declaration of function ‘usleep’ [-Werror=implicit-function-declaration]

And I'm still getting it on this patch, so please fix it up, it should
be pretty obvious how to do it...

I've applied the first 7 patches here, but stopped now.  Please fix this
up and resend the remaining patches.

thanks,

greg k-h

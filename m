Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751752Ab3EPJqX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 05:46:23 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:53907 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242Ab3EPJqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 05:46:20 -0400
MIME-Version: 1.0
In-Reply-To: <19650694.136921368693687337.JavaMail.weblogic@epml12>
References: <19650694.136921368693687337.JavaMail.weblogic@epml12>
Date: Thu, 16 May 2013 11:46:19 +0200
Message-ID: <CAH7P7NiA98MFLwNTdOGh36MvgV0gGTPyk0oTud6GYYXvRKJ4Ng@mail.gmail.com>
Subject: Re: [PATCH] drivers: video: mxsfb: clean use of devm_ioremap_resource()
From: Laurent Navet <laurent.navet@gmail.com>
To: jg1.han@samsung.com
Cc: "FlorianSchandinat@gmx.de" <FlorianSchandinat@gmx.de>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/5/16, Jingoo Han <jg1.han@samsung.com>:
> It makes build warning as below:
>
> drivers/video/mxsfb.c:887:13: warning: 'host' is used uninitialized in this
> function [-Wuninitialized]
> drivers/video/mxsfb.c:965:21: warning: 'fb_info' may be used uninitialized
> in this function [-Wuninitialized]
>
> It breaks the assignment.
> 	host = to_imxfb_host(fb_info);
>
> Also, 'goto fb_release;' is not good.
> Please use ' return PTR_ERR(host->base);' as below:
> +       host->base = devm_ioremap_resource(&pdev->dev, res);
> +       if (IS_ERR(host->base))
> +               return PTR_ERR(host->base);
>
>
> Best regards,
> Jingoo Han

Thank's for reviewing, I'll look at and resend.

Laurent,

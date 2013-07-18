Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758933Ab3GRPkQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 11:40:16 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:55612 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756149Ab3GRPkP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 11:40:15 -0400
Message-ID: <1374162013.1949.119.camel@joe-AO722>
Subject: Re: [PATCH v2 5/5] media: davinci: vpbe: Replace printk with dev_*
From: Joe Perches <joe@perches.com>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Thu, 18 Jul 2013 08:40:13 -0700
In-Reply-To: <1374161380-12762-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1374161380-12762-1-git-send-email-prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-07-18 at 20:59 +0530, Prabhakar Lad wrote:
> Use the dev_* message logging API instead of raw printk.
[]
> diff --git a/drivers/media/platform/davinci/vpbe.c b/drivers/media/platform/davinci/vpbe.c
[]
> @@ -595,7 +595,7 @@ static int vpbe_initialize(struct device *dev, struct vpbe_device *vpbe_dev)
>  	 * matching with device name
>  	 */
>  	if (NULL == vpbe_dev || NULL == dev) {
> -		printk(KERN_ERR "Null device pointers.\n");
> +		dev_err(dev, "Null device pointers.\n");

And if dev actually is NULL?

btw: canonical forms for this test are
	(if vpbe_dev == NULL || dev == NULL)
or
	if (!bpbe_dev || !dev)

I stopped reading here.


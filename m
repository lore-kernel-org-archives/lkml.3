Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752325AbaCKOU7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 10:20:59 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:51891 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751250AbaCKOU6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 10:20:58 -0400
Message-ID: <531F1B76.6010608@mev.co.uk>
Date: Tue, 11 Mar 2014 14:19:34 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Conrad Meyer <cemeyer@uw.edu>, Greg Kroah-Hartman <greg@kroah.com>
CC: H Hartley Sweeten <hsweeten@visionengravers.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Staging: comedi: Fix some raw printks with dev_warn()
References: <20140308214239.36a60185@m>
In-Reply-To: <20140308214239.36a60185@m>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-03-09 02:42, Conrad Meyer wrote:
> Brought to you with the help of sed and manual clean-up after.
>
>    $ sed -i -e 's|printk("\\n|dev_warn(dev->hw_dev,\n\t"|' \
>      addi-data/hwdrv_apci1500.c
>
> Since all of these printk()s were for invalid API inputs and most of
> them returned -EINVAL, I fixed the rest of them to return -EINVAL as
> well.
>
> Signed-off-by: Conrad Meyer <cse.cem@gmail.com>

In comedi, we usually use dev->class_dev as the device for these sorts 
of messages.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932563AbaJ2Si6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 14:38:58 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:62424 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754020AbaJ2Six (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 14:38:53 -0400
MIME-Version: 1.0
In-Reply-To: <1414171197-18620-1-git-send-email-dbaryshkov@gmail.com>
References: <1414171197-18620-1-git-send-email-dbaryshkov@gmail.com>
Date: Wed, 29 Oct 2014 22:38:52 +0400
Message-ID: <CALT56yPLnitsAqKJ=ryFE1uXwQqpbqwP3BmOf8L+fYG88kPnhw@mail.gmail.com>
Subject: Re: [PATCH] mfd: tc6393xb fail ohci suspend if full state restore is required
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: kernel list <linux-kernel@vger.kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-10-24 20:19 GMT+03:00 Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>:
> Some boards with TC6393XB chip require full state restore during system
> resume thanks to chip's VCC being cut off during suspend (Sharp SL-6000
> tosa is one of them). Failing to do so would result in ohci Oops on
> resume due to internal memory contentes being changed. Fail ohci suspend
> on tc6393xb is full state restore is required.
>
> Recommended workaround is to unbind tmio-ohci driver before suspend and
> rebind it after resume.

ping

>
> Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/mfd/tc6393xb.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)



-- 
With best wishes
Dmitry

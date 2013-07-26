Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759282Ab3GZP0K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 11:26:10 -0400
Received: from mail.ispras.ru ([83.149.199.45]:35407 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759207Ab3GZP0I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 11:26:08 -0400
Message-ID: <51F2950D.3070103@ispras.ru>
Date: Fri, 26 Jul 2013 19:26:05 +0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: balbi@ti.com
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: Re: [PATCH] usb: gadget: mv_u3d_core: fix violation of locking discipline
 in mv_u3d_ep_disable()
References: <1374610817-14894-1-git-send-email-khoroshilov@ispras.ru> <20130725173017.GK25415@radagast>
In-Reply-To: <20130725173017.GK25415@radagast>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

On 07/25/2013 09:30 PM, Felipe Balbi wrote:
> On Wed, Jul 24, 2013 at 12:20:17AM +0400, Alexey Khoroshilov wrote:
>> mv_u3d_nuke() expects to be calles with ep->u3d->lock held,
>> because mv_u3d_done() does. But mv_u3d_ep_disable() calls it
>> without lock that can lead to unpleasant consequences.
>>
>> Found by Linux Driver Verification project (linuxtesting.org).
>>
>> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
> which commit introduced the bug ? Which kernels are affected by this bug ?
The bug is present from the very beginning: commit 3d4eb9d of 15 June 2012.
So it is in the mainline since v3.5.

--
Alexey

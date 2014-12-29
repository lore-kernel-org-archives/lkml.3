Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751683AbaL2GUe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 01:20:34 -0500
Received: from mail-oi0-f49.google.com ([209.85.218.49]:40461 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934AbaL2GUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 01:20:32 -0500
Message-ID: <54A0F2AD.6060505@lwfinger.net>
Date: Mon, 29 Dec 2014 00:20:29 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Serguey Parkhomovsky <sergueyparkhomovsky@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        navin patidar <navin.patidar@gmail.com>,
        Elena Oat <oat.elena@gmail.com>, Tim Jester-Pfadt <t.jp@gmx.de>
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8188eu: rtw_mlme.c: fix sparse warning
References: <20141229054706.GA8062@fedora.localdomain>
In-Reply-To: <20141229054706.GA8062@fedora.localdomain>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/28/2014 11:47 PM, Serguey Parkhomovsky wrote:
> Fixes the following sparse warning for rtw_mlme.c:
>
> drivers/staging/rtl8188eu/core/rtw_mlme.c:810:9: warning: context imbalance in 'rtw_free_assoc_resources' - different lock contexts for basic block
>
> Signed-off-by: Serguey Parkhomovsky <sergueyparkhomovsky@gmail.com>
> ---
>   drivers/staging/rtl8188eu/core/rtw_mlme.c | 37 ++++++++++++++++++++-----------
>   1 file changed, 24 insertions(+), 13 deletions(-)

Are these many changes needed just because Sparse is not smart enough to 
understand that the following does not really have a context imbalance:

	if (lock_scanned_queue)
		spin_lock_bh(&(pmlmepriv->scanned_queue.lock));
	.....
	.....

	if (lock_scanned_queue)
   		spin_unlock_bh(&pmlmepriv->scanned_queue.lock);

Nothing in the middle touches lock_scanned_queue, thus if the spin lock and 
unlock operations will be paired. That is all that is important. The fact that 
some tool objects to this construct means that the tool is broken, not the code.

In my mind, Sparse warnings/errors/checks are in place to alert you to a 
possible problem. If they point to white space issues, then you fix them. If 
they point to lines that are too long, then you see if you can shorten them 
without harming the readability. In any case, judgement should be used before 
blindly trying to silence the warning.

For those reasons, NACK.

Larry



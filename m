Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756123Ab3KLTOf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 14:14:35 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:34784 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754259Ab3KLTOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 14:14:32 -0500
Message-ID: <52827E16.1030001@lwfinger.net>
Date: Tue, 12 Nov 2013 13:14:30 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Alexandre Demers <alexandre.f.demers@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Silence r8712u info and add verbose option v2
References: <1384281793-4733-1-git-send-email-alexandre.f.demers@gmail.com>
In-Reply-To: <1384281793-4733-1-git-send-email-alexandre.f.demers@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2013 12:43 PM, Alexandre Demers wrote:
> r8712u pollutes dmesg and logs. Silence it and add a verbose option to KConfig if we ever
> really want to hear about it.
>
> v2: keep netdev_info instead of replacing it by a KERN_NOTICE
>
> ---
>   drivers/staging/rtl8712/Kconfig        | 7 +++++++
>   drivers/staging/rtl8712/rtl871x_mlme.c | 7 ++++---
>   2 files changed, 11 insertions(+), 3 deletions(-)

Do you really want the "v2" to be part of the patch title in the git repos? I 
expect not, thus you should put it inside the []. All that stuff is stripped off 
when the patch is merged.

Similarly, do you want the v2 line in the patch description to be part of the 
permanent record? If not, move it below the --- line.

You are also missing a Signed-off-by: line. Have you read 
Documentation/SubmittingPatches? At least you should run every patch through 
scripts/checkpatch.pl before submitting it.

Finally, why do you want to add another Kconfig variable? I suggest either 
deleting the logging statement, or commenting it out. I'm not sure that this 
info would ever need logging.

I NACK this patch.

Larry



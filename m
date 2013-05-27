Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278Ab3E0RB1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 13:01:27 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:59138 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727Ab3E0RBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 13:01:25 -0400
MIME-Version: 1.0
In-Reply-To: <CACVXFVNBhsECz59Wx=O6xfRq==cNss+8cmP_5PMZYresuYPLfQ@mail.gmail.com>
References: <1369650604-27941-1-git-send-email-ming.lei@canonical.com>
	<1369650604-27941-2-git-send-email-ming.lei@canonical.com>
	<CAK7N6vozJ-dNDCj4QEo_nO=Tb_nEq3h6bmSF0rvaJ5NYgyK3fw@mail.gmail.com>
	<s5h1u8sr4rd.wl%tiwai@suse.de>
	<CAK7N6vqU0t7oR6KwMnMN=1h6Q6PLy5=R4dwfdx_5bS7MNHzpBw@mail.gmail.com>
	<CACVXFVNBhsECz59Wx=O6xfRq==cNss+8cmP_5PMZYresuYPLfQ@mail.gmail.com>
Date: Mon, 27 May 2013 22:31:24 +0530
Message-ID: <CAK7N6vpKPNq3rXgBttGGO7Ddx5gVnRt85x2O2mGU5NjLJeAbXQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] driver core: firmware loader: don't cache
 FW_ACTION_NOHOTPLUG firmware
From: anish singh <anish198519851985@gmail.com>
To: Ming Lei <ming.lei@canonical.com>
Cc: Takashi Iwai <tiwai@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel-mail <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 27, 2013 at 6:52 PM, Ming Lei <ming.lei@canonical.com> wrote:
> On Mon, May 27, 2013 at 8:40 PM, anish singh
> <anish198519851985@gmail.com> wrote:
>> On Mon, May 27, 2013 at 5:53 PM, Takashi Iwai <tiwai@suse.de> wrote:
>>> At Mon, 27 May 2013 17:26:22 +0530,
>>> anish singh wrote:
>>>>
>>>> On Mon, May 27, 2013 at 4:00 PM, Ming Lei <ming.lei@canonical.com> wrote:
>>>> > Generally there are only two drivers which don't need uevent to
>>>> > handle firmware loading, so don't cache these firmwares during
>> Sorry but it confuses me further,
>
> Please put one blank line before your reply, otherwise it is a bit
> difficult to find your reply in email.

sorry.

>
>> If driver doesn't have information about these firmware then how
>> does it cache it?
>
> Driver only needs firmware's name for caching it, but driver can choose
> if it generates uevent to let userspace handle it. Without one uevent, the
> user space still can handle the request by waiting for the firmware sysfs
> device in advance. But if there is no one user space to handle the request,
> the request in kernel won't be completed and there is no timeout for this
> case, so will block suspend.

Now makes sense.Thanks!!
>
>
> Thanks,
> --
> Ming Lei

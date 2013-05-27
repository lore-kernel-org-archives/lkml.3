Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758190Ab3E0NWd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 09:22:33 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50684 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756122Ab3E0NWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 09:22:32 -0400
MIME-Version: 1.0
In-Reply-To: <CAK7N6vqU0t7oR6KwMnMN=1h6Q6PLy5=R4dwfdx_5bS7MNHzpBw@mail.gmail.com>
References: <1369650604-27941-1-git-send-email-ming.lei@canonical.com>
	<1369650604-27941-2-git-send-email-ming.lei@canonical.com>
	<CAK7N6vozJ-dNDCj4QEo_nO=Tb_nEq3h6bmSF0rvaJ5NYgyK3fw@mail.gmail.com>
	<s5h1u8sr4rd.wl%tiwai@suse.de>
	<CAK7N6vqU0t7oR6KwMnMN=1h6Q6PLy5=R4dwfdx_5bS7MNHzpBw@mail.gmail.com>
Date: Mon, 27 May 2013 21:22:29 +0800
Message-ID: <CACVXFVNBhsECz59Wx=O6xfRq==cNss+8cmP_5PMZYresuYPLfQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] driver core: firmware loader: don't cache
 FW_ACTION_NOHOTPLUG firmware
From: Ming Lei <ming.lei@canonical.com>
To: anish singh <anish198519851985@gmail.com>
Cc: Takashi Iwai <tiwai@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel-mail <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 27, 2013 at 8:40 PM, anish singh
<anish198519851985@gmail.com> wrote:
> On Mon, May 27, 2013 at 5:53 PM, Takashi Iwai <tiwai@suse.de> wrote:
>> At Mon, 27 May 2013 17:26:22 +0530,
>> anish singh wrote:
>>>
>>> On Mon, May 27, 2013 at 4:00 PM, Ming Lei <ming.lei@canonical.com> wrote:
>>> > Generally there are only two drivers which don't need uevent to
>>> > handle firmware loading, so don't cache these firmwares during
> Sorry but it confuses me further,

Please put one blank line before your reply, otherwise it is a bit
difficult to find your reply in email.

> If driver doesn't have information about these firmware then how
> does it cache it?

Driver only needs firmware's name for caching it, but driver can choose
if it generates uevent to let userspace handle it. Without one uevent, the
user space still can handle the request by waiting for the firmware sysfs
device in advance. But if there is no one user space to handle the request,
the request in kernel won't be completed and there is no timeout for this
case, so will block suspend.


Thanks,
--
Ming Lei

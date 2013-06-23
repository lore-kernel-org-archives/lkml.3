Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751239Ab3FWNQj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 09:16:39 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:51152 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925Ab3FWNQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 09:16:35 -0400
MIME-Version: 1.0
In-Reply-To: <20130623112133.GA4837@amd.pavel.ucw.cz>
References: <20130623101940.GA4448@amd.pavel.ucw.cz>
	<20130623112133.GA4837@amd.pavel.ucw.cz>
Date: Sun, 23 Jun 2013 15:16:33 +0200
Message-ID: <CAJBHPoj5hgp97=JH8UKX+Ty8TF9_ySQUYU6AnqcRjuLy5A-PcQ@mail.gmail.com>
Subject: Re: SATA hdd refuses to reallocate a sector?
From: Marcus Overhagen <marcus.overhagen@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
        tj@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 23, 2013 at 1:21 PM, Pavel Machek <pavel@ucw.cz> wrote:

> ...Ok, lets try with dd.
>
> root@amd:~# dd if=/dev/sda4 of=/dev/zero bs=1 skip=8958947328
> dd: reading `/dev/sda4': Input/output error
> 0+0 records in
> 0+0 records out
> 0 bytes (0 B) copied, 5.05805 s, 0.0 kB/s

I once noticed a similar problem. The trouble is that the kernel
always seems to be doing a larger read access that failes for this
sector, and the write is never executed.

You can try: hdparam --write-sector 961237188 /dev/sda

Hope that helps,

Marcus

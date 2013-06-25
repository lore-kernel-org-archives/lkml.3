Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530Ab3FYBFQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 21:05:16 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36373 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441Ab3FYBFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 21:05:14 -0400
Message-ID: <51C8ECC7.4030404@mit.edu>
Date: Mon, 24 Jun 2013 18:05:11 -0700
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: David Herrmann <dh.herrmann@gmail.com>
CC: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Dave Airlie <airlied@gmail.com>, linux-fbdev@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>, Olof Johansson <olof@lixom.net>
Subject: Re: [RFC 3/6] drm: add SimpleDRM driver
References: <1372112849-670-1-git-send-email-dh.herrmann@gmail.com> <1372112849-670-4-git-send-email-dh.herrmann@gmail.com>
In-Reply-To: <1372112849-670-4-git-send-email-dh.herrmann@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2013 03:27 PM, David Herrmann wrote:
> +	sdrm->fb_map = ioremap(sdrm->fb_base, sdrm->fb_size);

This should probably be ioremap_wc.  Otherwise it will be *really* slow
if used in legacy mode and it may cause conflicts with the
pgprot_writecombine mode for mmap.

(Watching boot messages go by on fbcon on efifb was like using an old
2400 baud modem before I made the corresponding change to efifb.)

--Andy

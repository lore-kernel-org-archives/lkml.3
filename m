Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177AbaA0TxT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 14:53:19 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36073 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753580AbaA0TxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 14:53:17 -0500
Date: Mon, 27 Jan 2014 11:54:22 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Tom Gundersen <teg@jklm.no>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org, kay@vrfy.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [RFC][PATCH] module: allow multiple calls to
 MODULE_DEVICE_TABLE() per module
Message-ID: <20140127195422.GB21018@kroah.com>
References: <1390849795-2155-1-git-send-email-teg@jklm.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390849795-2155-1-git-send-email-teg@jklm.no>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 27, 2014 at 08:09:55PM +0100, Tom Gundersen wrote:
> Commit 78551277e4df5: "Input: i8042 - add PNP modaliases" had a bug, where the
> second call to MODULE_DEVICE_TABLE() overrode the first resulting in not all
> the modaliases being exposed.
> 
> This fixes the problem by including the name of the device_id table in the
> __mod_*_device_table alias, allowing us to export several device_id tables
> per module.
> 
> Suggested-by: Kay Sievers <kay@vrfy.org>
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> ---
>  include/linux/module.h   |  2 +-
>  scripts/mod/file2alias.c | 14 +++++++++-----
>  2 files changed, 10 insertions(+), 6 deletions(-)

Ah, very nice, I've wanted this for a while now, it would make a number
of different drivers much smaller and simpler to add new device ids to
(no multiple lists of ids, one for the module loader and one for the
sub-driver that is in the single file.)

If this doesn't break any userspace tools, I have no objection to it at
all:

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

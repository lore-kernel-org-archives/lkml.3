Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981AbaEaRWl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 13:22:41 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:45416 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725AbaEaRWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 13:22:40 -0400
MIME-Version: 1.0
Date: Sat, 31 May 2014 18:22:39 +0100
Message-ID: <CABGuwE=v2vbX882WVW_OzbNsY2k9y0nme-E13VNYgL6o+A73xg@mail.gmail.com>
Subject: Block device questions
From: Kieran Kunhya <kieran618@googlemail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm writing a driver for Sony SxS cards, which is an Expresscard based
flash memory card used in Sony cameras with an eventual goal of
submitting the code to mainline.

The code in its current working but ugly state can be found here:
https://github.com/kierank/sxs-linux/blob/master/sxs.c

I had some questions about the block device layer:

As far as I can tell from reverse engineering the device, it doesn't
support full scatter/gather but can do multiple block reads to one
address of DMA memory of a suitable size. Is there a way of coalescing
adjacent segments and letting the device write to one large slab of
DMA memory? Or do I have to handle each segment individually?

Also how many minor numbers am I meant to allocate with alloc_disk()?

Regards,

Kieran Kunhya

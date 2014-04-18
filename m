Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562AbaDRIFy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 04:05:54 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:63540 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111AbaDRIFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 04:05:46 -0400
MIME-Version: 1.0
From: Norbert Ciosek <norbertciosek@gmail.com>
Date: Fri, 18 Apr 2014 10:05:24 +0200
Message-ID: <CAFEQzNtv-iUAELME1Z9Ef6oqaq7WOjoGA_MWUSzGmt=KrRST=w@mail.gmail.com>
Subject: broken UIO functionality for mmap in linux stable
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello kernel developers,

I have some problems with UIO driver.
To be exact the problem is with uio_mmap_physical function from
drivers/uio/uio.c.

Problems were introduced by commits:
b65502879556d041b45104c6a35abbbba28c8f2d
7314e613d5ff9f0934f7a0f74ed7973b903315d1

These commits added checks if address and size are page aligned.
Of course this is correct for the "mmap" call, but currently there is
no way to store offset in the UIO driver.
Function "map_offset_show" will always return/store 0 with the page
aligned addresses.

Is it possible to add additional field called "offset" to struct uio_mem?
The "addr" could be renamed to "base" and store address with page granularity.
Then this field should be checked in the "uio_mmap_physical" function
instead of "addr".

Beside of this size of the map in the device is not always page aligned.
For example in my device this value is often set to 4.
Should I change this value to be page aligned (i.e. 0x1000 in DTS) and
"remember" the correct size in the user space program which is
managing the device? Maybe there is some other way?

Pozdrawiam / Best regards,

Norbert Ciosek

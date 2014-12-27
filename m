Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751380AbaL0Nba (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2014 08:31:30 -0500
Received: from mail-lb0-f169.google.com ([209.85.217.169]:46485 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbaL0Nb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2014 08:31:28 -0500
MIME-Version: 1.0
Date: Sat, 27 Dec 2014 15:31:26 +0200
Message-ID: <CAM===sRw3xsabexzmecOyr=UNEkpJA059yB7TYfd-6LqBLgiGA@mail.gmail.com>
Subject: Old O_DIRECT story
From: Leon Pollak <leon.pollak@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, all.
There was a discussion here:
https://lkml.org/lkml/2007/1/10/231

Linus wrote in this discussion:
"So don't use O_DIRECT. Use things like madvise() and posix_fadvise()
instead"

After the full week of tests, searches, discussions, I have impudence to
turn to the community - has one tried to implement this approach?

The situation is very simple:
I have the incoming DMA stream using scatter/gather technique. the driver
read() function provides the next ready DMA buffer descriptor with the
virtual address pointer to the acquired data. I need to store this data to
the disk partition as fast as possible, as the incoming stream is too very
fast. According to tests, O_DIRECT/mapping is fast enough, while write() is
not.

I tried in all ways to implement this with mmap(), but it does not success,
because I did not find a way to mmap() file as O_WRONLY. Mapping as O_RDWR
makes kernel to pre-fill mapped memory with partition data. So, kernel and
DMA actually compete on the RAM area to fill it - one with garbage, one
with actual data. Kernel wins.

So, how to implement Linus's advice?
Leon

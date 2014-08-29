Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752932AbaH2HAi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 03:00:38 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:49051 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbaH2HAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 03:00:37 -0400
MIME-Version: 1.0
Date: Fri, 29 Aug 2014 11:00:37 +0400
Message-ID: <CANqPQW2AiZ0WYA6K5ppDHcaE_akKDV7ubPhx-Be4wXpfJmesaQ@mail.gmail.com>
Subject: [Bug ?] Loosing synchronization between virtual block device and
 physical device
From: artem rus <artem.rusanov@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello guys !

I have flash card /dev/sda. /dev/sda2 is ext3 partition with root, log
is enabled. Initially root mounted in read only mode. If I need to
change something, I remount to read write, change and remount back to
read only. Recently I decide to use md5sum to be sure in my flash
integrity, just calculate md5 for /dev/sda2 and compare at boot time.
And I found very strange (at least for me) problem. I change some
files in root and after do sync and echo 3 > /proc/sys/vm/drop_caches.
As result content of /dev/sda2 and subset of /dev/sda must be equal,
but it different in some bytes (mutated bytes). And subset of /dev/sda
is real flash content, I will get it in /dev/sda2 after flash
reconnect or reboot. It means the content of /dev/sda2 will change
after reboot. I found the mutated bytes are located in ext3 journal
unallocated blocks, so they are not used, but anyway virtual device
data and corresponding phisical device data must be equal, and can't
be changed by just reboot,  isn't it ? This is true for latest stable
kernel 3.16.1. I also found mutated bytes changes in physical device
and remain unchanged (physical device old data) in corresponding
virtual device. That is going on ? Is it ok ? Or may be this is very
hard to catch important bug ?

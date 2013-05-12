Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751930Ab3ELXYn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 19:24:43 -0400
Received: from josephdwagner.info ([72.4.161.242]:57663 "EHLO
	josephdwagner.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011Ab3ELXYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 19:24:42 -0400
X-Greylist: delayed 3406 seconds by postgrey-1.27 at vger.kernel.org; Sun, 12 May 2013 19:24:42 EDT
From: "Joseph D. Wagner" <joe@josephdwagner.info>
To: <linux-kernel@vger.kernel.org>
Subject: Excessive Swapping Under Minimal Load
Date: Sun, 12 May 2013 15:27:42 -0700
Message-ID: <000001ce4f5f$ec7178f0$c5546ad0$@josephdwagner.info>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: Ac5PXW5uu84GcgVEQZC3vPLXFO9pJg==
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am trying to use duplicity to backup my /home to an external hard drive
(usb 2 interface).  After running for a few minutes, my io slows to a crawl.
My system reports using about 300-400MB of swap, even though only about
600MB / 4GB is in use.

I am trying to isolate the cause.  It may be duplicity in conjunction with
the particulars of my configuration (see below).  I get good performance
under normal circumstances.  I am using fedora 18, which has /tmp mounted
using tmpfs, but duplicity never uses more than 1.0GB - 1.1GB.

First, is this the correct forum for asking for this kind of help?

Second, what information 

The particulars of my configuration:
sda1 -> win7 hidden boot
sda2 -> win7 regular
sda3 -> grub2 boot
sda5 -> luks swap
sda6 -> luks ext4 root
sda7 -> regular ext4 data
sdb1 -> luks userdata1 -> md raid 0 with userdata1 and userdata2-> ext4 home
sdc1 -> luks userdata2 -> md raid 0 with userdata1 and userdata2 -> ext4
home

My thinking in putting md raid on top of luks was that I would be able to
better use multithreading (2 luks, 1 per physical drive), whereas putting
luks on top of md raid might create a choke point (1 luks for 1 virtual
drive).  I'll admit that this might be the problem.  However, it works fine
under normal circumstances.

I was hoping someone could help me either 1) isolate what is causing the
swapping, or 2) tell me what is wrong with my configuration based upon their
knowledge of how the kernel works.

Thanks in advance.

Joseph D. Wagner


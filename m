Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107AbaHMDBL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 23:01:11 -0400
Received: from homie.mail.dreamhost.com ([208.97.132.208]:44191 "EHLO
	homiemail-a38.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751506AbaHMDBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 23:01:10 -0400
From: =?utf-8?B?56mN5Li55bC8?= Dan Jacobson <jidanni@jidanni.org>
To: linux-kernel@vger.kernel.org
Subject: Idea: new parameter: save_boot_messages_to_a_file_on=/dev/sdb1
Reply-To: jidanni@jidanni.org, linux-kernel@vger.kernel.org
Date: Wed, 13 Aug 2014 10:37:16 +0800
Message-ID: <87y4utt8rn.fsf@jidanni.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Problem: boot messages fly off the screen before the kernel panic is reached.
Possible to write boot messages to a file on a USB stick?

Gentlemen, we all know what a hassle it can be to get all those error
messages that fly off your screen upon failed boots. One needs extra
equipment etc.

Well how about a new parameter that one could add there via typing "e"
in grub,

 linux /boot/vmlinuz... root=... ro single panic=333 save_boot_messages_to_a_file_on=/dev/sdb1

Whereas normally the system would be just attempted to be booted, upon
seeing the "save_boot_messages_to_a_file_on=" parameter, the kernel's
first job would be to start writing copies of messages that it sends to
the screen to some file (default BOOTMES.TXT) on /dev/sdb1 , then
proceed to do the booting, making sure after writing its final stack
trace to the screen to then close that file and sync it to the disk
before giving up and starting the panic wait.

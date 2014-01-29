Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752309AbaA2NFs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 08:05:48 -0500
Received: from mail-ee0-f47.google.com ([74.125.83.47]:33239 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386AbaA2NFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 08:05:47 -0500
Message-ID: <1391000743.2601.26.camel@snow.station>
Subject: Re: same ext4 file system corruption on different machines
From: Luca Ognibene <luca.ognibene@gmail.com>
To: linux-kernel@vger.kernel.org
Date: Wed, 29 Jan 2014 14:05:43 +0100
In-Reply-To: <1390999955.2601.22.camel@snow.station>
References: <1390999955.2601.22.camel@snow.station>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il giorno mer, 29/01/2014 alle 13.52 +0100, Luca Ognibene ha scritto:
> Hi, we are using ext4 as the root file system of some servers(~100, the
> first installed 5 months ago). We are starting to see corruption on
> these file systems, it already happened 3 times. All these servers have
> the same image copied on the 4GB disk-on-module sata disk. They don't
> write very much on the disk, only upgrades from time to time and
> configuration files written 3 times a day,a couple of MB each time. Logs
> are written on another partition. The faulty servers have different
> motherboard/cpu(intel 64bit). We are running ubuntu 12.04.2 with kernel
> 3.8.0-31-generic. We used the same dom with another image and ext3
> without problems for a couple of years so i don't think it's a dom's
> fault.

I've forgot the syslog error entry:

Jan 24 23:00:02 ay kernel: [371845.888834] EXT4-fs error (device sda2):
ext4_iget:3888: inode #127236: comm python-d: bad extra_isize (65663 !=
256)
Jan 24 23:00:02 ay kernel: [371845.888849] Aborting journal on device
sda2-8.
Jan 24 23:00:02 ay kernel: [371845.890819] EXT4-fs (sda2): Remounting
filesystem read-only
Jan 24 23:00:02 ay kernel: [371845.902919] EXT4-fs error (device sda2):
ext4_iget:3888: inode #127236: comm python-d: bad extra_isize (65663 !=
256)

I say "same ext4 file system corruption" because e2fsck reports errors
on inodes around 127233 on all file systems. I'm not sure about the
syslog errors because i have syslog logs for only the latest faulty
partition.

ciao
Luca



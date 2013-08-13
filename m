Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759035Ab3HMUPl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 16:15:41 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:59305 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759059Ab3HMUP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 16:15:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Bob Smith <bsmith@linuxtoys.org>
Subject: Re: [PATCH 001/001] CHAR DRIVERS: a simple device to give daemons a /sys-like interface
Date: Tue, 13 Aug 2013 22:15:10 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
References: <20130804231958.GA25418@kroah.com> <201308102343.11147.arnd@arndb.de> <5206B994.9050603@linuxtoys.org>
In-Reply-To: <5206B994.9050603@linuxtoys.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201308132215.11178.arnd@arndb.de>
X-Provags-ID: V02:K0:yqscGewoDACa7x55YftMXdTlAhEQUfU9EDZ0vZv10lQ
 Otl3hRKk8xHxm/vep4igALQmoKOIz/D/hMT9jZojcJne6hUMdw
 cG9XRPuFqE1yreDA+361+MDg3Lm8fqR6VUoZD2YRElBhBf9OtM
 ybmIYb1fP8bbojuRuYuhViYte61Cy0WIsdC00yhR8JL42ngMRZ
 QxP5SD5FZYlAoVRtjpUdWA10K+EQCA0BSL0jybsIc30qeg5yPO
 dtxRNtKbDPs90f21/OcqoUVKuekgrBma4KvMBFB9bkRRfsMtq2
 AVyssO3QdPVU2aU/gmoUKv7jUpzF+niAuxX7xIbbEadlsOpBoF
 +9iTDN4fwGsuH4bcsJdA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 11 August 2013, Bob Smith wrote:
> Arnd Bergmann wrote:
> >> GOAL
> >> The goal of this patch was to make it possible to configure
> >> daemons using simple file IO.  The litmus test for this is
> >> that commands like these should be possible
> >>          cat < /var/daemons/wpa_supplicant/use_channel
> >>          echo 5 >/var/daemons/wpa_supplicant/use_channel
> 
> > If you want to have that behavior, I think the best way to
> > do it would be new file system that combines aspects of
> > tmpfs and debugfs, letting users with write access to the
> > mount point (or a directory under it) create subdirectories
> > and files using regular unix permission handling. You would
> > then always use the file_operations that you defined for your
> > chardev but use that with inode_operations similar to tmpfs.
> 
> THANKS!  It would still be a kernel patch and still require
> root to set up but so would FUSE and your approach might be
> much lighter weight.

Correct. Of course the only need for root access is to set up
the fstab entry for the file system, which is not all that different
from allowing fuse user mounts.

	Arnd

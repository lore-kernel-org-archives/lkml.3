Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758900Ab3HJWHP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 18:07:15 -0400
Received: from 70-36-212-23.dsl.static.sonic.net ([70.36.212.23]:43051 "EHLO
	mail.linuxtoys.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758870Ab3HJWHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 18:07:13 -0400
Message-ID: <5206B994.9050603@linuxtoys.org>
Date: Sat, 10 Aug 2013 15:07:16 -0700
From: Bob Smith <bsmith@linuxtoys.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20100101 Firefox/19.0 SeaMonkey/2.16
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 001/001] CHAR DRIVERS: a simple device to give daemons
 a /sys-like interface
References: <20130804231958.GA25418@kroah.com> <20130809230150.GA23418@kroah.com> <52069DCA.6060706@linuxtoys.org> <201308102343.11147.arnd@arndb.de>
In-Reply-To: <201308102343.11147.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
>> GOAL
>> The goal of this patch was to make it possible to configure
>> daemons using simple file IO.  The litmus test for this is
>> that commands like these should be possible
>>          cat < /var/daemons/wpa_supplicant/use_channel
>>          echo 5 >/var/daemons/wpa_supplicant/use_channel

> If you want to have that behavior, I think the best way to
> do it would be new file system that combines aspects of
> tmpfs and debugfs, letting users with write access to the
> mount point (or a directory under it) create subdirectories
> and files using regular unix permission handling. You would
> then always use the file_operations that you defined for your
> chardev but use that with inode_operations similar to tmpfs.

THANKS!  It would still be a kernel patch and still require
root to set up but so would FUSE and your approach might be
much lighter weight.

thanks
Bob Smith




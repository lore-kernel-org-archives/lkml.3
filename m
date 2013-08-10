Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758864Ab3HJVnc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 17:43:32 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:50497 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758843Ab3HJVna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 17:43:30 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Bob Smith <bsmith@linuxtoys.org>
Subject: Re: [PATCH 001/001] CHAR DRIVERS: a simple device to give daemons a /sys-like interface
Date: Sat, 10 Aug 2013 23:43:10 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
References: <20130804231958.GA25418@kroah.com> <20130809230150.GA23418@kroah.com> <52069DCA.6060706@linuxtoys.org>
In-Reply-To: <52069DCA.6060706@linuxtoys.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201308102343.11147.arnd@arndb.de>
X-Provags-ID: V02:K0:RzAtEhDhK/zHuZYaK1ErwKJ2PIe8L0XA/PbtfMoBRKL
 0Nu9tosOAsFTRDkU7YbsK6kkxM9Mc48lvC+rhqVOHltel8ig/Z
 fxLMN9NwrAZDjTJJUDYdBEHiBBu+Qzw7E6caWduYm5+/nNNgHc
 lWJnABQeI1HeLzRbAhNquiamOfhCaU9xMKTlHO43htHotBxTzw
 HNbznavJXSt6WJna+mThaR9BgxTFWYW2WM65w/ULCK8tQdPemd
 xHa+4+rlK26BbKO9MlVINNjtMM0SkA1HWuYKzaBRL8HISZjTTr
 FnvBBFQUi6E5Tedeg/tQm6U34n1lV8gOqR/FnRORgIfEG0yaqM
 rCtdN19kwsM9BjyiCg14=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 10 August 2013, Bob Smith wrote:
> GOAL
> The goal of this patch was to make it possible to configure
> daemons using simple file IO.  The litmus test for this is
> that commands like these should be possible
>         cat < /var/daemons/wpa_supplicant/use_channel
>         echo 5 >/var/daemons/wpa_supplicant/use_channel
> 
> Yes, there are many other ways to configure a daemon but
> none with the simplicity and grace of file IO.  For proof
> of this I point to procfs and sysfs.

I'll try to keep out of the discussion about whether or not
another IPC mechanism with your desired semantics would be good
to have in the kernel, but one comment about implementing it:

If you want to have that behavior, I think the best way to
do it would be new file system that combines aspects of
tmpfs and debugfs, letting users with write access to the
mount point (or a directory under it) create subdirectories
and files using regular unix permission handling. You would
then always use the file_operations that you defined for your
chardev but use that with inode_operations similar to tmpfs.

	Arnd

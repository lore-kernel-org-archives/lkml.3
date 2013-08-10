Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758808Ab3HJU3h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 16:29:37 -0400
Received: from mail-ve0-f182.google.com ([209.85.128.182]:54012 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758785Ab3HJU3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 16:29:24 -0400
MIME-Version: 1.0
In-Reply-To: <52069DCA.6060706@linuxtoys.org>
References: <20130804231958.GA25418@kroah.com>
	<52003958.7080103@linuxtoys.org>
	<20130806094604.GE27889@kroah.com>
	<520299AB.1020607@linuxtoys.org>
	<20130807192714.GC2708@kroah.com>
	<5202A284.7010106@linuxtoys.org>
	<20130807195427.GB4121@kroah.com>
	<5202B674.7060005@linuxtoys.org>
	<20130807213325.GB5373@kroah.com>
	<520569B2.4000704@linuxtoys.org>
	<20130809230150.GA23418@kroah.com>
	<52069DCA.6060706@linuxtoys.org>
Date: Sat, 10 Aug 2013 22:29:23 +0200
Message-ID: <CAFLxGvwp79uqxHVy7A+SYMUnCFtCbtq1K=YppBx9j+R1oVC7PA@mail.gmail.com>
Subject: Re: [PATCH 001/001] CHAR DRIVERS: a simple device to give daemons a
 /sys-like interface
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Bob Smith <bsmith@linuxtoys.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 10, 2013 at 10:08 PM, Bob Smith <bsmith@linuxtoys.org> wrote:
> Greg Kroah-Hartman wrote:
>>
>> Otherwise, to accept this code, I need to see a way that normal users
>> can use it (i.e. no root or mknod), and that it can handle namespaces
>> and the security interface that the kernel has to support.  To do so
>> otherwise would be unfair to users who expect such a thing.
>
>
> Greg, I don't know the etiquette of the lkml but I think the
> above means "no, go away".
>
> OK.
> On my way out the door I'll give a recap and say thanks
>
>
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
>
> APPROACHES
> Modifying name pipes was rejected as being too complex.
> Modifying FUSE was rejected for the amount of effort needed.
> The method chosen was to create a small character device
> to pass the data between the client and the daemon.  The
> resulting code was small and simple but requires a device
> node.
>
> CONCLUSION
> Pseudo-ttys not withstanding, the kernel does not want
> IPC mechanisms that require root privileges or mknod.
> For this and other reasons this patch is rejected.
>
>
> Greg, once again thanks for your patience in helping a
> non-kernel guy through all of this.  Thanks.

/me read the whole thread and still does get why you can't use CUSE.
...or AF_UNIX.

If you really have an use case which is not covered by CUSE,
please fix CUSE.

> bye
> Bob Smith
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Thanks,
//richard

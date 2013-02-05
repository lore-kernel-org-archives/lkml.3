Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756282Ab3BECyw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 21:54:52 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43903 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754056Ab3BECyv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 21:54:51 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <1360032141.12062.12@driftwood>
References: <1359672699-23540-1-git-send-email-w.d.hubbs@gmail.com> <510AFCA1.5000700@zytor.com> <1360032141.12062.12@driftwood>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] init: fix name of root device in /proc/mounts
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 04 Feb 2013 18:54:32 -0800
To: Rob Landley <rob@landley.net>
CC: William Hubbs <w.d.hubbs@gmail.com>, linux-kernel@vger.kernel.org,
        mpagano@gentoo.org
Message-ID: <a6a99589-ac94-4cfc-a871-095431bfd8ef@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The difference is that it used to be customary to have a /dev/root symlink; iirc udev created one.  Devtmpfs does not (for largely valid reasons, but it does break some userspaces.)

Rob Landley <rob@landley.net> wrote:

>On 01/31/2013 05:22:09 PM, H. Peter Anvin wrote:
>> On 01/31/2013 02:51 PM, William Hubbs wrote:
>> > On a system that does not use an initramfs, /dev/root was always
>> > listed in /proc/mounts. This breaks software which scans  
>> /proc/mounts to
>> > determine which file systems are mounted since /dev/root is not a  
>> valid
>> > device name.
>> >
>> > This changes that processing so that "/dev/root" is only added to
>> > /proc/mounts if a root device is not specified with the root=  
>> option on
>> > the kernel command line.
>> >
>> > Signed-off-by: William Hubbs <w.d.hubbs@gmail.com>
>> 
>> Let me also point out that most of the time, the kernel actually has
>a
>> udev device name for an actual device...
>
>So your software is broken by overmounts? /dev/root is just one example
> 
>of this. (And you can specify a root= on the kernel command line and  
>have that be parsed by initramfs. I vaguely recall klibc does this...)
>
>For an example of how to parse this stuff, how about:
>
>   http://landley.net/hg/toybox/file/4ffb735aea59/toys/posix/df.c
>
>I.E. parse from the end of the list (most recent match is the  
>overmount), and eliminate synthetic filesystems. Note that code is from
> 
>2006, other people have managed to cope all this time...
>
>Rob

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.

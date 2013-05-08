Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757447Ab3EHQoJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 12:44:09 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58623 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756894Ab3EHQoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 12:44:07 -0400
Date: Wed, 8 May 2013 17:43:52 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Dan Williams <dcbw@redhat.com>,
        "'George0505'" <george0505@realtek.com>,
        Joon Ro <joonhyoung.ro@gmail.com>,
        Greg KH <gregkh@linux-foundation.org>
Subject: Re: Linux driver for Realtek RTL8723AU devices with USB ID 0bda:1724
 such as found in Lenovo IdeaPad Yoga 13
Message-ID: <20130508164351.GU25399@ZenIV.linux.org.uk>
References: <5159B52D.3050601@lwfinger.net>
 <5189B939.4010905@zytor.com>
 <518A7814.1070604@lwfinger.net>
 <518A7D56.3050502@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <518A7D56.3050502@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 08, 2013 at 09:29:10AM -0700, H. Peter Anvin wrote:
> Unlikely, since the kernel source tree is clean.
> 
> The error is on os_dep/os_intfs.c:
> 
> /home/hpa/kernel/rtl8723au/os_dep/os_intfs.c: In function
> ?rtw_proc_init_one?:
> /home/hpa/kernel/rtl8723au/os_dep/os_intfs.c:315:3: error: implicit
> declaration of function ?create_proc_entry?

create_proc_entry is gone (and good riddance); use proc_create()

> /home/hpa/kernel/rtl8723au/os_dep/os_intfs.c:322:3: error: implicit
> declaration of function ?create_proc_read_entry?

ditto.

> /home/hpa/kernel/rtl8723au/os_dep/os_intfs.c:370:7: error:
> dereferencing pointer to incomplete type

... and don't poke in proc_dir_entry innards, while we are at it.

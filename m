Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751611Ab3IICTe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 22:19:34 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:62600 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302Ab3IICTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 22:19:32 -0400
MIME-Version: 1.0
In-Reply-To: <20130909015945.GA4029@kroah.com>
References: <1378688580-11935-1-git-send-email-linux@roeck-us.net> <20130909015945.GA4029@kroah.com>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Mon, 9 Sep 2013 07:48:51 +0530
Message-ID: <CALkWK0kx+71O074dfP4ikj4FayU6GWXOByTFPgVjv=CVO-btUQ@mail.gmail.com>
Subject: Re: [PATCH] staging: Disable lustre file system for MIPS, SH, and XTENSA
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Guenter Roeck <linux@roeck-us.net>, LKML <linux-kernel@vger.kernel.org>,
        devel@driverdev.osuosl.org, Peng Tao <tao.peng@emc.com>,
        Peng Tao <bergwolf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Kroah-Hartman wrote:
> On Sun, Sep 08, 2013 at 06:03:00PM -0700, Guenter Roeck wrote:
>> mips allmodconfig fails with
>>
>> ERROR: "copy_from_user_page" [drivers/staging/lustre/lustre/libcfs/libcfs.ko]
>> undefined!
>>
>> which is due to LUSTRE using copy_from_user_page which is not exported by any
>> architecture.
>
> Any, or just these arches?

Arches, dungeon masters.

>> Unfortunately, LUSTRE can only be built as module, so there is no
>> easy fix.
>
> Can't we just export the functions for those arches?  Surely lutre
> isn't the first/only driver that needs this?

It's simply necessary to keep up to date: we can't keep building new
arches since the initial cost can be quite high.

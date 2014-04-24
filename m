Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758438AbaDXQPN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 12:15:13 -0400
Received: from mail-qa0-f50.google.com ([209.85.216.50]:46059 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756478AbaDXQPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 12:15:09 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <20140424160529.GD13573@quack.suse.cz>
References: <1397940833-6386-1-git-send-email-xypron.glpk@gmx.de>
 <20140422134044.GE366@quack.suse.cz> <CAKgNAkh=Shj6UO6x_KieQEYUoY+guokNute0iwUfiSYFJbeTfQ@mail.gmail.com>
 <20140422140747.GF366@quack.suse.cz> <20140424090441.GA6723@quack.suse.cz>
 <5359177E.1070907@gmx.de> <20140424160529.GD13573@quack.suse.cz>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Thu, 24 Apr 2014 18:14:48 +0200
Message-ID: <CAKgNAki+0VTA53ibaZy0e-Qt6STpUBsbQKMAUHr1ePd3hJPg7Q@mail.gmail.com>
Subject: Re: [PATCH 1/1] fanotify: check permissions when creating file descriptor
To: Jan Kara <jack@suse.cz>
Cc: Heinrich Schuchardt <xypron.glpk@gmx.de>, Eric Paris <eparis@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> This means a listener may have read authorization for /home and mark
>> this mount.
>> Afterwards, while you sign a git tag, it will receive a FAN_OPEN event
>> and use the file descriptor supplied in the event to overwrite your
>> /home/jankara/.gnupg/secring.pgp
>> though the file is chmod 600 and the listener is neither root nor you.
>   Ah, right. Thanks for explaining this to me. I'm not really too excited
> about this as a security issue because once the process has CAP_SYS_ADMIN
> it basically owns the machine (it is sadly one of those capabilities which
> is too broad)

Yup. https://lwn.net/Articles/486306/

> but I agree checking permissions when creating the fd is
> reasonable.
>
>                                                                 Honza
> --
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/

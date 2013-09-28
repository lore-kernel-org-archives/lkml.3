Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294Ab3I1Sy5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 14:54:57 -0400
Received: from mail-vb0-f45.google.com ([209.85.212.45]:40848 "EHLO
	mail-vb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479Ab3I1Syz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 14:54:55 -0400
MIME-Version: 1.0
In-Reply-To: <1380392082-23572-1-git-send-email-elad.wexler@gmail.com>
References: <1380392082-23572-1-git-send-email-elad.wexler@gmail.com>
Date: Sat, 28 Sep 2013 20:54:55 +0200
Message-ID: <CAFLxGvzWsr7RCtxOcZ2LO1dSmjt0Khr91JAcM_NykCYRtd2R8Q@mail.gmail.com>
Subject: Re: [PATCH] misc: cs5535-mfgpt: Replace 'module_init' with 'module_platform_driver'
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: elad.wexler@gmail.com
Cc: Arnd Bergmann <arnd@arndb.de>, Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 28, 2013 at 8:14 PM,  <elad.wexler@gmail.com> wrote:
> From: Elad Wexler <elad.wexler@gmail.com>
>
> Driver doesn't do anything special in 'module_init'.
>
> 'module_platform_init' makes the code more readable.
>
> Signed-off-by: Elad Wexler <elad.wexler@gmail.com>

NAK.

By moving to module_platform_init() you make this module unloadable.
Currently it is unloadable for good reasons.
The cs5535-mfgpt chip is nasty because it has no reliable reset function.
Therefore by unloading and loading the module again bad things can happen.

-- 
Thanks,
//richard

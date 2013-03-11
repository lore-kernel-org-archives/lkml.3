Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753650Ab3CKP3L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 11:29:11 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:64084 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929Ab3CKP3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 11:29:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Tim Gardner <tim.gardner@canonical.com>
Subject: Re: [PATCH linux-next] mfd: max8925: max8925_backlight_probe: Silence 'statement with no effect' warning
Date: Mon, 11 Mar 2013 15:29:03 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-8-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org
References: <1362939145-88329-1-git-send-email-tim.gardner@canonical.com>
In-Reply-To: <1362939145-88329-1-git-send-email-tim.gardner@canonical.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201303111529.03872.arnd@arndb.de>
X-Provags-ID: V02:K0:JdCDeQohOjjC0VHbLnXQIBYhaZ+cLZTRDyz4/ZtoM2l
 qkdwOP4Tke6NEtZYGi3LIC0/qfrlgfe3aTnYJF7tizg4RLacwg
 yspt/86xkj3z4WvVb1yKzVoG0W4tJNDLKA0jOIUy3qt38xa5qW
 kroSldRsImiMSZ98VWWvK0b8yStybRNead8leAIGu+YpfQy6MW
 1Zd+Duce7EhNb0xS6EXSjKqYhDNgEWOoViu2ICK6veXRGYoByr
 isPoClYUfs8oc9gj8IGONFwzxcuS70hdywLeWDC0gCeKkdrL9P
 A6P+GR9nFqjnwcGxzkb/tvCjx2i8ukHp9NbDGXjZ1kp8WFpUd6
 X/0EJlEFxlDYvR6EHRls=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 10 March 2013, Tim Gardner wrote:
> drivers/video/backlight/max8925_bl.c: In function 'max8925_backlight_probe':
> drivers/video/backlight/max8925_bl.c:177:3: warning: statement with no effect [-Wunused-value]
> 
> gcc version 4.6.3
> 
> Convert max8925_backlight_dt_init() to an 'inline void' since it is only
> called from one place where the return code is ignored. Protect the
> guts of the function with '#ifdef CONFIG_OF'.
> 
> Cc: Richard Purdie <rpurdie@rpsys.net>
> Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
> Cc: linux-fbdev@vger.kernel.org
> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
> ---
>  drivers/video/backlight/max8925_bl.c |    9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)

I had already sent a better patch for this earlier, see "mfd: max8925:
fix trivial build warning for non-dt". Unfortunately when I looked into
the problem again, I found more problems with the original patches,
apparently the DT bindings were never properly reviewed. It may be
better to revert the original patch for 3.9 and do it better for 3.10.

	Arnd

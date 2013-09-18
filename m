Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751614Ab3IRO26 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 10:28:58 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:18699 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344Ab3IRO25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 10:28:57 -0400
Date: Wed, 18 Sep 2013 17:28:37 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: keescook@chromium.org, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, joe@perches.com, linux@horizon.com,
        JBeulich@suse.com, kosaki.motohiro@gmail.com,
        akpm@linux-foundation.org
Subject: Re: [PATCH 0/2] vsprintf: ignore %n again
Message-ID: <20130918142837.GU19256@mwanda>
References: <1379317437-28329-1-git-send-email-keescook@chromium.org>
 <20130916155504.GC13318@ZenIV.linux.org.uk>
 <CAGXu5jK2d+9m0uA84nGbZ5E=s974NRn+Sxz3iRcTsFWqWFTGNQ@mail.gmail.com>
 <201309182214.IDD13060.FFOVJOLOFQtHSM@I-love.SAKURA.ne.jp>
 <20130918141104.GT19256@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130918141104.GT19256@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 18, 2013 at 05:11:04PM +0300, Dan Carpenter wrote:
>  asmlinkage __printf(1, 2) __cold
>  int printk(const char *fmt, ...);
> +#define printk(fmt, ...) do {				  \
> +	compiletime_assert(__builtin_constant_p(fmt),     \
> +			   "Non-constant format string"); \
> +	printk(fmt, ##__VA_ARGS__);			  \
> +} while (0)

Oops...  That breaks the compile for printk.c.

Also don't we want 'const char fmt[] = "foo %s";' to be a valid format
string?

regards,
dan carpenter

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757083Ab3IKT2k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 15:28:40 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:50184 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890Ab3IKT2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 15:28:39 -0400
Date: Wed, 11 Sep 2013 22:28:21 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Joe Perches <joe@perches.com>
Cc: Kees Cook <keescook@chromium.org>, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Lidza Louina <lidza.louina@gmail.com>,
        Tushar Behera <tushar.behera@linaro.org>
Subject: Re: [PATCH] staging: dgnc: fix potential format string flaw
Message-ID: <20130911192821.GG25896@mwanda>
References: <20130911044116.GA17294@www.outflux.net>
 <1378875632.606.5.camel@joe-AO722>
 <CAGXu5jLm1RNp4mB2KfeRumTqeWgcAsZ4CpQQQGA67WukERefXQ@mail.gmail.com>
 <20130911093118.GD25896@mwanda>
 <CAGXu5j+H_RLwj9c6CKxMpaYeR9kS-qDnK+e1mOHHt9zh6vAm=w@mail.gmail.com>
 <1378926562.4714.11.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378926562.4714.11.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  * %n is ignored

Really it should trigger a WARN_ON_ONCE().  There is code like
show_console_dev() which relies on it to work.  If we ignore %n it
causes another bug.

regards,
dan carpenter


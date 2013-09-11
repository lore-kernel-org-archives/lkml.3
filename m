Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333Ab3IKJbo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 05:31:44 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:41859 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572Ab3IKJbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 05:31:42 -0400
Date: Wed, 11 Sep 2013 12:31:18 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Kees Cook <keescook@chromium.org>
Cc: Joe Perches <joe@perches.com>, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tushar Behera <tushar.behera@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Lidza Louina <lidza.louina@gmail.com>
Subject: Re: [PATCH] staging: dgnc: fix potential format string flaw
Message-ID: <20130911093118.GD25896@mwanda>
References: <20130911044116.GA17294@www.outflux.net>
 <1378875632.606.5.camel@joe-AO722>
 <CAGXu5jLm1RNp4mB2KfeRumTqeWgcAsZ4CpQQQGA67WukERefXQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jLm1RNp4mB2KfeRumTqeWgcAsZ4CpQQQGA67WukERefXQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 10:19:17PM -0700, Kees Cook wrote:
> In the former case, format characters will get processed by the
> sprintf logic. In the latter, they are printed as-is. In this specific
> case, if there was a way to inject strings like "ohai %n" into the
> msgbuf string, the former would actually attempt to resolve the %n. In
> the simple case, this could lead to Oopses, and in the unlucky case,
> it could allow arbitrary memory writing and execution control.
> 
> http://en.wikipedia.org/wiki/Uncontrolled_format_string

The kernel ignores %n so hopefully it can't actually write to memory.

regards,
dan carpenter


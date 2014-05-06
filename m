Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578AbaEFT7h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 15:59:37 -0400
Received: from mail-qg0-f44.google.com ([209.85.192.44]:45404 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754460AbaEFT7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 15:59:35 -0400
MIME-Version: 1.0
In-Reply-To: <20140506084749.GT26890@mwanda>
References: <1399364528-3727-1-git-send-email-martink@posteo.de>
	<20140506084749.GT26890@mwanda>
Date: Tue, 6 May 2014 12:59:34 -0700
X-Google-Sender-Auth: 1a3Plpjwuem22MHYcTRnU4hOkBc
Message-ID: <CANeU7QmZXJ0KqVvkLfqxF6CGx81KQ93S++ViR9smWRTj8_6Dtg@mail.gmail.com>
Subject: Re: [PATCH] staging: rtl8192u: initialize array in C compliant way
From: Christopher Li <sparse@chrisli.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Martin Kepplinger <martink@posteo.de>,
        Greg KH <gregkh@linuxfoundation.org>, devel@driverdev.osuosl.org,
        linux-kernel <linux-kernel@vger.kernel.org>, burzalodowa@gmail.com,
        Linux-Sparse <linux-sparse@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 6, 2014 at 1:47 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
>> -     bool                            search_dir[4] = {0, 0, 0, 0};
>> +     bool                            search_dir[4] = {0};
>
> That's weird.  The original code is valid but it generates a sparse
> warning.
>
> drivers/staging/rtl8192u/ieee80211/rtl819x_TSProc.c:244:58: warning: Initializer entry defined twice
> drivers/staging/rtl8192u/ieee80211/rtl819x_TSProc.c:244:61:   also defined here
>
> It has something to do with "_Bool" types.  Changing it to "int" will
> also make the warning disappear.  I've CC'd the sparse list to see if
> anyone knows what's happening.

This is easy reproducible with a small test case. It is a sparse bug for sure.

Let me take a look.

Chris

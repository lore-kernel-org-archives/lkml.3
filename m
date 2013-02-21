Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577Ab3BUUZ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 15:25:28 -0500
Received: from mail-ve0-f178.google.com ([209.85.128.178]:39704 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861Ab3BUUZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 15:25:26 -0500
MIME-Version: 1.0
In-Reply-To: <20130221184010.GA24692@kroah.com>
References: <20130221184010.GA24692@kroah.com>
Date: Thu, 21 Feb 2013 12:25:24 -0800
X-Google-Sender-Auth: ORu5TcskNdqJwBGObyN9NHDvPJY
Message-ID: <CA+55aFwjbGRvGHhQQ7vUYP+wChp_ZBQ54ZFxzrRjTkdffcteWQ@mail.gmail.com>
Subject: Re: [GIT PATCH] USB patches for 3.9-rc1
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Greg KH <gregkh@linuxfoundation.org>,
        Thierry Reding <thierry.reding@avionic-design.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2013 at 10:40 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
>
> USB patches for 3.9-rc1
>
> Here's the big USB merge for 3.9-rc1
>
> Nothing major, lots of gadget fixes, and of course, xhci stuff.

Ok, so there were a couple of conflicts with Thierry Reding's series
to convert devm_request_and_ioremap() users into
devm_ioremap_resource(), where some of the old users had been
converted to use other helper functions (eg omap_get_control_dev()).

I left the omap_get_control_dev() users alone, but I do want to note
that omap_control_usb_probe() itself now uses that
devm_request_and_ioremap() function. And I did *not* extend the merge
to do that kind of conversion in the helper function, so I'm assuming
Thierry might want to extend his work. Assuming people care enough..

                Linus

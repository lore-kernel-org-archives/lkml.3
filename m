Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785Ab3CSACW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 20:02:22 -0400
Received: from mail-vb0-f43.google.com ([209.85.212.43]:33149 "EHLO
	mail-vb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754192Ab3CSACU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 20:02:20 -0400
MIME-Version: 1.0
In-Reply-To: <20130318230922.GA23175@kroah.com>
References: <1363215451-26111-1-git-send-email-jwerner@chromium.org>
	<20130318230922.GA23175@kroah.com>
Date: Mon, 18 Mar 2013 17:02:19 -0700
X-Google-Sender-Auth: xH6oaBmOUIyC7u_E2GzJxGJxlTk
Message-ID: <CAODwPW9c6NpDOzmh+q312qLn0fS+eQttQDGdCe0b2EigoJ9_PA@mail.gmail.com>
Subject: Re: [PATCH] usb: Make USB persist default configurable
From: Julius Werner <jwerner@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Lan Tianyu <tianyu.lan@intel.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Sameer Nanda <snanda@chromium.org>,
        Vincent Palatin <vpalatin@chromium.org>,
        Luigi Semenzato <semenzato@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Why can't you just revert this in userspace?  Isn't that easier than
> doing a kernel patch and providing an option that we need to now
> maintain for pretty much forever?

I could solve it in userspace, but that really feels like a hacky
workaround and not a long term solution. It would mean that every new
device starts with persist enabled and stays that way for a few
milliseconds (maybe up to seconds if it's connected on boot), until
userspace gets around to disable it again... opening the possibility
for very weird race conditions and bugs with drivers/devices that
don't work with persist. This default is a policy that really resides
in the kernel, it has changed in the past, and since there is no
definitive better choice for all cases I thought making it
configurable is the right thing to do.

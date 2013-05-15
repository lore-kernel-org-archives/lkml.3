Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933109Ab3EOUvX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 16:51:23 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:64648 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932698Ab3EOUvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 16:51:21 -0400
MIME-Version: 1.0
In-Reply-To: <20130515035714.GB17398@xanatos>
References: <1368160971-2176-1-git-send-email-jwerner@chromium.org>
	<20130515035714.GB17398@xanatos>
Date: Wed, 15 May 2013 13:51:20 -0700
X-Google-Sender-Auth: DYlisuWq4h0BHqRciGDr3mfA8lE
Message-ID: <CAODwPW8bPPNwWDOd0MeCTZgXPmFpBgenZGeYfvhpG7owOx_zeA@mail.gmail.com>
Subject: Re: [PATCH] usb: xhci: Consolidate XHCI TD Size calculation
From: Julius Werner <jwerner@chromium.org>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Julius Werner <jwerner@chromium.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-usb@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Vincent Palatin <vpalatin@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Does this patch fix the control transfer data stage issue?  Please break
> this into a bug fix for that, with your refactoring on top of that.  We
> need to backport the bug fix to the stable kernels, and queue the
> refactoring for 3.11.

I don't think there is really any practial adverse effect from the
wrong TD length in control transfers, since it has been there forever
and not caused any problems. I don't think it's worth a backport to
older kernels, I'd just like it fixed (and cleaner) for readability's
sake moving forward.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761486Ab3JQAxb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 20:53:31 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:64912 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760722Ab3JQAx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 20:53:29 -0400
MIME-Version: 1.0
In-Reply-To: <20131016235730.GK7082@xanatos>
References: <1381872227-24757-1-git-send-email-jwerner@chromium.org>
	<525DB456.1040006@cogentembedded.com>
	<CAODwPW-wKtN9JhoJCs+LoBx4Pj65+pozKv=ycLQJfsL1k28zEQ@mail.gmail.com>
	<1381884300-403-1-git-send-email-jwerner@chromium.org>
	<20131016235730.GK7082@xanatos>
Date: Wed, 16 Oct 2013 17:53:28 -0700
X-Google-Sender-Auth: CXR8UmyNVXeC5CkeVvriNxpd8Ac
Message-ID: <CAODwPW9Vi_Xv6isp0rvWXXextwMz5UuhViHNk6hQ9w5C4rTqPw@mail.gmail.com>
Subject: Re: [PATCH v2] usb: hub: Clear Port Reset Change during init/resume
From: Julius Werner <jwerner@chromium.org>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Julius Werner <jwerner@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Benson Leung <bleung@chromium.org>,
        Vincent Palatin <vpalatin@chromium.org>,
        Duncan Laurie <dlaurie@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Did you run into an issue where port status change events weren't being
> generated because the Port Reset flag was set?  I'm trying to figure out
> if this addresses a real issue you hit (and thus should be queued for
> stable), or if this is just a precaution.

As Benson said, we're seeing this on the HP Chromebook 14 (Intel
LynxPoint xHC). It only happens after system suspend/resume, so I'm
not sure if there even is an xHC reset involved (not by the kernel
anyway, but with all that other stuff it's hard to say). Note that we
build our own firmware (including SMM/ACPI handlers), so this does not
directly translate to LynxPoint PCs, but I think we based some of our
code off Intel reference code and guides which may have already
included the problem. I've found port reset code in both our firmware
resume path and ACPI _PS0 handler, but they both seem to clear all
Port Change bits correctly, so we are not sure about our true root
cause yet.

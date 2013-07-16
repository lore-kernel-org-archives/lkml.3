Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933559Ab3GPRcc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 13:32:32 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:34012 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933059Ab3GPRcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 13:32:31 -0400
MIME-Version: 1.0
In-Reply-To: <CALkWK0=qw_K=6+6btjzcMS9VmDdVbF++rN=3-=Kgzu-3xSErrQ@mail.gmail.com>
References: <1373993525-25629-1-git-send-email-artagnon@gmail.com>
 <51E57BC1.4090904@nod.at> <CALkWK0nrDsZiHe2==DQZuHV7id=6gc4UHUj1xXu9jN5cr3SUcQ@mail.gmail.com>
 <51E57DF3.90304@nod.at> <CALkWK0m0LkjFzOUXRQmdDuS+L7mKA87qCMq=MYX6UrnHXi+XRg@mail.gmail.com>
 <CALkWK0=qw_K=6+6btjzcMS9VmDdVbF++rN=3-=Kgzu-3xSErrQ@mail.gmail.com>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Tue, 16 Jul 2013 23:01:50 +0530
Message-ID: <CALkWK0kN8Lprp5RoBSjBngJG08LwbVy-oaWaHfzLHZc_OMueyA@mail.gmail.com>
Subject: Re: [PATCH] um/configs: don't use devtmpfs in defconfig
To: Richard Weinberger <richard@nod.at>
Cc: LKML <linux-kernel@vger.kernel.org>, Jeff Dike <jdike@addtoit.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ramkumar Ramachandra wrote:
> Ramkumar Ramachandra wrote:
>> No, systemd does not have a hard dependency on devtmpfs.
>
> Wait, let me double-check that.

Sorry about the stupidity; devtmpfs is very much a hard dependency.  I
just realized that CONFIG_VT is on, and can't be turned off (!).  See
drivers/tty/Kconfig:

  config VT
  	  bool "Virtual terminal" if EXPERT
	  depends on !S390 && !UML

Wait, shouldn't it be always off then?

*scratches head*

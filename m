Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128AbaDVMzn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 08:55:43 -0400
Received: from mail-ig0-f174.google.com ([209.85.213.174]:53310 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbaDVMzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 08:55:38 -0400
MIME-Version: 1.0
In-Reply-To: <53566428.9080005@redhat.com>
References: <1395256011-2423-1-git-send-email-dh.herrmann@gmail.com>
	<5343F2EC.3050508@redhat.com>
	<CANq1E4TmtR=gSgR25PGC_EN=xrEEg1+F=zkTUGXZ4SHvjFNbag@mail.gmail.com>
	<535631EB.4060906@redhat.com>
	<CANq1E4TufnELwEDZAkzH94Zn3gb46qvxfDboN5y2mK=Q2gk9-Q@mail.gmail.com>
	<53566428.9080005@redhat.com>
Date: Tue, 22 Apr 2014 14:55:37 +0200
Message-ID: <CANq1E4QBTSrzk9M8N_YUmWdj44Y-vO5cXYh+ibXbJ++g=6vh5A@mail.gmail.com>
Subject: Re: [PATCH 0/6] File Sealing & memfd_create()
From: David Herrmann <dh.herrmann@gmail.com>
To: Florian Weimer <fweimer@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Kay Sievers <kay@vrfy.org>,
        Daniel Mack <zonque@gmail.com>,
        Lennart Poettering <lennart@poettering.net>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Tue, Apr 22, 2014 at 2:44 PM, Florian Weimer <fweimer@redhat.com> wrote:
> I didn't find that very convincing.  But in v2, seals are monotonic, so
> checking them should be reliable enough.

Ok.

> What happens when you create a loop device on a write-sealed descriptor?

Any write-back to the loop-device will fail with EPERM as soon as the
fd gets write-sealed. See __do_lo_send_write() in
drivers/block/loop.c. It's up to the loop-device to forward the error
via bio_endio() to the caller for proper error-handling.

Thanks
David

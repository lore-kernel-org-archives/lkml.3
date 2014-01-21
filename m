Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272AbaAURPG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 12:15:06 -0500
Received: from mail-vb0-f51.google.com ([209.85.212.51]:34936 "EHLO
	mail-vb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755029AbaAURPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 12:15:03 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.02.1401210007390.27813@tundra.namei.org>
References: <alpine.LRH.2.02.1401210007390.27813@tundra.namei.org>
Date: Tue, 21 Jan 2014 09:15:01 -0800
X-Google-Sender-Auth: oFF9UqpA05cEnESyh-mEpoTGIFY
Message-ID: <CA+55aFzAHNybM9bqb1gxAeOw-+z8=kSQvgwMDoUL3kXVfhcn8w@mail.gmail.com>
Subject: Re: [GIT] Security subsystem changes for 3.14
From: Linus Torvalds <torvalds@linux-foundation.org>
To: James Morris <jmorris@namei.org>, Peter Huewe <peterhuewe@gmx.de>
Cc: LSM List <linux-security-module@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since I got a conflict on this one and had to look at the code:

On Mon, Jan 20, 2014 at 5:11 AM, James Morris <jmorris@namei.org> wrote:
>
> Peter Huewe (5):
>       tpm/tpm_ppi: Check return value of acpi_get_name

that commit looks wrong (and mainline had fixed it correctly in the meantime).

The problem with

+       if (ACPI_FAILURE(status))
+               return status;

is that this is a callback for acpi_walk_namespace(), and returning a
failure status means that the walk will be interrupted.

So you actually want to return AE_OK if the acpi_get_name() call
fails, because that just skips the failing node. Returning failure
will skip *all* the nodes.

In practice it probably doesn't matter (acpi_get_name() isn't supposed
to fail), but I thought I'd point it out since I had to stare at the
conflict.

                  Linus

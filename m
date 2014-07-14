Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018AbaGNPIi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 11:08:38 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:59074 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755944AbaGNPIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 11:08:31 -0400
MIME-Version: 1.0
In-Reply-To: <1404241875-29164-1-git-send-email-agrover@redhat.com>
References: <1404241875-29164-1-git-send-email-agrover@redhat.com>
Date: Mon, 14 Jul 2014 17:08:30 +0200
Message-ID: <CAJSP0QVa_e+sDHGqdFskfgGHYudz3+3i-NPMtiheWKfDqSQ_Tw@mail.gmail.com>
Subject: Re: [RFC 0/2] target: userspace pass-through backend
From: Stefan Hajnoczi <stefanha@gmail.com>
To: Andy Grover <agrover@redhat.com>
Cc: target-devel <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>, shli@kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 1, 2014 at 9:11 PM, Andy Grover <agrover@redhat.com> wrote:
> Shaohua Li wrote an initial implementation of this, late last year[1].
> Starting from that, I started working on some alternate implementation
> choices, and ended up with something rather different.
>
> Please take a look and let me know what you think. Patch 1 is a
> design and overview doc, and patch 2 is the actual code, along with
> implementation rationale.
>
> Thanks -- Andy
>
> [1] http://thread.gmane.org/gmane.linux.scsi.target.devel/5044
>
> Andy Grover (2):
>   target: Add documentation on the target userspace pass-through driver
>   target: Add a user-passthrough backstore
>
>  Documentation/target/tcmu-design.txt   |  210 +++++++
>  drivers/target/Kconfig                 |    5 +
>  drivers/target/Makefile                |    1 +
>  drivers/target/target_core_transport.c |    4 +
>  drivers/target/target_core_user.c      | 1078 ++++++++++++++++++++++++++++++++
>  drivers/target/target_core_user.h      |  126 ++++
>  6 files changed, 1424 insertions(+)
>  create mode 100644 Documentation/target/tcmu-design.txt
>  create mode 100644 drivers/target/target_core_user.c
>  create mode 100644 drivers/target/target_core_user.h

Hi Andy,
Just wanted to let you know that a userspace backstore would
potentially be useful for QEMU.  QEMU supports a number of disk image
formats (VMDK, VHDX, qcow2, and more).  Make these available as SCSI
LUNs on the host or to remote SCSI initiators is cool.

We currently have a tool called qemu-nbd that exports disk images
using the Network Block Device protocol.  Your userspace backstore
provides other options like iSCSI target or loopback access on the
host.

I took a quick look at the patch and imagine it's not hard to hook up
to QEMU.  Looks promising!

Stefan

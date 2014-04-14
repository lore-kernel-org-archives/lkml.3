Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553AbaDNADY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 20:03:24 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:44646 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094AbaDNADX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 20:03:23 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrWYRmkM3hyYu8WmSd-M=3mNMU2=xF_bSuTfyfkUTys5sg@mail.gmail.com>
References: <53470E26.2030306@cybernetics.com>
	<CANq1E4RWf_VbzF+dPYhzHKJvnrh86me5KajmaaB1u9f9FLzftA@mail.gmail.com>
	<5347451C.4060106@amacapital.net>
	<5347F188.10408@cybernetics.com>
	<CANq1E4T=38VLezGH2XUZ9kc=Vtp6Ca++-ATwmEfaXZS6UrTPig@mail.gmail.com>
	<53486067.6090506@mit.edu>
	<CANq1E4TBtRcN+tpQW9bozQkRjJ7BJCK+KO0iw5k+8Q3Y3TcUeQ@mail.gmail.com>
	<CALCETrWYRmkM3hyYu8WmSd-M=3mNMU2=xF_bSuTfyfkUTys5sg@mail.gmail.com>
Date: Mon, 14 Apr 2014 02:03:22 +0200
Message-ID: <CANq1E4SU3QfLwBDEwDVGS7HNxOC2m2hjnv=ZuM1i+jCqqDM=sA@mail.gmail.com>
Subject: Re: [PATCH 2/6] shm: add sealing API
From: David Herrmann <dh.herrmann@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Tony Battersby <tonyb@cybernetics.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Sat, Apr 12, 2014 at 12:07 AM, Andy Lutomirski <luto@amacapital.net> wrote:
> I bet this is missing from lots of places.  For example, I can't find
> any write_access stuff in the rdma code.
>
> I suspect that the VM_DENYWRITE code is just generally racy.

So what does S_IMMUTABLE do to prevent such races? I somehow suspect
it's broken in that regard, too.

I really dislike pinning pages like this, but if people want to keep
it I guess I have to scan all shmem-inode pages before changing seals.

Thanks
David

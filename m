Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501AbaDKWID (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 18:08:03 -0400
Received: from mail-qg0-f50.google.com ([209.85.192.50]:45246 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755404AbaDKWH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 18:07:58 -0400
MIME-Version: 1.0
In-Reply-To: <CANq1E4TBtRcN+tpQW9bozQkRjJ7BJCK+KO0iw5k+8Q3Y3TcUeQ@mail.gmail.com>
References: <53470E26.2030306@cybernetics.com> <CANq1E4RWf_VbzF+dPYhzHKJvnrh86me5KajmaaB1u9f9FLzftA@mail.gmail.com>
 <5347451C.4060106@amacapital.net> <5347F188.10408@cybernetics.com>
 <CANq1E4T=38VLezGH2XUZ9kc=Vtp6Ca++-ATwmEfaXZS6UrTPig@mail.gmail.com>
 <53486067.6090506@mit.edu> <CANq1E4TBtRcN+tpQW9bozQkRjJ7BJCK+KO0iw5k+8Q3Y3TcUeQ@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 11 Apr 2014 15:07:38 -0700
Message-ID: <CALCETrWYRmkM3hyYu8WmSd-M=3mNMU2=xF_bSuTfyfkUTys5sg@mail.gmail.com>
Subject: Re: [PATCH 2/6] shm: add sealing API
To: David Herrmann <dh.herrmann@gmail.com>
Cc: Tony Battersby <tonyb@cybernetics.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2014 at 2:42 PM, David Herrmann <dh.herrmann@gmail.com> wrote:
> Hi
>
> On Fri, Apr 11, 2014 at 11:36 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>> A quick grep of the kernel tree finds exactly zero code paths
>> incrementing i_mmap_writable outside of mmap and fork.
>>
>> Or do you mean a different kind of write ref?  What am I missing here?
>
> Sorry, I meant i_writecount.

I bet this is missing from lots of places.  For example, I can't find
any write_access stuff in the rdma code.

I suspect that the VM_DENYWRITE code is just generally racy.

--Andy

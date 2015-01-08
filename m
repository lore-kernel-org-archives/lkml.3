Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407AbbAHOL4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 09:11:56 -0500
Received: from mail-qg0-f45.google.com ([209.85.192.45]:52626 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063AbbAHOLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 09:11:55 -0500
MIME-Version: 1.0
X-Originating-IP: [46.139.80.5]
In-Reply-To: <CAB9dFdsohFORUpBTXuE-QkvmrdebwWm9+9Z8mwVAjDYUmWkqZw@mail.gmail.com>
References: <CAB9dFdty+3JXgJqhMNNHuDXivx9_paK2=zd7Vb_D4-suU6OGBg@mail.gmail.com>
	<20150105171141.GA19011@tucsk>
	<CAB9dFdsohFORUpBTXuE-QkvmrdebwWm9+9Z8mwVAjDYUmWkqZw@mail.gmail.com>
Date: Thu, 8 Jan 2015 15:11:54 +0100
Message-ID: <CAJfpegunAg41Zi6X21C6qzDtECMVxtvs_BXgbF14=UB29HGWEA@mail.gmail.com>
Subject: Re: [GIT PULL] fuse update for 3.19
From: Miklos Szeredi <miklos@szeredi.hu>
To: Marc Dionne <marc.c.dionne@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 5, 2015 at 6:33 PM, Marc Dionne <marc.c.dionne@gmail.com> wrote:
> On Mon, Jan 5, 2015 at 1:11 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> On Wed, Dec 24, 2014 at 12:53:13PM -0400, Marc Dionne wrote:
>>
>>> Commit 7078187a795f ("fuse: introduce fuse_simple_request() helper")
>>> from the above pull request triggers some EIO errors for me in some
>>> tests that rely on fuse.
>>>
>>> Looking at the code changes and a bit of debugging info I think
>>> there's a general problem here that fuse_get_req checks and possibly
>>> waits for fc->initialized, and this was always called first.  But this
>>> commit changes the ordering and in many places fc->minor is now
>>> possibly used before fuse_get_req, and we can't be sure that fc has
>>> been initialized.  In my case fuse_lookup_init sets
>>> req->out.args[0].size to the wrong size because fc->minor at that
>>> point is still 0, leading to the EIO error.
>>>
>>> Assuming the analysis makes sense, it wasn't obvious what the best fix
>>> should be.
>>
>> Here's a patch to fix this.  Could you please give it a try?
>>
>> Thanks,
>> Miklos
>
> Works fine with my test case that fails on current master.

Thanks for testing.   Will push to Linus.

Thanks,
Miklos

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706AbbAERdI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 12:33:08 -0500
Received: from mail-ob0-f180.google.com ([209.85.214.180]:40120 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753089AbbAERdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 12:33:07 -0500
MIME-Version: 1.0
In-Reply-To: <20150105171141.GA19011@tucsk>
References: <CAB9dFdty+3JXgJqhMNNHuDXivx9_paK2=zd7Vb_D4-suU6OGBg@mail.gmail.com>
	<20150105171141.GA19011@tucsk>
Date: Mon, 5 Jan 2015 13:33:05 -0400
Message-ID: <CAB9dFdsohFORUpBTXuE-QkvmrdebwWm9+9Z8mwVAjDYUmWkqZw@mail.gmail.com>
Subject: Re: [GIT PULL] fuse update for 3.19
From: Marc Dionne <marc.c.dionne@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 5, 2015 at 1:11 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Wed, Dec 24, 2014 at 12:53:13PM -0400, Marc Dionne wrote:
>
>> Commit 7078187a795f ("fuse: introduce fuse_simple_request() helper")
>> from the above pull request triggers some EIO errors for me in some
>> tests that rely on fuse.
>>
>> Looking at the code changes and a bit of debugging info I think
>> there's a general problem here that fuse_get_req checks and possibly
>> waits for fc->initialized, and this was always called first.  But this
>> commit changes the ordering and in many places fc->minor is now
>> possibly used before fuse_get_req, and we can't be sure that fc has
>> been initialized.  In my case fuse_lookup_init sets
>> req->out.args[0].size to the wrong size because fc->minor at that
>> point is still 0, leading to the EIO error.
>>
>> Assuming the analysis makes sense, it wasn't obvious what the best fix
>> should be.
>
> Here's a patch to fix this.  Could you please give it a try?
>
> Thanks,
> Miklos

Works fine with my test case that fails on current master.

Thanks,
Marc

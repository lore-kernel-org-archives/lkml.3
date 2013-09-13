Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757488Ab3IMCIl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 22:08:41 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:37917 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757314Ab3IMCIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 22:08:37 -0400
MIME-Version: 1.0
In-Reply-To: <87ioy536mu.fsf@rustcorp.com.au>
References: <1378955676-12708-1-git-send-email-peter.chen@freescale.com> <87ioy536mu.fsf@rustcorp.com.au>
From: Lucas De Marchi <lucas.de.marchi@gmail.com>
Date: Thu, 12 Sep 2013 23:08:15 -0300
Message-ID: <CAKi4VAJ5=zsJzyQNprchB2wnwh0+gg2oNP2PFsa4Lcw++3mSig@mail.gmail.com>
Subject: Re: [RFC PATCH 1/1] module: Make wait module's refcount to zero
 procedure as async
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Peter Chen <peter.chen@freescale.com>, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 9:30 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> Peter Chen <peter.chen@freescale.com> writes:
>> Currently, if module's refcount is not zero during the unload,
>> it waits there until the user decreases that refcount.
>
> Hi Peter,
>
>         In practice userspace uses O_NONBLOCK.  In fact, I've been
> thinking of removing the blocking case altogether, since it's not really
> what people want.
>
> That would solve your problem and make the code simpler.  Thoughts?

I'm all in favor of this. It's been almost 1 year it's deprecated in
kmod and if anyone tries to use we force a 10s delay on module
removal. So far nobody complained.

Lucas De Marchi

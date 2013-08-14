Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932930Ab3HNStf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 14:49:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46986 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932840Ab3HNStc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 14:49:32 -0400
Date: Wed, 14 Aug 2013 20:43:52 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Rui Xiang <rui.xiang@huawei.com>
Cc: Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] userns: initialize the depth of user_namespace chain
Message-ID: <20130814184352.GA6381@redhat.com>
References: <520B0FCF.5080809@huawei.com> <CALCETrUJTMVo4sCiVRHvVocja3Q9_hXPdc1xQ0D+EtPUT_2T7w@mail.gmail.com> <520B2768.1090001@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <520B2768.1090001@huawei.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14, Rui Xiang wrote:
>
> On 2013/8/14 13:06, Andy Lutomirski wrote:
> > On Tue, Aug 13, 2013 at 10:04 PM, Rui Xiang <rui.xiang@huawei.com> wrote:
> >> The level of init_user_ns shoule be 1.
> >
> > What's wrong with zero?
> >
>
> No problem. It is just consistent with commit 8742f229b63, IMHO.

Well, I am fine either way,

> but the initialization of level should be necessary.

but it is not necessary. This is just an "arbitrary" limit for now,
32 non-root namespaces. Perhaps we should count init_user_ns too.

Hmm. but I just realized that "> 32" in create_user_ns() should be
">= 32" in this case.

Oleg.


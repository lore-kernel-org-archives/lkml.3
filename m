Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715AbaIXQPb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 12:15:31 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:38186 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537AbaIXQP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 12:15:29 -0400
MIME-Version: 1.0
In-Reply-To: <CAHA+R7NfJYzCsZx0E9YVXKVCQbCm_thPSi+80tix8Z9nVA82Ug@mail.gmail.com>
References: <1411478430-4989-1-git-send-email-nicolas.dichtel@6wind.com>
	<CAHA+R7NnBJ=T3sukzzp-OD2am1nd318XbrXCX84LfSL=nu9ojw@mail.gmail.com>
	<54228D87.3070309@6wind.com>
	<CAHA+R7NfJYzCsZx0E9YVXKVCQbCm_thPSi+80tix8Z9nVA82Ug@mail.gmail.com>
Date: Wed, 24 Sep 2014 09:15:27 -0700
Message-ID: <CAHA+R7MVL=WpepRy8iz6iT6Kkq1RHG+b9TxJothP94ixyAj-3Q@mail.gmail.com>
Subject: Re: [RFC PATCH net-next v2 0/5] netns: allow to identify peer netns
From: Cong Wang <cwang@twopensource.com>
To: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc: netdev <netdev@vger.kernel.org>, containers@lists.linux-foundation.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-api@vger.kernel.org, David Miller <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 9:01 AM, Cong Wang <cwang@twopensource.com> wrote:
>
> And clearly you missed my question above: how do you get netns id
> without sharing /var/run/netns/ ?

OK, I found it:

> Ids are stored in the parent user namespace. These ids are valid only inside
> this user namespace. The user can retrieve these ids via a new netlink messages,
> but only if peer netns are in the same user namespace.

So your example is confusing, perhaps you need some other way to show the ID's
instead of binding to ip netns output which is basically ls
/var/run/netns/. We don't
want an inner netns know anything outside, IOW, we don't share /var/run/netns/.
I think in this case your ID's are still available, but aren't you
providing a new way
for the inner netns device to escape which we are trying to avoid?

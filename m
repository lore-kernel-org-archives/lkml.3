Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751740AbaBXFoM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 00:44:12 -0500
Received: from mail-vc0-f177.google.com ([209.85.220.177]:40263 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739AbaBXFoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 00:44:10 -0500
MIME-Version: 1.0
In-Reply-To: <20140224053232.GB7056@dcvr.yhbt.net>
References: <1393206162-18151-1-git-send-email-n1ght.4nd.d4y@gmail.com>
	<1393206162-18151-3-git-send-email-n1ght.4nd.d4y@gmail.com>
	<20140224053232.GB7056@dcvr.yhbt.net>
Date: Sun, 23 Feb 2014 21:44:09 -0800
Message-ID: <CAJ3m7BrjXvCOD_JpBHO7-ZuHFycr=GCrBiW2S1gfN4Ms-9h-Hw@mail.gmail.com>
Subject: Re: [RFC PATCH for-next 2/4] epoll: epoll() syscall declaration
From: Nathaniel Yazdani <n1ght.4nd.d4y@gmail.com>
To: Eric Wong <normalperson@yhbt.net>
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 23, 2014 at 9:32 PM, Eric Wong <normalperson@yhbt.net> wrote:
> Nathaniel Yazdani <n1ght.4nd.d4y@gmail.com> wrote:
>> +asmlinkage long sys_epoll(int ep, struct epoll __user *in,
>> +                       unsigned int inc, struct epoll __user *out,
>> +                       unsigned int outc, int timeout);
>
> I can understand using the new struct for 'in', but 'out' could just be
> "struct epoll_event *" like sys_epoll_wait, right?
>
>>  asmlinkage long sys_epoll_wait(int epfd, struct epoll_event __user *events,

Yeah and I went back and forth on that, it just seemed to me that the
inconsistency could be confusing to others... maybe instead of defining a new
struct to begin with it might make me sense to just have an 'infd' array of file
descriptors in addition to an 'in' array of epoll_event struct
(obviously the length
of these would be identical).

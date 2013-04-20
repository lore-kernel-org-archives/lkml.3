Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932422Ab3DTQC2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Apr 2013 12:02:28 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:46742 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932253Ab3DTQC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Apr 2013 12:02:27 -0400
MIME-Version: 1.0
In-Reply-To: <20130419181155.GA13811@mtj.dyndns.org>
References: <1365957716-7631-1-git-send-email-laijs@cn.fujitsu.com>
	<CACvQF509UnU5RLtoxhnwmfdkudAR+_oWDKLfpq28WeKcUst5qw@mail.gmail.com>
	<20130419181155.GA13811@mtj.dyndns.org>
Date: Sun, 21 Apr 2013 00:02:26 +0800
Message-ID: <CACvQF52ge=8iQ86a7iyx-Oq1WtrQqDOiEv8AfLJMfwBKj6kj_w@mail.gmail.com>
Subject: Re: [PATCH 0/8] workqueue: advance concurrency management
From: Lai Jiangshan <eag0628@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 20, 2013 at 2:11 AM, Tejun Heo <tj@kernel.org> wrote:
> Hey,
>
> On Fri, Apr 19, 2013 at 06:10:57AM +0800, Lai Jiangshan wrote:
>> Ping.
>
> Sorry, I've been at collab summit / lsf.  Plus, it's a bit too late
> for for-3.10 anyway.  Anyways, after glancing over it, here are my
> preliminary thoughts.  The first one looks good but I'm not sure about
> dropping nr_running adjustment.  The only real benefit coming from
> that is dropping a sched callback and if there's any performance /
> overhead impact, I'm afraid it's gonna be negative.  There are actual
> benefits in using as few tasks as possible -

waking_up() callback doesn't win too much in this.


> the cache footprint gets smaller,

cache footprint also be reduced in different way in the patchset.
and memory atomic operations are reduced.

> so unless there's a clear indication that the suggested

Only simple.
and remove the optimization from rare cases.

> behavior is better in some way, I'm not sure what we're buying with
> the proposed changes.
>
> Thanks.
>
> --
> tejun

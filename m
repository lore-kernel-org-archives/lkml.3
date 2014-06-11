Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755135AbaFKEY3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 00:24:29 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:64314 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbaFKEY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 00:24:28 -0400
MIME-Version: 1.0
In-Reply-To: <20140611041202.GX4581@linux.vnet.ibm.com>
References: <1402456819-30515-1-git-send-email-bobby.prani@gmail.com> <20140611041202.GX4581@linux.vnet.ibm.com>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Wed, 11 Jun 2014 00:23:57 -0400
Message-ID: <CAJhHMCCgXBCe-deg7TtqA-azyc2ZvQRLKAiKVJ5OhL5GzLhH0w@mail.gmail.com>
Subject: Re: [RFC PATCH 1/1] kernel/rcu/tree.c: correct a check for grace
 period in progress
To: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Dipankar Sarma <dipankar@in.ibm.com>,
        "open list:READ-COPY UPDATE..." <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On Wed, Jun 11, 2014 at 12:12 AM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
>>       if (rnp->gpnum != rnp->completed ||
>> -         ACCESS_ONCE(rnp->gpnum) != ACCESS_ONCE(rnp->completed)) {
>> +         ACCESS_ONCE(rnp_root->gpnum) != ACCESS_ONCE(rnp_root->completed)) {
>
> At this point in the code, we are checking the current rcu_node structure,
> which might or might not be the root.  If it is not the root, we absolutely
> cannot compare against the root because we don't yet hold the root's lock.
>

I was a bit thrown by the double checking which is being done
(rnp->gpnum != rnp->complete) in that if condition. Once without
ACCESS_ONCE and one with. Is there any particular reason for this?

I now understand that we are comparing ->gpnum and ->completed of the
root node which might change from under us if we don't hold the root's
lock. I will keep looking :)

Thanks!
-- 
Pranith

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755179AbaFKSfC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 14:35:02 -0400
Received: from mail-yk0-f177.google.com ([209.85.160.177]:54739 "EHLO
	mail-yk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640AbaFKSfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 14:35:00 -0400
Message-ID: <5398A151.4070300@gmail.com>
Date: Wed, 11 Jun 2014 14:34:57 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Dipankar Sarma <dipankar@in.ibm.com>,
        "open list:READ-COPY UPDATE..." <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 1/1] kernel/rcu/tree.c: correct a check for grace
 period in progress
References: <1402456819-30515-1-git-send-email-bobby.prani@gmail.com> <20140611041202.GX4581@linux.vnet.ibm.com> <CAJhHMCCgXBCe-deg7TtqA-azyc2ZvQRLKAiKVJ5OhL5GzLhH0w@mail.gmail.com> <20140611044242.GY4581@linux.vnet.ibm.com> <20140611181840.GA26554@linux.vnet.ibm.com>
In-Reply-To: <20140611181840.GA26554@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2014 02:18 PM, Paul E. McKenney wrote:
> On Tue, Jun 10, 2014 at 09:42:42PM -0700, Paul E. McKenney wrote:
>> On Wed, Jun 11, 2014 at 12:23:57AM -0400, Pranith Kumar wrote:
>>> Hi Paul,
>>>
>>> On Wed, Jun 11, 2014 at 12:12 AM, Paul E. McKenney
>>> <paulmck@linux.vnet.ibm.com> wrote:
>>>>>       if (rnp->gpnum != rnp->completed ||
>>>>> -         ACCESS_ONCE(rnp->gpnum) != ACCESS_ONCE(rnp->completed)) {
>>>>> +         ACCESS_ONCE(rnp_root->gpnum) != ACCESS_ONCE(rnp_root->completed)) {
>>>>
>>>> At this point in the code, we are checking the current rcu_node structure,
>>>> which might or might not be the root.  If it is not the root, we absolutely
>>>> cannot compare against the root because we don't yet hold the root's lock.
>>>>
>>>
>>> I was a bit thrown by the double checking which is being done
>>> (rnp->gpnum != rnp->complete) in that if condition. Once without
>>> ACCESS_ONCE and one with. Is there any particular reason for this?
>>>
>>> I now understand that we are comparing ->gpnum and ->completed of the
>>> root node which might change from under us if we don't hold the root's
>>> lock. I will keep looking :)
>>
>> Hmmm...  Now that you mention it, that does look a bit strange.
> 
> And it turns out that you were right to begin with!  I queue your change,
> but with a full explanation in the commit log and with some additions to
> the comment.  Please see below.
> 

Awesome! A few more patches on your way :)

--
Pranith


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171AbaJMUZV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 16:25:21 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:37999 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753835AbaJMUZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 16:25:06 -0400
MIME-Version: 1.0
In-Reply-To: <1413230486.11421.47.camel@fourier>
References: <1413217740-9859-1-git-send-email-bobby.prani@gmail.com> <1413230486.11421.47.camel@fourier>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Mon, 13 Oct 2014 16:24:35 -0400
Message-ID: <CAJhHMCAKQTNysJPkSQKCejPMC8Wus=mWa43oP-DAwAUyUMDvbw@mail.gmail.com>
Subject: Re: [PATCH 3.13, 3.14, 3.16, 3.17] rcu: Reduce rcu kthread wakeups
To: Kamal Mostafa <kamal@canonical.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>,
        kernel-team <kernel-team@lists.ubuntu.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 13, 2014 at 4:01 PM, Kamal Mostafa <kamal@canonical.com> wrote:
> On Mon, 2014-10-13 at 12:29 -0400, Pranith Kumar wrote:
>> Backport 2aa792e and parts of 48a7639 to 3.13 which is Ubuntu LTS kernel.
>>
>> This commit reduces the number of rcu kthread wakeups. Tested for over a week on
>> my desktop 14.04 system.
>>
>> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
>> CC: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>
>
> Hi Pranith and Paul-
>
> This looks good, but how about lets split it back into two commits (the
> second a clean cherry-pick) and submit it for 3.{14,16,17}-stable also:
>
> 3.13 and 3.14 could apply the attached 48a7639 mini-backport (just
> supplying rcu_gp_kthread_wake), and then cherry-pick 2aa792e.
>
> 3.16 and 3.17 carry 48a7639 already, so could just cherry-pick 2aa792e.
>

The patch looks good. The commit message can be trimmed to just the last para:

Add a new rcu_gp_kthread_wake() which wakes up the gp kthread when it
is necessary and safe to do so: No self-wakes, no wake-ups if the
->gp_flags field indicates there is no need (as in someone else did
the wake-up before we got around to it),  and no wake-ups before the
grace-period kthread has been created.

Thanks!
-- 
Pranith

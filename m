Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756804Ab3GYQwB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 12:52:01 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:42651 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756382Ab3GYQv7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 12:51:59 -0400
Message-ID: <1374771118.1957.8.camel@joe-AO722>
Subject: Re: [RESEND RFC PATCH 0/5] Add a hash value for each line in
 /dev/kmsg
From: Joe Perches <joe@perches.com>
To: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Cc: linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com,
        akpm@linux-foundation.org, gregkh@linuxfoundation.org, kay@vrfy.org,
        davem@davemloft.net, itoukzo@nttdata.co.jp
Date: Thu, 25 Jul 2013 09:51:58 -0700
In-Reply-To: <20130725083730.20349.50797.stgit@localhost.localdomain>
References: <20130725083730.20349.50797.stgit@localhost.localdomain>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-07-25 at 17:37 +0900, Hidehiro Kawai wrote:
> ================
> This patch series adds hash values of printk format strings into
> each line of /dev/kmsg outputs as follows:
> 
>         6,154,325061,-,b7db707c@kernel/smp.c:554;Brought up 4 CPUs
> 
> These hash values allow use space to identify messages easily and
> do valuable things.  There is no guarantee that the hash values
> are unique.  However, user space can know which one collides to
> others from a message-and-hash catalog generated at build time, so
> finally it should be able to identify the messages.  User space
> can also use filename:lineno information to do that, although the
> information is not portable among various kernel versions.
> 
> 
> Background
> ==========
> We sometimes want to identify each kernel message automatically
> because of the following purposes:
> 
> (1) Show more detailed information about the message by cooperating
>     with external system
> (2) Take actions automatically depending on the message, for example
>     trigger a fail over or collect related information to analyze the
>     problem

If there are really "take action" uses, perhaps
it'd be better to mark the specific areas of code
where this needs to be done and add a notifier
function there instead of depending on post effect
processing.



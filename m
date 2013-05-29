Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935273Ab3E2WIs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 18:08:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56374 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935228Ab3E2WIo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 18:08:44 -0400
Message-ID: <51A67C4F.9070106@redhat.com>
Date: Wed, 29 May 2013 17:08:15 -0500
From: Guy Streeter <streeter@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Oleg Nesterov <oleg@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Eric Paris <eparis@redhat.com>, David Woodhouse <dwmw2@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] audit: wait_for_auditd() should use TASK_UNINTERRUPTIBLE
References: <20130524173925.GA17177@redhat.com> <20130529145933.6e02f8379cf20b9c7ef30977@linux-foundation.org>
In-Reply-To: <20130529145933.6e02f8379cf20b9c7ef30977@linux-foundation.org>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2013 04:59 PM, Andrew Morton wrote:
> On Fri, 24 May 2013 19:39:25 +0200 Oleg Nesterov <oleg@redhat.com> wrote:
> 
>> audit_log_start() does wait_for_auditd() in a loop until
>> audit_backlog_wait_time passes or audit_skb_queue has a room.
>>
>> If signal_pending() is true this becomes a busy-wait loop,
>> schedule() in TASK_INTERRUPTIBLE won't block.
> 
> And that's game over for a uniprocessor non-preempt machine, yes?
> 
>> Reported-by: Guy Streeter <streeter@redhat.com>
> 
> And what did Guy report?  "that looks screwy"?  "my machine locked up"?
>

Our customer was in fact running a uniprocessor machine, and they reported a
system hang.
--Guy


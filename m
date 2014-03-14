Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537AbaCNTYW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 15:24:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56939 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753644AbaCNTYU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 15:24:20 -0400
Date: Fri, 14 Mar 2014 20:23:46 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Sree Harsha Totakura <sreeharsha@totakura.in>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: pppd service crash in linux-3.13.6
Message-ID: <20140314192346.GA14823@redhat.com>
References: <531A37FF.4000509@totakura.in> <531DEEA6.4090808@totakura.in> <531E111A.8040207@hurleysoftware.com> <20140313170622.GA31206@redhat.com> <5321F113.7090000@hurleysoftware.com> <53230FE5.9020204@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53230FE5.9020204@hurleysoftware.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14, Peter Hurley wrote:
>
>> On 03/13/2014 01:06 PM, Oleg Nesterov wrote:
>>>
>>> OTOH, why we should delay disassociate_ctty? IOW, do you see any
>>> potential problem with the trivial patch below?
>
> Won't work.
>
> cgroup_exit() can exec a userspace process (the notify_on_exit() facility)
                                                  ^^^^^^^^^^^^^^^^

can't find anything named notify_on_exit, perhap you meant
cgroup_release_agent? Although I guess this should not matter.

> which requires both namespace and tty facilities.

Hmm... why?

The exiting task obviously can't exec. The only way to spawn a userspace
process is call_usermodehelper(), it should work just fine, no?

Oleg.


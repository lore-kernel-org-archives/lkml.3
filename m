Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757502Ab3E0Ubm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 16:31:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26420 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757261Ab3E0Ubl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 16:31:41 -0400
Date: Mon, 27 May 2013 22:27:51 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Sergey Dyasly <dserrg@gmail.com>,
        Sha Zhengju <handai.szj@taobao.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] proc: first_tid() fix/cleanup
Message-ID: <20130527202751.GA19250@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

next_thread() should be avoided, probably next_tid() is the
only "valid" user.

But now we have another reason to avoid (and probably even kill)
it, we are going to replace or fix while_each_thread(), almost
every lockless usage is wrong.

I was going to send more changes, but this initial series nearly
killed me. And I think first_tid() needs another cleanup, ->f_pos
truncation doesn't look nice, tomorrow.

Oleg.


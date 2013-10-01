Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203Ab3JAWqQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 18:46:16 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:39037 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331Ab3JAWqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 18:46:13 -0400
Date: Tue, 1 Oct 2013 15:46:10 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Sergey Dyasly <dserrg@gmail.com>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, Rusty Russell <rusty@rustcorp.com.au>,
        Sha Zhengju <handai.szj@taobao.com>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH] OOM killer: wait for tasks with pending SIGKILL to
 exit
In-Reply-To: <20131001192640.ed55682d3113b00b402bbef5@gmail.com>
Message-ID: <alpine.DEB.2.02.1310011545310.14977@chino.kir.corp.google.com>
References: <1378740624-2456-1-git-send-email-dserrg@gmail.com> <alpine.DEB.2.02.1309091303010.12523@chino.kir.corp.google.com> <20130911190605.5528ee4563272dbea1ed56a6@gmail.com> <alpine.DEB.2.02.1309251328130.24412@chino.kir.corp.google.com>
 <20130927185833.6c72b77ab105d70d4996ebef@gmail.com> <alpine.DEB.2.02.1309301457590.28109@chino.kir.corp.google.com> <20131001192640.ed55682d3113b00b402bbef5@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Oct 2013, Sergey Dyasly wrote:

> If you are ok with the first change in my patch regarding fatal_signal_pending,
> I can send new patch with just that change.
> 

The entire patch is pointless, there's no need to give access to memory 
reserves simply because it is PF_EXITING.  If it needs memory, it will 
call the oom killer itself.

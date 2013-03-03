Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798Ab3CCQoH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 11:44:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64329 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753761Ab3CCQn4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 11:43:56 -0500
Date: Sun, 3 Mar 2013 17:40:29 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Anton Arapov <anton@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Josh Stone <jistone@redhat.com>,
        Frank Eigler <fche@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: [RFC PATCH v3 4/6] uretprobes: return probe entry, prepare
	uretprobe
Message-ID: <20130303164029.GA20088@redhat.com>
References: <1362049215-5780-1-git-send-email-anton@redhat.com> <1362049215-5780-5-git-send-email-anton@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362049215-5780-5-git-send-email-anton@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28, Anton Arapov wrote:
>
> @@ -69,6 +69,10 @@ struct uprobe_task {
>  	enum uprobe_task_state		state;
>  	struct arch_uprobe_task		autask;
>
> +	/*
> +	 * list for tracking uprobes with return consumers
> +	 */
> +	struct hlist_head		return_uprobes;

Forgot to mention, at least you should also change uprobe_free_utask()
to cleanup this list, the task can exit from inside the ret-probe'd
function(s).

Oleg.


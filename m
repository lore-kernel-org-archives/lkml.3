Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753683AbaBRCAO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 21:00:14 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:32556 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752880AbaBRCAI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 21:00:08 -0500
X-IronPort-AV: E=Sophos;i="4.97,498,1389715200"; 
   d="scan'208";a="9547631"
Message-ID: <5302B9B4.9030808@cn.fujitsu.com>
Date: Tue, 18 Feb 2014 09:39:00 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] workqueue: async worker destruction
References: <1392472948-2486-1-git-send-email-laijs@cn.fujitsu.com> <1392654243-2829-1-git-send-email-laijs@cn.fujitsu.com>
In-Reply-To: <1392654243-2829-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/02/18 09:34:17,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/02/18 09:38:48,
	Serialize complete at 2014/02/18 09:38:48
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, the cover letter was forgotten to send to LKML.

On 02/18/2014 12:24 AM, Lai Jiangshan wrote:
> This patchset moves the worker-destruction(partial) to worker_thread(),
> and worker to be die will perform self-destruction.
> 
> This async worker destruction helps us to reduce the mananger's invocation,
> and simply the idle-worker-timeout handler.
> 
> This patchset requires earlier patch
> "workqueue: ensure @task is valid across kthread_stop()".
> 
> Lai Jiangshan (3):
>   workqueue: free worker earlier in worker_thread()
>   workqueue: async worker destruction
>   workqueue: kick worker to die directly in idle timeout handler
> 
>  kernel/workqueue.c |  135 +++++++++++++++++++---------------------------------
>  1 files changed, 49 insertions(+), 86 deletions(-)
> 


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932468AbaLAVIu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 16:08:50 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:45417 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932112AbaLAVIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 16:08:49 -0500
Date: Mon, 1 Dec 2014 13:08:46 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Lukasz Pawelczyk <l.pawelczyk@samsung.com>
cc: Lukasz Pawelczyk <havner@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Michal Hocko <mhocko@suse.cz>,
        Sameer Nanda <snanda@chromium.org>,
        Guillaume Morin <guillaume@morinfr.org>, Li Zefan <lizefan@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernel/exit.c: make sure current's nsproxy != NULL while
 checking caps
In-Reply-To: <1417086070.1805.9.camel@samsung.com>
Message-ID: <alpine.DEB.2.10.1412011307450.16984@chino.kir.corp.google.com>
References: <1417011661-19230-1-git-send-email-l.pawelczyk@samsung.com> <alpine.DEB.2.10.1411261326170.32216@chino.kir.corp.google.com> <1417086070.1805.9.camel@samsung.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="531381512-1485123074-1417468127=:16984"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--531381512-1485123074-1417468127=:16984
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Thu, 27 Nov 2014, Lukasz Pawelczyk wrote:

> On śro, 2014-11-26 at 13:32 -0800, David Rientjes wrote:
> > On Wed, 26 Nov 2014, Lukasz Pawelczyk wrote:
> > > 
> > > LSM task_kill() hook is triggered and current->nsproxy within is NULL.
> > > 
> > > This happens during an exit() syscall because exit_task_namespaces() is
> > > called before the exit_notify(). This patch changes their order.
> > > 
> > 
> > This is a classic case of a patch being proposed for a problem that only 
> > occurs on kernels that include other patches that are not upstream.  The 
> > order that things are deconstructed in the exit path is complex and 
> > carefully choreographed, changing it comes at significant risk.  That risk 
> > would be justified if a patch were being proposed for upstream that fixes 
> > an upstream problem.  It becomes too much of a maintenance nightmare to 
> > try to address problems and keep issues from arising for non-upstream 
> > patches.  Thus, I don't think this is something that we want.
> 
> This is a problem for the change I'm working on and I will be
> upstreaming it too at some point. Please see my other reply for more
> details:
> 
> http://www.spinics.net/lists/kernel/msg1877152.html
> 
> The only thing I can do then is to post this patch together with the
> other patches when the time comes. But since this issue is rather
> separate I've decided to try to push it earlier.
> 

Yeah, it would be best to fold this into a series that needs 
current->nsproxy to be valid at a sequence point in the exit path as part 
of the same patch that requires it.
--531381512-1485123074-1417468127=:16984--

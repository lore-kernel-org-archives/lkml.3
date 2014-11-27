Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706AbaK0LBP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 06:01:15 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:9074 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754270AbaK0LBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 06:01:13 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f5-b7fc86d0000066b7-04-547704774099
Content-transfer-encoding: 8BIT
Message-id: <1417086070.1805.9.camel@samsung.com>
Subject: Re: [PATCH] kernel/exit.c: make sure current's nsproxy != NULL while
 checking caps
From: Lukasz Pawelczyk <l.pawelczyk@samsung.com>
To: David Rientjes <rientjes@google.com>
Cc: Lukasz Pawelczyk <havner@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Michal Hocko <mhocko@suse.cz>,
        Sameer Nanda <snanda@chromium.org>,
        Guillaume Morin <guillaume@morinfr.org>, Li Zefan <lizefan@huawei.com>,
        linux-kernel@vger.kernel.org
Date: Thu, 27 Nov 2014 12:01:10 +0100
In-reply-to: <alpine.DEB.2.10.1411261326170.32216@chino.kir.corp.google.com>
References: <1417011661-19230-1-git-send-email-l.pawelczyk@samsung.com>
 <alpine.DEB.2.10.1411261326170.32216@chino.kir.corp.google.com>
X-Mailer: Evolution 3.12.5 (3.12.5-1.fc20)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFLMWRmVeSWpSXmKPExsVy+t/xK7rlLOUhBqffmVrMWb+GzWL3gods
	Fv9f61hc3jWHzWJSRy+7xavm76wWW/e3Mlq0LdnIZHHx90l2B06P2Q0XWTx2zrrL7rFgU6lH
	y5G3rB4nZvxm8ei4v4XJ4/2+q2weZxYcYff4vEkugDOKyyYlNSezLLVI3y6BK6N/YQtLwUTu
	ipW3bjI3MD7j6GLk5JAQMJFYveMdM4QtJnHh3nq2LkYuDiGBpYwS3R9vMoEkeAUEJX5MvsfS
	xcjBwSwgL3HkUjZImFlAXWLSvEXMEPX/GSWWtn+BqjeUmNi9hA3EFhaIlTj88QGYzSZgIPH9
	wl6wZSICGhJtM/6DLWMWWMIksf/AD1aQBIuAqsTEJc/ZQWxOAR+J9oPtjBAbOhklLrTfYoc4
	VUvifddPlgmMArOQHDgL4cBZSA5cwMi8ilE0tTS5oDgpPddIrzgxt7g0L10vOT93EyMkPr7u
	YFx6zOoQowAHoxIPL8OtshAh1sSy4srcQ4wSHMxKIrxcjOUhQrwpiZVVqUX58UWlOanFhxiZ
	ODilGhjXchacYXZ6ttk7f0mJZs7bFRu3/pCeu4dp55mVzK3XIqZcvJVetyFXsPehgutlj2kH
	N0/e8D2K17Ojov3/aSk+oUfyvscY57CyzXt2z699pt4WoZ9nXTN0LJTX2W96tMfjUOjUK3JX
	FjyN4WXkMF31rulVir2B3LZZZ+QuP930x9X7Q7zAxLdhSizFGYmGWsxFxYkA2LYL8G0CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On śro, 2014-11-26 at 13:32 -0800, David Rientjes wrote:
> On Wed, 26 Nov 2014, Lukasz Pawelczyk wrote:
> > 
> > LSM task_kill() hook is triggered and current->nsproxy within is NULL.
> > 
> > This happens during an exit() syscall because exit_task_namespaces() is
> > called before the exit_notify(). This patch changes their order.
> > 
> 
> This is a classic case of a patch being proposed for a problem that only 
> occurs on kernels that include other patches that are not upstream.  The 
> order that things are deconstructed in the exit path is complex and 
> carefully choreographed, changing it comes at significant risk.  That risk 
> would be justified if a patch were being proposed for upstream that fixes 
> an upstream problem.  It becomes too much of a maintenance nightmare to 
> try to address problems and keep issues from arising for non-upstream 
> patches.  Thus, I don't think this is something that we want.

This is a problem for the change I'm working on and I will be
upstreaming it too at some point. Please see my other reply for more
details:

http://www.spinics.net/lists/kernel/msg1877152.html

The only thing I can do then is to post this patch together with the
other patches when the time comes. But since this issue is rather
separate I've decided to try to push it earlier.



-- 
Lukasz Pawelczyk
Samsung R&D Institute Poland
Samsung Electronics




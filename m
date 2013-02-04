Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907Ab3BDKNh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 05:13:37 -0500
Received: from shutemov.name ([204.155.152.216]:37786 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751023Ab3BDKNf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 05:13:35 -0500
Date: Mon, 4 Feb 2013 12:15:21 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Li Zefan <lizefan@huawei.com>
Cc: Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>,
        Davide Libenzi <davidel@xmailserver.org>,
        Aaron Durbin <adurbin@google.com>, Greg Thelen <gthelen@google.com>
Subject: Re: [PATCH 1/4] eventfd: introduce eventfd_signal_hangup()
Message-ID: <20130204101521.GA18322@shutemov.name>
References: <510CB733.2080904@huawei.com>
 <510CB744.7000300@huawei.com>
 <20130202155858.GA13022@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130202155858.GA13022@shutemov.name>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 02, 2013 at 05:58:58PM +0200, Kirill A. Shutemov wrote:
> On Sat, Feb 02, 2013 at 02:50:44PM +0800, Li Zefan wrote:
> > When an eventfd is closed, a wakeup with POLLHUP will be issued,
> > but cgroup wants to issue wakeup explicitly, so when a cgroup is
> > removed userspace can be notified.
> > 
> > Signed-off-by: Li Zefan <lizefan@huawei.com>

Hm.. Looks like it will break eventfd semantics:

1. One eventfd can be used for deliver more then one notification from
one or more cgroups. POLLHUP on removing one of cgroups is not valid.

2. It's valid to have eventfd opened only by one userspace application. We
should not close it, just because cgroup is removed.

I think problem with multiple threads waiting an event on eventfd should
be handled in userspace.

-- 
 Kirill A. Shutemov

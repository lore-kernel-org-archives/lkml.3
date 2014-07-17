Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757903AbaGQT51 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 15:57:27 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:33494 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604AbaGQT5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 15:57:25 -0400
MIME-Version: 1.0
In-Reply-To: <1405626731-12220-6-git-send-email-adityakali@google.com>
References: <1405626731-12220-1-git-send-email-adityakali@google.com> <1405626731-12220-6-git-send-email-adityakali@google.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 17 Jul 2014 12:57:03 -0700
Message-ID: <CALCETrWXMMGzptvEu6TfzTjBou4t==W39_nNB5FJwSk2Zy8uCQ@mail.gmail.com>
Subject: Re: [PATCH 5/5] cgroup: introduce cgroup namespaces
To: Aditya Kali <adityakali@google.com>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>,
        cgroups@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Linux Containers <containers@lists.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 12:52 PM, Aditya Kali <adityakali@google.com> wrote:
> Introduce the ability to create new cgroup namespace. The newly created
> cgroup namespace remembers the 'struct cgroup *root_cgrp' at the point
> of creation of the cgroup namespace. The task that creates the new
> cgroup namespace and all its future children will now be restricted only
> to the cgroup hierarchy under this root_cgrp. In the first version,
> setns() is not supported for cgroup namespaces.
> The main purpose of cgroup namespace is to virtualize the contents
> of /proc/self/cgroup file. Processes inside a cgroup namespace
> are only able to see paths relative to their namespace root.
> This allows container-tools (like libcontainer, lxc, lmctfy, etc.)
> to create completely virtualized containers without leaking system
> level cgroup hierarchy to the task.

What happens if someone moves a task in a cgroup namespace outside of
the namespace root cgroup?

--Andy

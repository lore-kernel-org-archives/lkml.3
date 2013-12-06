Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758450Ab3LFVbm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 16:31:42 -0500
Received: from static.92.5.9.176.clients.your-server.de ([176.9.5.92]:54266
	"EHLO hallynmail2" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754730Ab3LFVbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:31:41 -0500
Date: Fri, 6 Dec 2013 21:31:35 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Gao feng <gaofeng@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-audit@redhat.com,
        toshi.okajima@jp.fujitsu.com, containers@lists.linux-foundation.org,
        serge.hallyn@ubuntu.com, eparis@redhat.com, ebiederm@xmission.com,
        sgrubb@redhat.com
Subject: Re: [RFC Part1 PATCH 00/20 v2] Add namespace support for audit
Message-ID: <20131206213135.GA22445@mail.hallyn.com>
References: <1382599925-25143-1-git-send-email-gaofeng@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382599925-25143-1-git-send-email-gaofeng@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Gao feng (gaofeng@cn.fujitsu.com):
> Here is the v1 patchset: http://lwn.net/Articles/549546/
> 
> The main target of this patchset is allowing user in audit
> namespace to generate the USER_MSG type of audit message,
> some userspace tools need to generate audit message, or
> these tools will broken.
> 
> And the login process in container may want to setup
> /proc/<pid>/loginuid, right now this value is unalterable
> once it being set. this will also broke the login problem
> in container. After this patchset, we can reset this loginuid
> to zero if task is running in a new audit namespace.
> 
> Same with v1 patchset, in this patchset, only the privileged
> user in init_audit_ns and init_user_ns has rights to
> add/del audit rules. and these rules are gloabl. all
> audit namespace will comply with the rules.
> 
> Compared with v1, v2 patch has some big changes.
> 1, the audit namespace is not assigned to user namespace.
>    since there is no available bit of flags for clone, we
>    create audit namespace through netlink, patch[18/20]
>    introduces a new audit netlink type AUDIT_CREATE_NS.
>    the privileged user in userns has rights to create a
>    audit namespace, it means the unprivileged user can
>    create auditns through create userns first. In order
>    to prevent them from doing harm to host, the default
>    audit_backlog_limit of un-init-audit-ns is zero(means
>    audit is unavailable in audit namespace). and it can't
>    be changed in auditns through netlink.

So the unprivileged user can create an audit-ns, but can't
then actually send any messages there?  I guess setting it
to something small would just be hacky?

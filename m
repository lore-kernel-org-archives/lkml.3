Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161892Ab3LFWMr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 17:12:47 -0500
Received: from static.92.5.9.176.clients.your-server.de ([176.9.5.92]:54639
	"EHLO hallynmail2" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161329Ab3LFWMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 17:12:43 -0500
Date: Fri, 6 Dec 2013 22:12:41 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Gao feng <gaofeng@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-audit@redhat.com,
        Richard Guy Briggs <rgb@redhat.com>,
        containers@lists.linux-foundation.org, serge.hallyn@ubuntu.com,
        eparis@redhat.com, ebiederm@xmission.com, sgrubb@redhat.com
Subject: Re: [RFC Part1 PATCH 00/20 v2] Add namespace support for audit
Message-ID: <20131206221241.GD22445@mail.hallyn.com>
References: <1382599925-25143-1-git-send-email-gaofeng@cn.fujitsu.com>
 <529EE877.7030701@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <529EE877.7030701@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Gao feng (gaofeng@cn.fujitsu.com):
> Hi
> 
> On 10/24/2013 03:31 PM, Gao feng wrote:
> > Here is the v1 patchset: http://lwn.net/Articles/549546/
> > 
> > The main target of this patchset is allowing user in audit
> > namespace to generate the USER_MSG type of audit message,
> > some userspace tools need to generate audit message, or
> > these tools will broken.
> > 
> 
> I really need this feature, right now,some process such as
> logind are broken in container becase we leak of this feature.

Your set doesn't address loginuid though right?  How exactly do you
expect to do that?  If user violates MAC policy and audit msg is
sent to init user ns by mac subsys, you need the loginuid from
init_audit_ns.  where will that be stored if you allow updates
of loginuid in auditns?

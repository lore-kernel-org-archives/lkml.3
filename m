Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238Ab3LDIj4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 03:39:56 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:55595 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754544Ab3LDIjy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 03:39:54 -0500
X-IronPort-AV: E=Sophos;i="4.93,823,1378828800"; 
   d="scan'208";a="9188197"
Message-ID: <529EE877.7030701@cn.fujitsu.com>
Date: Wed, 04 Dec 2013 16:31:51 +0800
From: Gao feng <gaofeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Gao feng <gaofeng@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        linux-audit@redhat.com
CC: containers@lists.linux-foundation.org, ebiederm@xmission.com,
        serge.hallyn@ubuntu.com, eparis@redhat.com, sgrubb@redhat.com,
        Richard Guy Briggs <rgb@redhat.com>
Subject: Re: [RFC Part1 PATCH 00/20 v2] Add namespace support for audit
References: <1382599925-25143-1-git-send-email-gaofeng@cn.fujitsu.com>
In-Reply-To: <1382599925-25143-1-git-send-email-gaofeng@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/04 16:30:38,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/04 16:39:44,
	Serialize complete at 2013/12/04 16:39:44
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On 10/24/2013 03:31 PM, Gao feng wrote:
> Here is the v1 patchset: http://lwn.net/Articles/549546/
> 
> The main target of this patchset is allowing user in audit
> namespace to generate the USER_MSG type of audit message,
> some userspace tools need to generate audit message, or
> these tools will broken.
> 

I really need this feature, right now,some process such as
logind are broken in container becase we leak of this feature.

> And the login process in container may want to setup
> /proc/<pid>/loginuid, right now this value is unalterable
> once it being set. this will also broke the login problem
> in container. After this patchset, we can reset this loginuid
> to zero if task is running in a new audit namespace.
> 

I notice this problem has been fixed in audit tree, so may be
I don't need to clean up loginuid when we create audit namespace.

And in audit tree, audit socket is per net namespace, hmm, I want
to know if anybody has a solution to allow processes to generate
USER_MSG type of audit message in un init pid/user namepsace.

Any idea? Eric,Steve,Richard?

Thanks
Gao

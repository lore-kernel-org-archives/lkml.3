Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838AbaHUUGV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 16:06:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754713AbaHUUGA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 16:06:00 -0400
Date: Thu, 21 Aug 2014 16:05:55 -0400
From: Aristeu Rozanski <arozansk@redhat.com>
To: Richard Guy Briggs <rgb@redhat.com>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        eparis@redhat.com, sgrubb@redhat.com, ebiederm@xmission.com,
        serge@hallyn.com
Subject: Re: [PATCH V4 0/8] namespaces: log namespaces per task
Message-ID: <20140821200555.GK5620@redhat.com>
References: <cover.1408581429.git.rgb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1408581429.git.rgb@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,
On Wed, Aug 20, 2014 at 09:09:33PM -0400, Richard Guy Briggs wrote:
> Is there a way to link serial numbers of namespaces involved in migration of a
> container to another kernel?  It sounds like what is needed is a part of a
> mangement application that is able to pull the audit records from constituent
> hosts to build an audit trail of a container.

since you're introducing a brand new serial number to make it unique
across different procfs mounts, why not instead of a simple counter,
use the hash output of say, $hostname-$creation_time-$random? Or perhaps
get a short hash of the hostname (generated once whenever hostname is
set) and append the serial number you're implementing? It'd be way less human
readable than your current proposal but it'd be unique "globally" (as long you
don't have machines with the same hostname migrating containers between them),
allowing the migrated namespaces to retain their unique identification across
audit logs. It'd of course be way more costly than just using an atomic counter,
but could be useful to anything that needs to refer to a namespace and could be
migrated to another machine.

What you think? Sounds too crazy? :)

-- 
Aristeu


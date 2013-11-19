Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472Ab3KSWqQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 17:46:16 -0500
Received: from mail.tpi.com ([74.45.170.26]:46751 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752102Ab3KSWqN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 17:46:13 -0500
Message-ID: <528BEA34.9060907@canonical.com>
Date: Tue, 19 Nov 2013 14:46:12 -0800
From: Tim Gardner <tim.gardner@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Paul Moore <paul@paul-moore.com>
CC: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Smalley <sds@tycho.nsa.gov>,
        James Morris <james.l.morris@oracle.com>,
        Eric Paris <eparis@parisplace.org>
Subject: Re: [PATCH linux-next] SELinux: security_load_policy: Silence frame-larger-than
 warning
References: <1384466691-42392-1-git-send-email-tim.gardner@canonical.com> <2344755.pvM4VQSB59@sifl>
In-Reply-To: <2344755.pvM4VQSB59@sifl>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2013 02:38 PM, Paul Moore wrote:
> On Thursday, November 14, 2013 03:04:51 PM Tim Gardner wrote:
>> Dynamically allocate a couple of the larger stack variables in order to
>> reduce the stack footprint below 1024. gcc-4.8
>>
>> security/selinux/ss/services.c: In function 'security_load_policy':
>> security/selinux/ss/services.c:1964:1: warning: the frame size of 1104 bytes
>> is larger than 1024 bytes [-Wframe-larger-than=] }
>>
>> Also silence a couple of checkpatch warnings at the same time.
>>
>> WARNING: sizeof policydb should be sizeof(policydb)
>> +	memcpy(oldpolicydb, &policydb, sizeof policydb);
>>
>> WARNING: sizeof policydb should be sizeof(policydb)
>> +	memcpy(&policydb, newpolicydb, sizeof policydb);
>>
>> Cc: Stephen Smalley <sds@tycho.nsa.gov>
>> Cc: James Morris <james.l.morris@oracle.com>
>> Cc: Eric Paris <eparis@parisplace.org>
>> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
>> ---
>>  security/selinux/ss/services.c |   54 ++++++++++++++++++++++--------------
>>  1 file changed, 32 insertions(+), 22 deletions(-)
> 
> Applied, thanks.  It will be pushed to my next tree once -rc1 is released.
> 
> In the future, please send SELinux patches to the SELinux mailing list.
> 

It is difficult to know where to send a patch for every subsystem. I've
been using the get_maintainer.pl script, so perhaps the info in
MAINTAINERS is stale ? I'm open to suggestions.

$: scripts/get_maintainer.pl -f security/selinux/ss/services.c
Stephen Smalley <sds@tycho.nsa.gov> (supporter:SELINUX SECURITY...)
James Morris <james.l.morris@oracle.com> (supporter:SELINUX SECURITY...)
Eric Paris <eparis@parisplace.org> (supporter:SELINUX SECURITY...)
linux-security-module@vger.kernel.org (open list:SECURITY SUBSYSTEM)
linux-kernel@vger.kernel.org (open list)

rtg
-- 
Tim Gardner tim.gardner@canonical.com

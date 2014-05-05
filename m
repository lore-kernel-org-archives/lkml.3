Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539AbaEEJXO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 05:23:14 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:52546 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755347AbaEEJXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 05:23:12 -0400
Message-ID: <5367587B.20801@6wind.com>
Date: Mon, 05 May 2014 11:23:07 +0200
From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Reply-To: nicolas.dichtel@6wind.com
Organization: 6WIND
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Richard Guy Briggs <rgb@redhat.com>, "Serge E. Hallyn" <serge@hallyn.com>
CC: containers@lists.linux-foundation.org, serge.hallyn@ubuntu.com,
        linux-kernel@vger.kernel.org, linux-audit@redhat.com,
        ebiederm@xmission.com
Subject: Re: [PATCH 0/2] namespaces: log namespaces per task
References: <cover.1398176489.git.rgb@redhat.com>	<20140501223212.GA25669@mail.hallyn.com> <20140502142851.GC24111@madcap2.tricolour.ca>
In-Reply-To: <20140502142851.GC24111@madcap2.tricolour.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 02/05/2014 16:28, Richard Guy Briggs a écrit :
> On 14/05/02, Serge E. Hallyn wrote:
>> Quoting Richard Guy Briggs (rgb@redhat.com):
>>> I saw no replies to my questions when I replied a year after Aris' posting, so
>>> I don't know if it was ignored or got lost in stale threads:
>>>          https://www.redhat.com/archives/linux-audit/2013-March/msg00020.html
>>>          https://www.redhat.com/archives/linux-audit/2013-March/msg00033.html
>>> 	(https://lists.linux-foundation.org/pipermail/containers/2013-March/032063.html)
>>>          https://www.redhat.com/archives/linux-audit/2014-January/msg00180.html
>>>
>>> I've tried to answer a number of questions that were raised in that thread.
>>>
>>> The goal is not quite identical to Aris' patchset.
>>>
>>> The purpose is to track namespaces in use by logged processes from the
>>> perspective of init_*_ns.  The first patch defines a function to list them.
>>> The second patch provides an example of usage for audit_log_task_info() which
>>> is used by syscall audits, among others.  audit_log_task() and
>>> audit_common_recv_message() would be other potential use cases.
>>>
>>> Use a serial number per namespace (unique across one boot of one kernel)
>>> instead of the inode number (which is claimed to have had the right to change
>>> reserved and is not necessarily unique if there is more than one proc fs).  It
>>> could be argued that the inode numbers have now become a defacto interface and
>>> can't change now, but I'm proposing this approach to see if this helps address
>>> some of the objections to the earlier patchset.
>>>
>>> There could also have messages added to track the creation and the destruction
>>> of namespaces, listing the parent for hierarchical namespaces such as pidns,
>>> userns, and listing other ids for non-hierarchical namespaces, as well as other
>>> information to help identify a namespace.
>>>
>>> There has been some progress made for audit in net namespaces and pid
>>> namespaces since this previous thread.  net namespaces are now served as peers
>>> by one auditd in the init_net namespace with processes in a non-init_net
>>> namespace being able to write records if they are in the init_user_ns and have
>>> CAP_AUDIT_WRITE.  Processes in a non-init_pid_ns can now similarly write
>>> records.  As for CAP_AUDIT_READ, I just posted a patchset to check capabilities
>>> of userspace processes that try to join netlink broadcast groups.
>>>
>>>
>>> Questions:
>>> Is there a way to link serial numbers of namespaces involved in migration of a
>>> container to another kernel?  (I had a brief look at CRIU.)  Is there a unique
>>> identifier for each running instance of a kernel?  Or at least some identifier
>>> within the container migration realm?
>>
>> Eric Biederman has always been adamantly opposed to adding new namespaces
>> of namespaces, so the fact that you're asking this question concerns me.
>
> I have seen that position and I don't fully understand the justification
> for it other than added complexity.
Just FYI, have you seen this thread:
http://thread.gmane.org/gmane.linux.network/286572/

There is some explanations/examples about this topic.


Regards,
Nicolas

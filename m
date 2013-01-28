Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226Ab3A1HPB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 02:15:01 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:59723 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948Ab3A1HO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 02:14:57 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Gao feng <gaofeng@cn.fujitsu.com>
Cc: serge.hallyn@canonical.com, akpm@linux-foundation.org,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
References: <1359342541-383-1-git-send-email-gaofeng@cn.fujitsu.com>
	<87bocayntu.fsf@xmission.com> <51061F2F.6040104@cn.fujitsu.com>
Date: Sun, 27 Jan 2013 23:14:48 -0800
In-Reply-To: <51061F2F.6040104@cn.fujitsu.com> (Gao feng's message of "Mon, 28
	Jan 2013 14:48:15 +0800")
Message-ID: <877gmxye1j.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/Sc5LZpmJUn71Q6HSLWCslP/WNDP94FTI=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0002]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Gao feng <gaofeng@cn.fujitsu.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] userns: Allow the unprivileged users to mount mqueue fs
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gao feng <gaofeng@cn.fujitsu.com> writes:

> On 2013/01/28 11:43, Eric W. Biederman wrote:
>> Gao feng <gaofeng@cn.fujitsu.com> writes:
>> 
>>> This patch allow the unprivileged user to mount mqueuefs in
>>> user ns.
>>>
>>> If two userns share the same ipcns,the files in mqueue fs
>>> should be seen in both these two userns.
>>>
>>> If the userns has its own ipcns,it has its own mqueue fs too.
>>> ipcns has already done this job well.
>> 
>> I am a little dense.  When does userspace actually mount a mqueuefs?
>> My impression was that user space never needed to mount and actually
>> never could mount a mqueuefs.  MS_NO_USER isn't set so mounting a
>> mqueuefs is possible but when does it happen and why?
>> 
>
> Actually the files which representative messgae queue in mqueuefs contains
> some informations,such as QSIZE,NOTIFY,SIGNO,NOTIFY_PID.
>
> My workstation is Fedora 17,mqueuefs is mounted on /dev/mqueue by default.
> So I think at lest this patch is needed by some people.

I have just confirmed that the most you can do in a mounted mqueue fs is
to create files message queues.

Given that these filesystems exist anyway I don't see a problem.

Applied thanks.

Eric

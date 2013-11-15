Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871Ab3KOBjG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 20:39:06 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:41966 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754735Ab3KOBi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 20:38:57 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Gao feng <gaofeng@cn.fujitsu.com>
Cc: containers@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org,
        serge@hallyn.com, linux-kernel@vger.kernel.org
References: <1384327663-12032-1-git-send-email-gaofeng@cn.fujitsu.com>
	<874n7e4k78.fsf@xmission.com> <52856F0D.8090206@cn.fujitsu.com>
Date: Thu, 14 Nov 2013 17:38:48 -0800
In-Reply-To: <52856F0D.8090206@cn.fujitsu.com> (Gao feng's message of "Fri, 15
	Nov 2013 08:47:09 +0800")
Message-ID: <871u2i30lz.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/urIirb5Op7uHvYGMBTmJZ2TRWAkiVDSU=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0013]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Gao feng <gaofeng@cn.fujitsu.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] userns: allow privileged user to operate locked mount
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gao feng <gaofeng@cn.fujitsu.com> writes:

> On 11/15/2013 07:50 AM, Eric W. Biederman wrote:
>> Gao feng <gaofeng@cn.fujitsu.com> writes:
>> 
>>> Privileged user should have rights to mount/umount/move
>>> these even locked mount.
>> 
>> Hmm. This is pretty much a can't happen case, as the only exist in mount
>> namespaces where the global root isn't the root.  How are you getting
>> into this situation?  Using setns() ?
>> 
>
> Before, priviged user can use setns to set his mount namespace to the
> container's mount namespace, and change container's mount directly.
> this patch just gives back host the control of container.

Having thought about this patch a little more I really don't like it.

There are other ways for a privileged user to get around the limitations
when the mount namespace is being created or the mounts are being
propagated.

This approach would require more then a signgle bit of accounting to
work in the nested user namespace case.

The lock says one or several mounts are mounted as a unit and need to
stay that way.

If there are real advantages to splitting things up I might be persuaded
to change my mind.  But right now it looks like you are introducing
extra complexity for a very corner edge case that we don't want to
encourage people to use.

Eric

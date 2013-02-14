Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933118Ab3BNJKM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 04:10:12 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:34775 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756496Ab3BNJKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 04:10:10 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: linux-fsdevel@vger.kernel.org
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, "Serge E. Hallyn" <serge@hallyn.com>,
        Mark Fasheh <mfasheh@suse.com>
References: <87621w14vs.fsf@xmission.com>
	<1360777934-5663-1-git-send-email-ebiederm@xmission.com>
	<1360777934-5663-23-git-send-email-ebiederm@xmission.com>
	<20130214083547.GE18408@localhost>
Date: Thu, 14 Feb 2013 01:10:01 -0800
In-Reply-To: <20130214083547.GE18408@localhost> (Joel Becker's message of
	"Thu, 14 Feb 2013 00:35:48 -0800")
Message-ID: <877gmbdzx2.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/s7OwQsIH2nJxlyBS6XAUHIIezjFmJyl4=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  3.0 XMDrug1234561 Drug references
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0017]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;linux-fsdevel@vger.kernel.org
X-Spam-Relay-Country: 
Subject: Re: [PATCH review 23/85] ocfs2: Convert uid and gids between in core and on disk inodes
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joel Becker <jlbec@evilplan.org> writes:

> This has the same problem with two machines in different userspace
> namespaces.  Should this be punted to the sysadmin or helped out in the
> filesystem?  Do you define this case as unsupported?

First I define two machines in the same user namespace as two machines
with synchronized password files.

As today connecting two machines without synchronizing the password
entries is a problem, won't work, and is punted to the sysadmin to make
keep from doing something silly.

At the same time I don't want to make it easy to get confused, or cause
breakage.

With these patches ocfs2 only still only works in the initial user
namespace.  I don't set .fs_flags = FS_USERNS_MOUNT in struct
filesystem.  Which means that while users in other user namespaces can
store files on ocfs2, they can't mount ocfs2.

Eric

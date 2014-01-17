Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751779AbaAQARh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 19:17:37 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:33524 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623AbaAQARf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 19:17:35 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
References: <871u07wkwt.fsf@xmission.com>
	<20140116235925.GY10323@ZenIV.linux.org.uk>
Date: Thu, 16 Jan 2014 16:17:27 -0800
In-Reply-To: <20140116235925.GY10323@ZenIV.linux.org.uk> (Al Viro's message of
	"Thu, 16 Jan 2014 23:59:25 +0000")
Message-ID: <87eh47v4vc.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/HTdpzVmelKSXEopcz/4Yivxk1FWo3fx0=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0024]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Al Viro <viro@ZenIV.linux.org.uk>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] vfs: Don't leak a path when get_empty_filp in dentry_open
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro <viro@ZenIV.linux.org.uk> writes:

> On Thu, Jan 16, 2014 at 03:45:38PM -0800, Eric W. Biederman wrote:
>> 
>> Normally in dentry_open the passed in path is placed on the new filp
>> removing the caller from needing to worry about it.  In the rare case
>> that we can not allocate a filp the path is not consumed.  None of the
>> callers of dentry_open call path_put in their error handling when
>> dentry_open fails so call path_put for them on error and keep everyone's
>> error handling simple.
>
> You are misreading that code.  _No_ path in dentry_open() drops that
> sucker, no matter whether we succeed or fail.  do_dentry_open() grabs
> an extra reference on success, so those fput() on other failure exits
> just balance that.

Yep you are right.  My mistake.  The weird code flow tricked me.

Eric

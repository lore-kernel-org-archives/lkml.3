Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192AbaDQIow (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 04:44:52 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:40096 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203AbaDQIos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 04:44:48 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
References: <20140417150657.6d67e750081860b30f99715c@canb.auug.org.au>
	<20140417052500.GZ18016@ZenIV.linux.org.uk>
Date: Thu, 17 Apr 2014 01:44:21 -0700
In-Reply-To: <20140417052500.GZ18016@ZenIV.linux.org.uk> (Al Viro's message of
	"Thu, 17 Apr 2014 06:25:00 +0100")
Message-ID: <874n1s73bu.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18MKfVFYbo0Up9AOBRpXq3IT+lEK4KlKko=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0063]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Al Viro <viro@ZenIV.linux.org.uk>
X-Spam-Relay-Country: 
Subject: Re: linux-next: manual merge of the userns tree with Linus' tree
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro <viro@ZenIV.linux.org.uk> writes:

> On Thu, Apr 17, 2014 at 03:06:57PM +1000, Stephen Rothwell wrote:
>> Hi Eric,
>> 
>> Today's linux-next merge of the userns tree got a conflict in
>> fs/namespace.c between various commits from Linus' tree and various
>> commits from the userns tree.
>> 
>> I fixed it up (hopefully - see below) and can carry the fix as necessary
>> (no action is required).
>
> Various commits include this:
> commit 38129a13e6e71f666e0468e99fdd932a687b4d7e
> Author: Al Viro <viro@zeniv.linux.org.uk>
> Date:   Thu Mar 20 21:10:51 2014 -0400
>
>     switch mnt_hash to hlist
>
> present in v3.14...  It's been there since before the merge window.

And the code that is in conflict is even older.  

I just figured out of an abundance of caution I would make certain the
code was out there for automatic and semi-automatic things to pound on
before I resent my pull request to Linus, now that I have fixed the
stack overflow issue you were complaining about.

I suspect something about fixing mntput caused Stephen to loose his
trivial resolution for this trivial conflict.

Eric

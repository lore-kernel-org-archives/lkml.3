Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750929Ab3BOSrj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 13:47:39 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:39617 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712Ab3BOSrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 13:47:37 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: linux-fsdevel@vger.kernel.org,
        Linux Containers <containers@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, "Serge E. Hallyn" <serge@hallyn.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Stanislav Kinsbursky <skinsbursky@parallels.com>
References: <87621w14vs.fsf@xmission.com>
	<1360777934-5663-1-git-send-email-ebiederm@xmission.com>
	<1360777934-5663-52-git-send-email-ebiederm@xmission.com>
	<20130213210545.GO14195@fieldses.org> <874nhfrjgg.fsf@xmission.com>
	<20130213215047.GR14195@fieldses.org> <8738wzq1z6.fsf@xmission.com>
	<20130213225840.GV14195@fieldses.org> <87ip5vn6iv.fsf@xmission.com>
	<20130215170052.GN8343@fieldses.org>
Date: Fri, 15 Feb 2013 10:47:28 -0800
In-Reply-To: <20130215170052.GN8343@fieldses.org> (J. Bruce Fields's message
	of "Fri, 15 Feb 2013 12:00:52 -0500")
Message-ID: <87ip5tv2gv.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+apsLYwvD38UQ6KoyWlC7eDYXw1J4luGc=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  3.0 XMDrug1234561 Drug references
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0010]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;"J. Bruce Fields" <bfields@fieldses.org>
X-Spam-Relay-Country: 
Subject: Re: [PATCH review 52/85] sunrpc: Properly encode kuids and kgids in auth.unix.gid rpc pipe upcalls.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"J. Bruce Fields" <bfields@fieldses.org> writes:

> On Wed, Feb 13, 2013 at 03:22:32PM -0800, Eric W. Biederman wrote:
>
> I've committed his patches to
>
> 	git://linux-nfs.org/~bfields/linux.git for-3.9
>
> which should also get pulled into next.  Let me know if there's another
> patch I should take.

I don't currently see any problems.

My changes are now in:

        git://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/user-namespace.git for-next

So we will get whatever linux-next testing there is.

>> I am a touch concerned about /proc/fs/nfsd/exports after my patches
>> and Stanislavs patches both come in.  As I think that will allow for
>> cases where net->user_ns != &init_userns.  But we can cross that bridge
>> when we come to it.
>
> OK, let me know of anything I can do to make your life easier....

/proc/fs/nfsd/exports is read-only so it turns out not be be a problem.

That we can not mount nfs or the nfsd control filesystem outside of
init_userns prevents any other problems.  Details are in my conversation
with Stanislav.

Eric

p.s. It would be nice if /proc/fs/nfsd/exports became a symlink to
/proc/net/nfsd/exports so the code didn't have to use current to figure
out how to do the right thing.

p.p.s Full user namespace support probably isn't much more than using
net->user_ns and adding the FS_USERNS_MOUNT flag. 

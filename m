Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757036AbaJXSTO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 14:19:14 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:53438 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756592AbaJXSTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 14:19:12 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Hans de Bruin <jmdebruin@xmsnet.nl>
Cc: "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-nfs@vger.kernel.org
References: <543ED24D.4070905@xmsnet.nl> <5443F5A1.1050004@xmsnet.nl>
	<544A7933.3010702@xmsnet.nl> <544A7D5C.5060804@xmsnet.nl>
Date: Fri, 24 Oct 2014 13:18:22 -0500
In-Reply-To: <544A7D5C.5060804@xmsnet.nl> (Hans de Bruin's message of "Fri, 24
	Oct 2014 18:25:00 +0200")
Message-ID: <871tpx1gcx.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19l9+gEDlGydzmFFJFW8qVfosGXdJcKszY=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4932]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.0 XMSubMetaSx_00 1+ Sexy Words
	*  1.2 XMSubMetaSSx_00 1+ SortaSexy Words + 1 Sexy Word
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Hans de Bruin <jmdebruin@xmsnet.nl>
X-Spam-Relay-Country: 
X-Spam-Timing: total 369 ms - load_scoreonly_sql: 0.14 (0.0%),
	signal_user_changed: 4.3 (1.2%), b_tie_ro: 2.7 (0.7%), parse: 1.64 (0.4%),
	extract_message_metadata: 20 (5.5%), get_uri_detail_list: 2.5 (0.7%),
	tests_pri_-1000: 5 (1.4%), tests_pri_-950: 1.46 (0.4%), tests_pri_-900: 1.14
	(0.3%), tests_pri_-400: 29 (7.8%), check_bayes: 27 (7.4%), b_tokenize: 9
	(2.5%), b_tok_get_all: 7 (1.9%), b_comp_prob: 3.4 (0.9%), b_tok_touch_all:
	4.9 (1.3%), b_finish: 0.77 (0.2%), tests_pri_0: 293 (79.5%), tests_pri_500: 8
	(2.1%), rewrite_mail: 0.00 (0.0%)
Subject: Re: 3.17.0+ files disappearing after playing old dos game on nfsroot laptop
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hans de Bruin <jmdebruin@xmsnet.nl> writes:

> On 10/19/2014 07:32 PM, Hans de Bruin wrote:
>> On 10/15/2014 10:00 PM, Hans de Bruin wrote:
>>> After playing an old dos game i am missing files on my nfsroot installed
>>> laptop. Which one, wel /bin/ls is at least one of them. After a reboot
>>> there all back again.  But not al is well. Some icons on my kde panel
>>> where gone. I have seen this twice in the last day's
>>>
>>
>> The problem appears immediately after starting dosemu so this bisectable
>>
>
>
> My bisect ended here:
>
> commit 8ed936b5671bfb33d89bc60bdcc7cf0470ba52fe
> Author: Eric W. Biederman <ebiederman@twitter.com>
> Date:   Tue Oct 1 18:33:48 2013 -0700
>
>
>      vfs: Lazily remove mounts on unlinked files and directories.
>
>
> I haven reverted it yet.
>
>
>
> Eric,
>
> Immediately after starting dosemu all files under mount point /usr are
> gone. When I play a old dos game for a while (binaries are under /home)
> even /bin/ls disappears. Al mounts are nfs, even /.
>
> Could you look in to this and cc this to the relevant kernel
> mailinglist?

At this point I don't know enough to reproduce this.
What does /proc/mounts look like before you start dosemu?

My expectation is that you should only see this if the mount points are
removed on the nfs server (which does not sound like it is the case).

Although a transient malfunction of the nfs server or misplaced call to
check_submounts_and_drop could cause mounts to disappear as well.  
During testing autofs was observed to have an inappropriate call
to d_invalidate and it is unlikely but possible something like
that is going on with nfs as well.

Are your nfs mounts read-only or read-write?

What is your nfs-server and what is it exporting?
Which distro are you running?
Which version of dosemu are you running?
How is dosemu configured to access files on your filesystem?

Eric

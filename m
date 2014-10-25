Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948AbaJYUay (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 16:30:54 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:53542 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbaJYUaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 16:30:52 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Hans de Bruin <jmdebruin@xmsnet.nl>
Cc: "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-nfs@vger.kernel.org
References: <543ED24D.4070905@xmsnet.nl> <5443F5A1.1050004@xmsnet.nl>
	<544A7933.3010702@xmsnet.nl> <544A7D5C.5060804@xmsnet.nl>
	<871tpx1gcx.fsf@x220.int.ebiederm.org> <544B7D9F.1070403@xmsnet.nl>
Date: Sat, 25 Oct 2014 07:55:19 -0700
In-Reply-To: <544B7D9F.1070403@xmsnet.nl> (Hans de Bruin's message of "Sat, 25
	Oct 2014 12:38:23 +0200")
Message-ID: <87k33ow65k.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18Fol6gHXBn9xJ66DLvhvuKt6jocBEqVV4=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.0 XMSubMetaSx_00 1+ Sexy Words
	*  1.2 XMSubMetaSSx_00 1+ SortaSexy Words + 1 Sexy Word
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Hans de Bruin <jmdebruin@xmsnet.nl>
X-Spam-Relay-Country: 
X-Spam-Timing: total 482 ms - load_scoreonly_sql: 0.04 (0.0%),
	signal_user_changed: 3.1 (0.6%), b_tie_ro: 2.2 (0.5%), parse: 1.19 (0.2%),
	extract_message_metadata: 17 (3.5%), get_uri_detail_list: 6 (1.2%),
	tests_pri_-1000: 4.5 (0.9%), tests_pri_-950: 1.22 (0.3%), tests_pri_-900:
	1.01 (0.2%), tests_pri_-400: 31 (6.4%), check_bayes: 29 (6.1%), b_tokenize:
	11 (2.3%), b_tok_get_all: 9 (1.9%), b_comp_prob: 4.0 (0.8%), b_tok_touch_all:
	2.7 (0.6%), b_finish: 1.00 (0.2%), tests_pri_0: 412 (85.4%), tests_pri_500: 8
	(1.6%), rewrite_mail: 0.00 (0.0%)
Subject: Re: 3.17.0+ files disappearing after playing old dos game on nfsroot laptop
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hans de Bruin <jmdebruin@xmsnet.nl> writes:

> On 10/24/2014 08:18 PM, Eric W. Biederman wrote:

[...]

>> At this point I don't know enough to reproduce this.
>> What does /proc/mounts look like before you start dosemu?
>
> bash-4.2$ cat /proc/mounts
> rootfs / rootfs rw 0 0
> 10.10.0.1:/nfs/root/psion_14.1 / nfs
> rw,relatime,vers=3,rsize=4096,wsize=4096,namlen=255,hard,nolock,proto=tcp,timeo=600,retrans=2,sec=sys,mountaddr=10.10.0.1,mountvers=3,mountproto=tcp,local_lock=all,addr=10.10.0.1
> 0 0
> devtmpfs /dev devtmpfs rw,relatime,size=1031016k,nr_inodes=220978,mode=755 0 0
> proc /proc proc rw,relatime 0 0
> sysfs /sys sysfs rw,relatime 0 0
> tmpfs /run tmpfs rw,relatime,mode=755 0 0
> devpts /dev/pts devpts rw,relatime,gid=5,mode=620 0 0
> cgroup /sys/fs/cgroup cgroup rw,relatime,cpu 0 0
> /dev/shm /tmp tmpfs rw,relatime,size=524288k 0 0
> /dev/shm /dev/shm tmpfs rw,relatime,size=524288k 0 0
> nfs:/nfs/usr/slackware-14.1/usr /usr nfs
> ro,relatime,vers=3,rsize=262144,wsize=262144,namlen=255,hard,proto=tcp,timeo=600,retrans=2,sec=sys,mountaddr=10.10.0.1,mountvers=3,mountport=38337,mountproto=udp,local_lock=none,addr=10.10.0.1
> 0 0
> nfs:/nfs/home /home nfs
> rw,relatime,vers=3,rsize=262144,wsize=262144,namlen=255,hard,proto=tcp,timeo=600,retrans=2,sec=sys,mountaddr=10.10.0.1,mountvers=3,mountport=38337,mountproto=udp,local_lock=none,addr=10.10.0.1
> 0 0
> nfs:/nfs/mp3 /mp3 nfs
> rw,relatime,vers=3,rsize=262144,wsize=262144,namlen=255,hard,proto=tcp,timeo=600,retrans=2,sec=sys,mountaddr=10.10.0.1,mountvers=3,mountport=38337,mountproto=udp,local_lock=none,addr=10.10.0.1
> 0 0
> nfs:/nfs/src /usr/src nfs
> rw,relatime,vers=3,rsize=262144,wsize=262144,namlen=255,hard,proto=tcp,timeo=600,retrans=2,sec=sys,mountaddr=10.10.0.1,mountvers=3,mountport=38337,mountproto=udp,local_lock=none,addr=10.10.0.1
> 0 0
> nfs:/nfs/video /video nfs
> rw,relatime,vers=3,rsize=262144,wsize=262144,namlen=255,hard,proto=tcp,timeo=600,retrans=2,sec=sys,mountaddr=10.10.0.1,mountvers=3,mountport=38337,mountproto=udp,local_lock=none,addr=10.10.0.1
> 0 0
>
> I now know why I do not see any file in /usr after running dosemu. The whole
> /usr mount disappears in /proc/mounts. When I remount it I have a usable laptop
> again. Running dosemu a second time does not remove the mount again. In the mean
> time I have seen /usr disappear after running other programs like xterm and
> firefox. But until now never after remouting it.

That is interesting.

It sounds like occassionally your /home mount disappears as well.

Both of those would be consistent with my patch working doing what it
was designed to do.

My guess is that your nfs mount on / is being weird, and causing valid
directory dentries (AKA /usr and /home) to disappear temporariliy, and
it looks like my change is magnifying that weirdness by causing the
mounts on those directory entries to disappear.

What I don't understand is exactly why nfs is being weird that way yet.

I expect what needs to happen is to confirm that nfs directory entry
revalidation is buggy, and at least for the short term re-add the nfs
logic that will avoid dropping a dentry if it is a mount point, or
path to a mount point, to avoid the nfs bugs.

>> My expectation is that you should only see this if the mount points are
>> removed on the nfs server (which does not sound like it is the case).
>
> This is a at home environment with a nfs server in the meter cupboard. I have
> not changed the exports.

On the nfs server doing "rmdir .../nfs/posion_14.1/home" or
"rmdir .../nfs/posion_14.1/usr" should cause the behavior you are
seeing.

As that you aren't doing that something is weird is going on.

>> Although a transient malfunction of the nfs server or misplaced call to
>> check_submounts_and_drop could cause mounts to disappear as well.
>> During testing autofs was observed to have an inappropriate call
>
> I am not using autofs

I mentioned autofs because I think something similar is probably going
on with nfs, as was observed with autofs.

>> to d_invalidate and it is unlikely but possible something like
>> that is going on with nfs as well.
>>
>> Are your nfs mounts read-only or read-write?

> /usr is mounted ro and exported ro

/ is mounted read-write but that seems seems immaterial at the moment.

>> What is your nfs-server and what is it exporting?
>> Which distro are you running?
>
> The nfs-server is slackware64 14.0 with a 3.4 kernel
> part from exports:
> /nfs/usr       -ro,async,no_subtree_check 10.10.0.0/16
>
> The laptop is slackware(32 bit) 14.1 with yesterday's linus kernel
>
>> Which version of dosemu are you running?
>
> 1.4.0.8

Thanks that information helps.

Eric

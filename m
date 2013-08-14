Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933124Ab3HNTWX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 15:22:23 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:38816 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932641Ab3HNTWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 15:22:22 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Rui Xiang <rui.xiang@huawei.com>, Gao feng <gaofeng@cn.fujitsu.com>,
        netdev@vger.kernel.org, containers@lists.linux-foundation.org,
        serge.hallyn@ubuntu.com, linux-kernel@vger.kernel.org,
        libo.chen@huawei.com, netfilter-devel@vger.kernel.org,
        guz.fnst@cn.fujitsu.com, akpm@linux-foundation.org
References: <1375861035-24320-1-git-send-email-rui.xiang@huawei.com>
	<878v0evssv.fsf@xmission.com> <5202F65F.40002@cn.fujitsu.com>
	<52037D50.2050109@huawei.com> <20130814153017.GA18403@mail.hallyn.com>
Date: Wed, 14 Aug 2013 12:21:47 -0700
In-Reply-To: <20130814153017.GA18403@mail.hallyn.com> (Serge E. Hallyn's
	message of "Wed, 14 Aug 2013 15:30:17 +0000")
Message-ID: <87a9kkcc38.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+nwzhDBKbUZNZDaq12RNiTul0IhZT2e9o=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0004]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Serge E. Hallyn" <serge@hallyn.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH v3 00/11] Add namespace support for syslog
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serge@hallyn.com> writes:

> Quoting Rui Xiang (rui.xiang@huawei.com):
>> On 2013/8/8 9:37, Gao feng wrote:
>> > On 08/07/2013 03:55 PM, Eric W. Biederman wrote:
>> >>
>> >> Since this still has not been addressed.  I am going to repeat Andrews
>> >> objection again.
>> >>
>> >> Isn't there a better way to get iptables information out than to use
>> >> syslog.  I did not have time to follow up on that but it did appear that
>> >> someone did have a better way to get the information out.
>> >>
>> >> Essentially the argument against this goes.  The kernel logging facility
>> >> is really not a particularly good tool to be using for anything other
>> >> than kernel debugging information, and there appear to be no substantial
>> >> uses for a separate syslog that should not be done in other ways.
>> > 
>> > containerizing syslog is not only for iptables, it also isolates the /dev/kmsg,
>> > /proc/kmsg, syslog(2)... user space tools in container may use this interface
>> > to read/generate syslog.
>> > 
>> > But I don't know how important/urgent this containerizing syslog work is,
>> > Rui Xiang, can you find an important/popular user space tool which uses this
>> > interfaces to generate kernel syslog?
>> > 
>> 
>> There are some other cases. Some warnings (bad mount options for tmpfs,
>> bad uid owner for many of them, etc) emerged in the container should
>> be exported to the container. Some belong on the host - if they show 
>> a corrupt superblock which may indicate an attempt by the container 
>> to crash the kernel. Like these, Kernel will print out warnings when 
>> userspace in container uses a deprecated something or other, and these
>> logs should be invisible and specific for current container.
>> 
>> I can't say this work is terribly compelling and important, but the 
>> impact may be obvious, IMO.
>
> Aug  9 21:49:13 sergeh1 kernel: [4644829.672768] init: Failed to spawn network-interface (veth8Ehlvj) post-stop process: unable to change root directory: No such file ricr:aeohgrticr  cfe rty444984 n:aetswnw-ta(ht -rrsultheoit: hlrro<4865i:i sntkta(ht ttpe btheoit: hlrrob r6ezt)nrgoadgte644915 c0pt(tyg ti wd a
> Aug  9 21:49:13 sergeh1 kernel: X3f d-6:uigitra ora
> Aug  9 22:19:54 sergeh1 kernel: 6[642.175 X3f d-6:mutdflsse ihodrddt oe==99 rfl=lccnanrdfutwt-etn"nm=/a/ah/x/lu-ui/m.AExdu"pi=91 om=mut sye"x3name="/devlo0" lg=r"ol pmc r=3an19pfel-nireu-tntgne/rc/cldudmHEqu d97o=otfy=x"ra=d/o/fg""8b:o vhc)nrgibdte646013 veeMzWe oso d<[4715]xr r1eMc egset
> Aug

That is certainly a mess.  Now I don't believe we allow processes in a
user namespace to write to the kernels log (certainly we shouldn't be)
so part of that is not a problem.

What is interleaving messages into syslog?

And to be clear my only perspective is that we need to make certain we
have this thought out.

Eric

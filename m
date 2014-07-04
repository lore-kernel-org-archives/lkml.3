Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219AbaGDFoU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 01:44:20 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:34115 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755692AbaGDFoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 01:44:17 -0400
X-Greylist: delayed 539 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 Jul 2014 01:44:17 EDT
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.2.3
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20140219
Date: Fri, 04 Jul 2014 14:34:30 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: =?SHIFT_JIS?B?IkNoZW4sIEhhbnhpYW8vPyD61ui6Ig==?= 
	<chenhanxiao@cn.fujitsu.com>
Subject: Re: [RFC]Pid conversion between pid namespace
Cc: "Eric W. Biederman (ebiederm@xmission.com)" <ebiederm@xmission.com>,
        "Serge Hallyn (serge.hallyn@ubuntu.com)" <serge.hallyn@ubuntu.com>,
        "Oleg Nesterov (oleg@redhat.com)" <oleg@redhat.com>,
        "Richard Weinberger (richard@nod.at)" <richard@nod.at>,
        "Pavel Emelyanov (xemul@parallels.com)" <xemul@parallels.com>,
        "Vasily Kulikov (segoon@openwall.com)" <segoon@openwall.com>,
        "'Daniel P. Berrange (berrange@redhat.com)'" <berrange@redhat.com>,
        "containers@lists.linux-foundation.org" 
	<containers@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <5871495633F38949900D2BF2DC04883E55C374@G08CNEXMBPEKD02.g08.fujitsu.local>
References: <5871495633F38949900D2BF2DC04883E55C374@G08CNEXMBPEKD02.g08.fujitsu.local>
Message-Id: <20140704143422.6B90.E1E9C6FF@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.66 [ja]
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chen-san,

I would like to recommend that you summarize pros/cons for all ideas so far.

For example,

---------
A) make new system call for transrate 

   A-1) systemcall(ID, NS1, NS2) into (ID).
     pros: 
        - foo
        - baa

     cons: 
        - hoge
        - hogehogehoge

   A-2) pid_t getnspid(pid_t query_pid, pid_t observer_pid) 
      (ditto)


B) make/change proc file/directories
   B-1) expand /proc/pid/status
       (ditto)
   
   B-2) /proc/<pidX>/ns/proc/ which would contain everything
         from /proc/<pidX inside the namespace>/.
       (ditto)


------

Please make clear what is the good/bad point of each opinion by the above,
  - Is it hard to keep compatiblity?
  - Is it hard to understand for administorator/programmer?
  - Is it difficult to show for "nested containers"?
  - Is userland tool necessary?
  - any other problems?

I hope it will be good discussion by the above.

Thanks,

> Hi,
> 
> We had some discussions on how to carry out
> pid conversion between pid namespace via:
> syscall[1] and procfs[2].
> 
> Pavel suggested that a syscall like
> (ID, NS1, NS2) into (ID).
> 
> Serge suggested that a syscall 
> pid_t getnspid(pid_t query_pid, pid_t observer_pid).
> 
> 
> Eric and Richard suggested a procfs solution is
> more appropriate.
> 
> Oleg suggested that we should expand /proc/pid/status
> to report this kind of information.
> 
> And Richard suggested adding a directory like
> /proc/<pidX>/ns/proc/ which would contain everything
> from /proc/<pidX inside the namespace>/.
> 
> As procfs provided a more user friendly interface,
> how about expose all sets of tgid, pid, pgid, sid 
> by expanding /proc/PID/status in procfs?
> And we could also expose ns hierarchy under /proc,
> which could be another reference.
> 
> Ex:
>     init_pid_ns    ns1         ns2
> t1  2
> t2   `- 3          1 
> t3       `- 4      `- 5        1
> 
> We could get in /proc/t3/status:
> NSpid: 4 5 1
> We knew that pid 1 in container is pid 4 in init ns.
> 
> And we could get ns hierarchy under /proc/ns_hierarchy like:
> init_ns->ns1->ns2		(as the result of readlink)
>          ->ns3
> We knew that t3 in ns2, and its hierarchy.
> 
> How these ideas looks like?
> Any comments would be appreciated.
> 
> Thanks,
> - Chen
> 
> 
> a) syscall
> http://lwn.net/Articles/602987/
> 
> b) procfs
> http://www.spinics.net/lists/kernel/msg1751688.html
> 

-- 
Yasunori Goto <y-goto@jp.fujitsu.com>



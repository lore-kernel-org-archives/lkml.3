Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353Ab3HQNi4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Aug 2013 09:38:56 -0400
Received: from static.92.5.9.176.clients.your-server.de ([176.9.5.92]:41618
	"EHLO hallynmail2" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753115Ab3HQNiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Aug 2013 09:38:54 -0400
Date: Sat, 17 Aug 2013 13:38:51 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Rui Xiang <rui.xiang@huawei.com>,
        Gao feng <gaofeng@cn.fujitsu.com>, netdev@vger.kernel.org,
        containers@lists.linux-foundation.org, serge.hallyn@ubuntu.com,
        linux-kernel@vger.kernel.org, libo.chen@huawei.com,
        netfilter-devel@vger.kernel.org, guz.fnst@cn.fujitsu.com,
        akpm@linux-foundation.org
Subject: Re: [PATCH v3 00/11] Add namespace support for syslog
Message-ID: <20130817133851.GA11175@mail.hallyn.com>
References: <1375861035-24320-1-git-send-email-rui.xiang@huawei.com>
 <878v0evssv.fsf@xmission.com>
 <5202F65F.40002@cn.fujitsu.com>
 <52037D50.2050109@huawei.com>
 <20130814153017.GA18403@mail.hallyn.com>
 <87a9kkcc38.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a9kkcc38.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> "Serge E. Hallyn" <serge@hallyn.com> writes:
> 
> > Quoting Rui Xiang (rui.xiang@huawei.com):
> >> On 2013/8/8 9:37, Gao feng wrote:
> >> > On 08/07/2013 03:55 PM, Eric W. Biederman wrote:
> >> >>
> >> >> Since this still has not been addressed.  I am going to repeat Andrews
> >> >> objection again.
> >> >>
> >> >> Isn't there a better way to get iptables information out than to use
> >> >> syslog.  I did not have time to follow up on that but it did appear that
> >> >> someone did have a better way to get the information out.
> >> >>
> >> >> Essentially the argument against this goes.  The kernel logging facility
> >> >> is really not a particularly good tool to be using for anything other
> >> >> than kernel debugging information, and there appear to be no substantial
> >> >> uses for a separate syslog that should not be done in other ways.
> >> > 
> >> > containerizing syslog is not only for iptables, it also isolates the /dev/kmsg,
> >> > /proc/kmsg, syslog(2)... user space tools in container may use this interface
> >> > to read/generate syslog.
> >> > 
> >> > But I don't know how important/urgent this containerizing syslog work is,
> >> > Rui Xiang, can you find an important/popular user space tool which uses this
> >> > interfaces to generate kernel syslog?
> >> > 
> >> 
> >> There are some other cases. Some warnings (bad mount options for tmpfs,
> >> bad uid owner for many of them, etc) emerged in the container should
> >> be exported to the container. Some belong on the host - if they show 
> >> a corrupt superblock which may indicate an attempt by the container 
> >> to crash the kernel. Like these, Kernel will print out warnings when 
> >> userspace in container uses a deprecated something or other, and these
> >> logs should be invisible and specific for current container.
> >> 
> >> I can't say this work is terribly compelling and important, but the 
> >> impact may be obvious, IMO.
> >
> > Aug  9 21:49:13 sergeh1 kernel: [4644829.672768] init: Failed to spawn network-interface (veth8Ehlvj) post-stop process: unable to change root directory: No such file ricr:aeohgrticr  cfe rty444984 n:aetswnw-ta(ht -rrsultheoit: hlrro<4865i:i sntkta(ht ttpe btheoit: hlrrob r6ezt)nrgoadgte644915 c0pt(tyg ti wd a
> > Aug  9 21:49:13 sergeh1 kernel: X3f d-6:uigitra ora
> > Aug  9 22:19:54 sergeh1 kernel: 6[642.175 X3f d-6:mutdflsse ihodrddt oe==99 rfl=lccnanrdfutwt-etn"nm=/a/ah/x/lu-ui/m.AExdu"pi=91 om=mut sye"x3name="/devlo0" lg=r"ol pmc r=3an19pfel-nireu-tntgne/rc/cldudmHEqu d97o=otfy=x"ra=d/o/fg""8b:o vhc)nrgibdte646013 veeMzWe oso d<[4715]xr r1eMc egset
> > Aug
> 
> That is certainly a mess.  Now I don't believe we allow processes in a
> user namespace to write to the kernels log (certainly we shouldn't be)
> so part of that is not a problem.

I'll have to test with user namespaces (next week - don't have a
setup right now)

However user namespaces can't be used in every case, due especially to
device restrictions and cap_capable calls.  So it may not be ok to say
"user namespaces will stop this."

> What is interleaving messages into syslog?

Heh, I'm actually not sure.  I do know it happens every time I start
a container.  I believe one of the sources is net/ipv6/addrconf.c.
Another looks like a apparmor=denied message (I say that due to the
"name=" in the garbled output).  Which would beg the question is this
actually a bug in audit.  (This is on a 3.2 kernel)  Another other may
be an upstart job relating to the nic going up.

> And to be clear my only perspective is that we need to make certain we
> have this thought out.

Agreed.  I need to test a few things as soon as I have time.

-serge

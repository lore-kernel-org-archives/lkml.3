Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758670Ab3HNPaV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 11:30:21 -0400
Received: from static.92.5.9.176.clients.your-server.de ([176.9.5.92]:55631
	"EHLO hallynmail2" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752449Ab3HNPaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 11:30:19 -0400
Date: Wed, 14 Aug 2013 15:30:17 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Rui Xiang <rui.xiang@huawei.com>
Cc: Gao feng <gaofeng@cn.fujitsu.com>, netdev@vger.kernel.org,
        containers@lists.linux-foundation.org, serge.hallyn@ubuntu.com,
        linux-kernel@vger.kernel.org, libo.chen@huawei.com,
        netfilter-devel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>, guz.fnst@cn.fujitsu.com,
        akpm@linux-foundation.org
Subject: Re: [PATCH v3 00/11] Add namespace support for syslog
Message-ID: <20130814153017.GA18403@mail.hallyn.com>
References: <1375861035-24320-1-git-send-email-rui.xiang@huawei.com>
 <878v0evssv.fsf@xmission.com>
 <5202F65F.40002@cn.fujitsu.com>
 <52037D50.2050109@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52037D50.2050109@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Rui Xiang (rui.xiang@huawei.com):
> On 2013/8/8 9:37, Gao feng wrote:
> > On 08/07/2013 03:55 PM, Eric W. Biederman wrote:
> >>
> >> Since this still has not been addressed.  I am going to repeat Andrews
> >> objection again.
> >>
> >> Isn't there a better way to get iptables information out than to use
> >> syslog.  I did not have time to follow up on that but it did appear that
> >> someone did have a better way to get the information out.
> >>
> >> Essentially the argument against this goes.  The kernel logging facility
> >> is really not a particularly good tool to be using for anything other
> >> than kernel debugging information, and there appear to be no substantial
> >> uses for a separate syslog that should not be done in other ways.
> > 
> > containerizing syslog is not only for iptables, it also isolates the /dev/kmsg,
> > /proc/kmsg, syslog(2)... user space tools in container may use this interface
> > to read/generate syslog.
> > 
> > But I don't know how important/urgent this containerizing syslog work is,
> > Rui Xiang, can you find an important/popular user space tool which uses this
> > interfaces to generate kernel syslog?
> > 
> 
> There are some other cases. Some warnings (bad mount options for tmpfs,
> bad uid owner for many of them, etc) emerged in the container should
> be exported to the container. Some belong on the host - if they show 
> a corrupt superblock which may indicate an attempt by the container 
> to crash the kernel. Like these, Kernel will print out warnings when 
> userspace in container uses a deprecated something or other, and these
> logs should be invisible and specific for current container.
> 
> I can't say this work is terribly compelling and important, but the 
> impact may be obvious, IMO.

Aug  9 21:49:13 sergeh1 kernel: [4644829.672768] init: Failed to spawn network-interface (veth8Ehlvj) post-stop process: unable to change root directory: No such file ricr:aeohgrticr  cfe rty444984 n:aetswnw-ta(ht -rrsultheoit: hlrro<4865i:i sntkta(ht ttpe btheoit: hlrrob r6ezt)nrgoadgte644915 c0pt(tyg ti wd a
Aug  9 21:49:13 sergeh1 kernel: X3f d-6:uigitra ora
Aug  9 22:19:54 sergeh1 kernel: 6[642.175 X3f d-6:mutdflsse ihodrddt oe==99 rfl=lccnanrdfutwt-etn"nm=/a/ah/x/lu-ui/m.AExdu"pi=91 om=mut sye"x3name="/devlo0" lg=r"ol pmc r=3an19pfel-nireu-tntgne/rc/cldudmHEqu d97o=otfy=x"ra=d/o/fg""8b:o vhc)nrgibdte646013 veeMzWe oso d<[4715]xr r1eMc egset
Aug



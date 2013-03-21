Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927Ab3CUPgk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 11:36:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24052 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754529Ab3CUPgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 11:36:38 -0400
X-Authority-Analysis: v=2.0 cv=UN5f7Vjy c=1 sm=0 a=tLUlnkoJZcZI9ocdGARlSQ==:17 a=c11ml42nfjYA:10 a=wom5GMh1gUkA:10 a=PQXwkx6xI6AA:10 a=Rj1_iGo3bfgA:10 a=kj9zAlcOel0A:10 a=hBqU3vQJAAAA:8 a=v06FSq8qSjgA:10 a=20KFwNOVAAAA:8 a=7JgLs6tnqoPRVgF8aR0A:9 a=CjuIK1q_8ugA:10 a=jEp0ucaQiEUA:10 wl=env:18 a=tLUlnkoJZcZI9ocdGARlSQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 70.114.148.7
Date: Thu, 21 Mar 2013 10:37:25 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Matthew Garrett <matthew.garrett@nebula.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        James Morris <jmorris@namei.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH 01/12] Security: Add CAP_COMPROMISE_KERNEL
Message-ID: <20130321153725.GA3656@austin.hallyn.com>
References: <alpine.LRH.2.02.1303191542200.30973@tundra.namei.org>
 <1363797717.2580.10.camel@falcor1.watson.ibm.com>
 <1363798166.2553.29.camel@x230.sbx07502.somerma.wayport.net>
 <1363802506.2580.55.camel@falcor1.watson.ibm.com>
 <1363803158.2553.33.camel@x230.sbx07502.somerma.wayport.net>
 <1363806968.2580.86.camel@falcor1.watson.ibm.com>
 <1363811856.2553.37.camel@x230.sbx07502.somerma.wayport.net>
 <1363813877.2580.120.camel@falcor1.watson.ibm.com>
 <1363814289.2553.41.camel@x230.sbx07502.somerma.wayport.net>
 <20130321134348.GA3934@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130321134348.GA3934@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Vivek Goyal (vgoyal@redhat.com):
...
> Giving CAP_MODIFY_KERNEL to processess upon signature verification
> will simplify things a bit.
> 
> Only thing is that signature verification alone is not sufficient. We
> also need to make sure after signature verification executable can
> not be modified in memory in any way. So that means atleast couple of
> things.

Also what about context?  If I construct a mounts namespace a certain
way, can I trick this executable into loading an old singed bzImage that
I had laying around?

ISTM the only sane thing to do, if you're going down this road,
is to have CAP_MODIFIY_KERNEL pulled from bounding set for everyone
except a getty started by init on ttyS0.  Then log in on serial
to update.  Or run a damon with CAP_MODIFIY_KERNEL which listens
to a init_net_ns netlink socket for very basic instructions, like
"find and install latest signed bzImage in /boot".  Then you can
at least trust that /boot for that daemon is not faked.

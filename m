Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621Ab3J3KWo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 06:22:44 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:44090 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838Ab3J3KWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 06:22:42 -0400
Message-ID: <5270DDEE.8070606@hitachi.com>
Date: Wed, 30 Oct 2013 19:22:38 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Pekka Enberg <penberg@iki.fi>
Cc: David Ahern <dsahern@gmail.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        "hegdevasant@linux.vnet.ibm.com" <hegdevasant@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>, "anton@redhat.com" <anton@redhat.com>,
        "systemtap@sourceware.org" <systemtap@sourceware.org>,
        Namhyung Kim <namhyung@kernel.org>,
        "aravinda@linux.vnet.ibm.com" <aravinda@linux.vnet.ibm.com>,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: [PATCH v4 2/3] Support for perf to probe into SDT markers:
References: <20131023044511.1886.82571.stgit@hemant-fedora> <20131023050502.1886.15779.stgit@hemant-fedora> <CAOJsxLFKm3TxeTmGjbpr1r4sZ8fHcM481-5BM_Cq0J8hhtvBqQ@mail.gmail.com> <20131025125921.GA29424@linux.vnet.ibm.com> <F53BA283-A194-4057-8409-27FD3ECFDF2E@iki.fi> <526A8C2B.7000401@gmail.com> <526E24EA.2040701@iki.fi> <526E9808.4030607@gmail.com> <526EB0C3.2080304@iki.fi>
In-Reply-To: <526EB0C3.2080304@iki.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/10/29 3:45), Pekka Enberg wrote:
> On 10/28/13 6:59 PM, David Ahern wrote:
>  > I often use perf-list to lookup an exact event name, and I do not want
>  > to see it taking many seconds to minutes to run (not everyone is
>  > running on an SSD). I also run perf on many different OS versions with
>  > an NFS home directory, and do not want to see a cache explosion (I
>  > have buildid disabled for this reason).
> 
> I am talking about reasonable defaults - the 'default' part implies that
> people can change the behavior.  So we absolutely should also have
> something like this for power users such as yourself:
> 
>    perf config sdt.scan false

Ah, I like this perf-config to store the default/customized values ;)

> That said, the 'reasonable' part suggests that 'perf list' must not take
> seconds or minutes (!) for every run.  I'd start with implementing a
> naive scan and seeing where it takes us.  It's not like it's rocket
> science to ignore network mounts or revert to a whitelist of paths if
> necessary.

I think it is reasonable to scan only $PATH and ld.so.cache (the result
of ldconfig --print-cache) by default. :)

Thank you,



-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com



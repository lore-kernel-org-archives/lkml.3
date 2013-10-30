Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752053Ab3J3KFt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 06:05:49 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:36027 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088Ab3J3KFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 06:05:47 -0400
Message-ID: <5270D9F7.3090105@hitachi.com>
Date: Wed, 30 Oct 2013 19:05:43 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Pekka Enberg <penberg@kernel.org>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        hegdevasant@linux.vnet.ibm.com, Ingo Molnar <mingo@redhat.com>,
        anton@redhat.com, systemtap@sourceware.org,
        Namhyung Kim <namhyung@kernel.org>, aravinda@linux.vnet.ibm.com,
        dsahern@gmail.com,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: [PATCH v4 2/3] Support for perf to probe into SDT markers:
References: <20131023044511.1886.82571.stgit@hemant-fedora> <20131023050502.1886.15779.stgit@hemant-fedora> <CAOJsxLFKm3TxeTmGjbpr1r4sZ8fHcM481-5BM_Cq0J8hhtvBqQ@mail.gmail.com> <y0mbo2cs2oa.fsf@fche.csb>
In-Reply-To: <y0mbo2cs2oa.fsf@fche.csb>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/10/26 20:16), Frank Ch. Eigler wrote:
> Pekka Enberg <penberg@kernel.org> writes:
> 
>> Is there a technical reason why 'perf list' could not show all the
>> available SDT markers on a system and that the 'mark to event'
>> mapping cannot happen automatically? [...]
> 
> A quick experiment with:
> 
>   find `echo $PATH | tr : ' '` -type f -perm -555 | 
>        xargs readelf -n 2>/dev/null | 
>        grep STAP 2>/dev/null 
> 
> suggests reasonable performance for my F19 workstation (a second or
> two over ~6000 executables), once all the ELF content is in the block
> cache.  According to a stap eventcount.stp run, that required about
> 50000 syscall.read events.
> 
> Note that a $PATH search excludes shared libraries, which can also
> carry <sys/sdt.h> markers.  Adding /usr/lib* in more than doubles the
> work, then there's /usr/libexec etc.

To find all system libraries, we can use ldconfig.

$ ldconfig --print-cache

shows what dynamic libraries will be loaded. On my own laptop (running
ubuntu13.04) shows ~1000 libs.

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com



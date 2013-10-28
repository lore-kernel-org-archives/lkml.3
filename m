Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350Ab3J1Ikn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 04:40:43 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:53145 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750998Ab3J1Ikl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 04:40:41 -0400
X-Sasl-enc: irXBiIskrwcE5Odee7XJEOaRKHbyu+1JlAI/3Vk3VoY9 1382949640
Message-ID: <526E2304.1000407@iki.fi>
Date: Mon, 28 Oct 2013 10:40:36 +0200
From: Pekka Enberg <penberg@iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: "Frank Ch. Eigler" <fche@redhat.com>, Pekka Enberg <penberg@kernel.org>
CC: Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        hegdevasant@linux.vnet.ibm.com, Ingo Molnar <mingo@redhat.com>,
        anton@redhat.com, systemtap@sourceware.org,
        Namhyung Kim <namhyung@kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        aravinda@linux.vnet.ibm.com
Subject: Re: [PATCH v4 2/3] Support for perf to probe into SDT markers:
References: <20131023044511.1886.82571.stgit@hemant-fedora>	<20131023050502.1886.15779.stgit@hemant-fedora>	<CAOJsxLFKm3TxeTmGjbpr1r4sZ8fHcM481-5BM_Cq0J8hhtvBqQ@mail.gmail.com> <y0mbo2cs2oa.fsf@fche.csb>
In-Reply-To: <y0mbo2cs2oa.fsf@fche.csb>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26/2013 02:16 PM, Frank Ch. Eigler wrote:
> Pekka Enberg <penberg@kernel.org> writes:
>
>> Is there a technical reason why 'perf list' could not show all the
>> available SDT markers on a system and that the 'mark to event'
>> mapping cannot happen automatically? [...]
> A quick experiment with:
>
>    find `echo $PATH | tr : ' '` -type f -perm -555 |
>         xargs readelf -n 2>/dev/null |
>         grep STAP 2>/dev/null
>
> suggests reasonable performance for my F19 workstation (a second or
> two over ~6000 executables), once all the ELF content is in the block
> cache.  According to a stap eventcount.stp run, that required about
> 50000 syscall.read events.
>
> Note that a $PATH search excludes shared libraries, which can also
> carry <sys/sdt.h> markers.  Adding /usr/lib* in more than doubles the
> work, then there's /usr/libexec etc.

Thanks for providing numbers to the discussion. AFAICT, we
might even be able to just scan everything for 'perf list' by
default.

                     Pekka

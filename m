Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960AbaLAOmj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 09:42:39 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42386 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753673AbaLAOmi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 09:42:38 -0500
Message-ID: <547C7E59.9040408@suse.com>
Date: Mon, 01 Dec 2014 15:42:33 +0100
From: Juergen Gross <jgross@suse.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@suse.com>,
        David Vrabel <david.vrabel@citrix.com>
CC: Andrew Cooper <andrew.cooper3@citrix.com>, x86@kernel.org,
        kvm@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        linux-kernel@vger.kernel.org, Davidlohr Bueso <dbueso@suse.de>,
        Joerg Roedel <jroedel@suse.de>, Jan Beulich <JBeulich@suse.com>,
        xen-devel@lists.xenproject.org, boris.ostrovsky@oracle.com,
        Borislav Petkov <bp@suse.de>, Olaf Hering <ohering@suse.de>
Subject: Re: [Xen-devel] [PATCH] xen: privcmd: schedule() after private hypercall
 when non CONFIG_PREEMPT
References: <1417040805-15857-1-git-send-email-mcgrof@do-not-panic.com> <5476C66F.5040308@suse.com> <20141127183616.GV25677@wotan.suse.de> <54777277.5040401@citrix.com> <5477FECF.2060404@suse.com> <547C4A7E.6020207@citrix.com> <20141201133245.GA25677@wotan.suse.de>
In-Reply-To: <20141201133245.GA25677@wotan.suse.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01/2014 02:32 PM, Luis R. Rodriguez wrote:
> On Mon, Dec 01, 2014 at 11:01:18AM +0000, David Vrabel wrote:
>> On 28/11/14 04:49, Juergen Gross wrote:
>>> On 11/27/2014 07:50 PM, Andrew Cooper wrote:
>>>>
>>>> XenServer uses
>>>>
>>>> https://github.com/xenserver/linux-3.x.pg/blob/master/master/0001-x86-xen-allow-privcmd-hypercalls-to-be-preempted.patch
>>>>
>>>>
>>>> to deal with these issues.  That patch is based on 3.10.
>>>
>>> Clever. :-)
>>>
>>>>
>>>> I can remember whether this has been submitted upstream before (and
>>>> there were outstanding issues), or whether it fell at an inconvenient
>>>> time with our development cycles.
>>>
>>> I found
>>>
>>> http://lists.xen.org/archives/html/xen-devel/2014-02/msg02540.html
>>>
>>> and nothing else.
>>
>> I dropped it because it copy-and-paste a bunch of otherwise generic x86
>> assembler and looked unlikely to get an x86 maintainer ack.  If you
>> think otherwise, feel free to pick it up and run with it.
>
> I was trying to run with it, but my biggest gripe with this was
> the use of preempt_schedule_irq(), but we can review that on the
> other thread.

I think this can be handled completely inside xen_evtchn_do_upcall().

xen_preemptible_hcall_begin() (possibly with another name) could take
the pointer of a function as parameter which is used as continuation
point after an asynchronous interrupt in the critical section.
Parameter for that function would be the exception frame of the
original interrupt to be able to continue at the interrupted position
after e.g. calling schedule().


Juergen

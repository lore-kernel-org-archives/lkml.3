Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071Ab3KNOLc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 09:11:32 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:33924 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754048Ab3KNOLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 09:11:22 -0500
MIME-Version: 1.0
In-Reply-To: <1384429730.29902.129.camel@Abyss>
References: <1384400179-24404-1-git-send-email-ufimtseva@gmail.com>
	<1384400179-24404-2-git-send-email-ufimtseva@gmail.com>
	<1384414000.29902.25.camel@Abyss>
	<5284B238.6020601@citrix.com>
	<1384429730.29902.129.camel@Abyss>
Date: Thu, 14 Nov 2013 09:11:20 -0500
Message-ID: <CAEr7rXjwnb9QB6=8Dy+_BU97dK5bOYLhwqtcS=YAZVUSdrEeGA@mail.gmail.com>
Subject: Re: [Xen-devel] [PATCH 1/2] xen: vnuma support for PV guests running
 as domU.
From: Elena Ufimtseva <ufimtseva@gmail.com>
To: Dario Faggioli <dario.faggioli@citrix.com>
Cc: David Vrabel <david.vrabel@citrix.com>,
        Ian Campbell <ian.campbell@citrix.com>, wency@cn.fujitsu.com,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, tangchen@cn.fujitsu.com,
        mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com,
        xen-devel@lists.xenproject.org, akpm@linux-foundation.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 14, 2013 at 6:48 AM, Dario Faggioli
<dario.faggioli@citrix.com> wrote:
> On gio, 2013-11-14 at 11:21 +0000, David Vrabel wrote:
>> On 14/11/13 07:26, Dario Faggioli wrote:
>> > IIRC, it's more something that was already happening (the breakage, I
>> > mean), than a "safety net" for the unforeseeable future. Might be worth
>> > giving some context about it, perhaps referencing the email thread or
>> > the git commit hash in the comment.
>>
>> Yes, a comment like:
>>
>> /*
>>  * Set a dummy node and return success.  This prevents calling any
>>  * hardware-specific initializers which do not work in a PV guest.
>>  */
>>
>> is better.  No need to refer to any specific threads.  It's pretty clear
>> that any hardware-specific init isn't appropriate for a PV guest.
>>
> Ok.
>
>> >> +  if (rc != 0) {
>> >> +          for (i = 0; i < MAX_LOCAL_APIC; i++)
>> >> +                  set_apicid_to_node(i, NUMA_NO_NODE);
>> >> +          nodes_clear(numa_nodes_parsed);
>> >> +          nodes_clear(node_possible_map);
>> >> +          nodes_clear(node_online_map);
>> >> +          node_set(0, numa_nodes_parsed);
>> >> +          numa_add_memblk(0, 0, PFN_PHYS(max_pfn));
>> >> +  }
>> >> +  return 0;
>> >>
>> > Ok, so, we always return 'success', as we were saying during last round.
>> > However, we do not call dummy_numa_init() directly, and instead we do
>> > all these stuff, with the last two statements being exactly what
>> > dummy_numa_init() does. Reason is linking, i.e., the fact that
>> > dummy_numa_init() is not exported and you can't reach it from here,
>> > right?

Ah, my bad, I left these comments and they dont make sense :)
>>
>> I think this bit is fine as-is.
>>
> Ok, cool. :-) Shouldn't we then kill or reformulate the comments where
> dummy_numa_init is explicitly referenced then?
>
> E.g., this one: /* will pass to dummy_numa_init */
>
> It might be me, but I find it rather confusing. After seeing that, I'd
> expect to see that, at some point, either the function returns failure
> (which of course we don't want), or a direct call dummy_numa_init().
>
> Dario
>
> --
> <<This happens because I choose it to happen!>> (Raistlin Majere)
> -----------------------------------------------------------------
> Dario Faggioli, Ph.D, http://about.me/dario.faggioli
> Senior Software Engineer, Citrix Systems R&D Ltd., Cambridge (UK)
>



-- 
Elena

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357Ab3HVLeE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 07:34:04 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:44985 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312Ab3HVLeC convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:9:1>);
	Thu, 22 Aug 2013 07:34:02 -0400
Message-Id: <5216134502000078000EDA3D@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Thu, 22 Aug 2013 12:33:57 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Cyrill Gorcunov" <gorcunov@gmail.com>
Cc: "Andy Lutomirski" <luto@amacapital.net>,
        "David Vrabel" <david.vrabel@citrix.com>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        <Xen-devel@lists.xen.org>,
        "Boris Ostrovsky" <boris.ostrovsky@oracle.com>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        "Pavel Emelyanov" <xemul@parallels.com>,
        "Ingo Molnar" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Regression: x86/mm: new _PTE_SWP_SOFT_DIRTY bit conflicts
 with existing use
References: <5214C524.1050900@citrix.com> <20130821141223.GS18673@moon>
 <5214F09002000078000ED5C3@nat28.tlf.novell.com>
 <20130821154238.GV18673@moon>
 <521500E102000078000ED65C@nat28.tlf.novell.com>
 <20130821161946.GW18673@moon>
 <5215D23A02000078000ED7FC@nat28.tlf.novell.com>
 <20130822070305.GH18673@moon>
 <5215D99102000078000ED838@nat28.tlf.novell.com>
 <20130822112727.GL18673@moon>
In-Reply-To: <20130822112727.GL18673@moon>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 22.08.13 at 13:27, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> On Thu, Aug 22, 2013 at 08:27:45AM +0100, Jan Beulich wrote:
>> >>> On 22.08.13 at 09:03, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
>> > Ok, how about this?
>> > 
>> > static inline pte_t pte_swp_mksoft_dirty(pte_t pte)
>> > {
>> > 	BUG_ON(pte_present(pte));
>> > 	return pte_set_flags(pte, _PAGE_SWP_SOFT_DIRTY);
>> > }
>> 
>> Sure, fine with me. Perhaps VM_BUG_ON() or some other similar
>> construct limiting the scope when any extra code gets generated
>> would do too.
> 
> Sorry for delay, the patch is below.
> 
>> 
>> But as said, even better would perhaps be to have it act on a
>> swp_entry_t.
> 
> swp_entry_t is too small already to keep additional status bit,
> unfortunately.
> ---
> From: Cyrill Gorcunov <gorcunov@gmail.com>
> Subject: [PATCH] mm: Make sure _PAGE_SWP_SOFT_DIRTY bit is not set on 
> present pte
> 
> _PAGE_SOFT_DIRTY bit should never be set on present pte so add
> VM_BUG_ON to catch any potential future abuse.
> 
> Also add a comment on _PAGE_SWP_SOFT_DIRTY definition explaining
> scope of its usage.
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>

Acked-by: Jan Beulich <jbeulich@suse.com>

Thanks, Jan


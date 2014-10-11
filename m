Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751103AbaJKCOV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 22:14:21 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:45979 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbaJKCOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 22:14:19 -0400
Date: Sat, 11 Oct 2014 18:11:02 +0800
From: Fengwei Yin <yfw.kernel@gmail.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        fengguang.wu@intel.com,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH] smaps should deal with huge zero page exactly same as
 normal zero page
Message-ID: <20141011101020.GA26953@gmail.com>
References: <CADUXgx7QTWBMxesxgCet5rjpGu-V-xK_-5f2rX9R+v-ggi902A@mail.gmail.com>
 <5436B98E.1070407@intel.com>
 <20141010132027.GB25038@gmail.com>
 <5437EEA3.50705@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5437EEA3.50705@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2014 at 07:35:15AM -0700, Dave Hansen wrote:
> On 10/10/2014 06:21 AM, Fengwei Yin wrote:
> > @@ -787,6 +788,9 @@ check_pfn:
> >  		return NULL;
> >  	}
> >  
> > +	if (is_huge_zero_pfn(pfn))
> > +		return NULL;
> > +
> 
> That looks a lot better.  One thing, why not put the is_huge_zero_pfn()
> check next to the is_zero_pfn() check?

On the arch which has PTE_SPECIAL feaure, we need to make sure the
is_huge_zero_pfn() is called after the pfn is checked if !pte_special().

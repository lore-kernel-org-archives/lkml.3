Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756522Ab3EVO5F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 10:57:05 -0400
Received: from www.sr71.net ([198.145.64.142]:52492 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756477Ab3EVO5C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 10:57:02 -0400
Message-ID: <519CDCBB.7050807@sr71.net>
Date: Wed, 22 May 2013 07:56:59 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
CC: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Hillf Danton <dhillf@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4 29/39] thp: move maybe_pmd_mkwrite() out of mk_huge_pmd()
References: <1368321816-17719-1-git-send-email-kirill.shutemov@linux.intel.com> <1368321816-17719-30-git-send-email-kirill.shutemov@linux.intel.com> <519C01D8.4040301@sr71.net> <20130522143746.A7CE5E0090@blue.fi.intel.com>
In-Reply-To: <20130522143746.A7CE5E0090@blue.fi.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2013 07:37 AM, Kirill A. Shutemov wrote:
> Dave Hansen wrote:
>> On 05/11/2013 06:23 PM, Kirill A. Shutemov wrote:
>>> From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
>>>
>>> It's confusing that mk_huge_pmd() has sematics different from mk_pte()
>>> or mk_pmd().
>>>
>>> Let's move maybe_pmd_mkwrite() out of mk_huge_pmd() and adjust
>>> prototype to match mk_pte().
>>
>> Was there a motivation to do this beyond adding consistency?  Do you use
>> this later or something?
> 
> I spent some time on debugging problem caused by this inconsistency, so at
> that point I was motivated to fix it. :)

A little anecdote that this bit you in practice to help indicate this
isn't just random code churn would be nice.


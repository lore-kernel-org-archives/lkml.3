Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751262AbaJITLy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 15:11:54 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:47692 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008AbaJITLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 15:11:50 -0400
Message-ID: <5436DDEB.5090004@oracle.com>
Date: Thu, 09 Oct 2014 15:11:39 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, mgorman@suse.de
Subject: Re: [PATCH 0/5] mm: poison critical mm/ structs
References: <1412041639-23617-1-git-send-email-sasha.levin@oracle.com> <20141001140725.fd7f1d0cf933fbc2aa9fc1b1@linux-foundation.org> <542C749B.1040103@oracle.com> <alpine.LSU.2.11.1410020154500.6444@eggly.anvils>
In-Reply-To: <alpine.LSU.2.11.1410020154500.6444@eggly.anvils>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2014 05:23 AM, Hugh Dickins wrote:
> I'm glad to hear they've confirmed some vm_area_struct corruption:
> any ideas on where that's coming from?

Hugh,

I think that what we're seeing isn't a corruption of vm_area_struct
per-se, but something weirder.

I've poisoned every spot where vm_area_struct is allocated, and yet
there seems to be nothing that's hitting that field before we end
up using a "zeroed out" vm_area_struct.

The results are the same both with and without kasan, there seems
to be no corruption happening anywhere, but we somehow end up with
an empty vm_area_struct.

It also somewhat makes sense considering that we're seeing no slub
corruption either. Either something is zeroing out *exactly*
vm_area_struct, or it's not really corruption...


Thanks,
Sasha

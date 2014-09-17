Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290AbaIQLmU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 07:42:20 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:35918 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754634AbaIQLmT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 07:42:19 -0400
Date: Wed, 17 Sep 2014 14:42:15 +0300
From: Gleb Natapov <gleb@kernel.org>
To: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc: Andres Lagar-Cavilla <andreslc@google.com>, Gleb Natapov <gleb@redhat.com>,
        Rik van Riel <riel@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Mel Gorman <mgorman@suse.de>, Andy Lutomirski <luto@amacapital.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Sasha Levin <sasha.levin@oracle.com>, Jianyu Zhan <nasa4836@gmail.com>,
        Paul Cassella <cassella@cray.com>, Hugh Dickins <hughd@google.com>,
        Peter Feiner <pfeiner@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] kvm: Faults which trigger IO release the mmap_sem
Message-ID: <20140917114214.GB30733@minantech.com>
References: <1410811885-17267-1-git-send-email-andreslc@google.com>
 <20140917102635.GA30733@minantech.com>
 <20140917112713.GB1273@potion.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20140917112713.GB1273@potion.brq.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2014 at 01:27:14PM +0200, Radim Krčmář wrote:
> 2014-09-17 13:26+0300, Gleb Natapov:
> > For async_pf_execute() you do not need to even retry. Next guest's page fault
> > will retry it for you.
> 
> Wouldn't that be a waste of vmentries?
This is how it will work with or without this second gup. Page is not
mapped into a shadow page table on this path, it happens on a next fault.

--
			Gleb.

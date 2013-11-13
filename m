Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751352Ab3KMVPi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 16:15:38 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56024 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750981Ab3KMVP3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 16:15:29 -0500
Message-ID: <5283EBCD.6070305@zytor.com>
Date: Wed, 13 Nov 2013 13:14:53 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
CC: Kexec Mailing List <kexec@lists.infradead.org>,
        Baoquan He <bhe@redhat.com>, WANG Chao <chaowang@redhat.com>,
        Dave Young <dyoung@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: /proc/vmcore mmap() failure issue
References: <20131113204130.GD7613@redhat.com> <20131113210432.GE7613@redhat.com>
In-Reply-To: <20131113210432.GE7613@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2013 01:04 PM, Vivek Goyal wrote:
> [CC hpa ]
> 
> And this issue brings me to the question that why do we allow sytem RAM
> ranges which do not start on page boundary or do not end on page boundary. 
> Can't we truncate the BIOS reported RAM ranges in such a way so that
> they start and end at PAGE boundary and rest of the kernel will never see
> unaligned portion of RAM and this will make life so much simpler for
> other tools.
> 

That is a bit of a headache for doing in the memblock space.  We do, in
fact, truncate partial pages, but later in the game.  It is possible we
should push that sooner in the stack.  The fact that it makes into the
rbtrees is fishy, but it also makes me wonder if we're doing something
totally stupid with regards to the memory mappings -- if this means
we're mapping ACPI data as noncacheable, that is not just a performance
problem but just plain wrong.  I don't even think the MTRRs can
represent different caching attributes for different parts of a page, so
this is something that we are doing.

	-hpa



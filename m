Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758225Ab3CDRGa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 12:06:30 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:56193 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757398Ab3CDRG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 12:06:29 -0500
Message-ID: <5134D476.3040302@linux.vnet.ibm.com>
Date: Mon, 04 Mar 2013 09:05:58 -0800
From: Dave Hansen <dave@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: KY Srinivasan <kys@microsoft.com>
CC: Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 1/1] mm: Export split_page().
References: <1362364075-14564-1-git-send-email-kys@microsoft.com> <20130304020747.GA8265@kroah.com> <3a362e994ab64efda79ae3c80342db95@SN2PR03MB061.namprd03.prod.outlook.com> <20130304022508.GA8638@kroah.com> <b863089d05f442fb9dfc90faa158a001@SN2PR03MB061.namprd03.prod.outlook.com>
In-Reply-To: <b863089d05f442fb9dfc90faa158a001@SN2PR03MB061.namprd03.prod.outlook.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13030417-7282-0000-0000-000014E5CD4A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/2013 06:36 PM, KY Srinivasan wrote:
>> I guess the most obvious question about exporting this symbol is, "Why
>> doesn't any of the other hypervisor balloon drivers need this?  What is
>> so special about hyper-v?"
> 
> The balloon protocol that Hyper-V has specified is designed around the ability to
> move 2M pages. While the protocol can handle 4k allocations, it is going to be very chatty
> with 4K allocations.

What does "very chatty" mean?  Do you think that there will be a
noticeable performance difference ballooning 2M pages vs 4k?

> Furthermore, the Memory Balancer on the host is also designed to work
> best with memory moving around in 2M chunks. While I have not seen the code on the Windows
> host that does this memory balancing, looking at how Windows guests behave in this environment,
> (relative to Linux) I have to assume that the 2M allocations that Windows guests do are a big part of
> the difference we see.

You've been talking about differences.  Could you elaborate on what the
differences in behavior are that you are trying to rectify here?

>> Or can those other drivers also need/use it as well, and they were just
>> too chicken to be asking for the export?  :)
> 
> The 2M balloon allocations would make sense if the host is designed accordingly.

How does the guest decide which size pages to allocate?  It seems like a
relatively bad idea to be inflating the balloon with 2M pages from the
guest in the case where the guest is under memory pressure _and_
fragmented.


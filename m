Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176AbaKDOTy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 09:19:54 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:59769 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750866AbaKDOTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 09:19:52 -0500
Message-ID: <5458E084.2060208@hurleysoftware.com>
Date: Tue, 04 Nov 2014 09:19:48 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Michal Nazarewicz <mina86@mina86.com>, Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm: alloc_contig_range: demote pages busy message from
 warn to info
References: <2457604.k03RC2Mv4q@avalon> <1415033873-28569-1-git-send-email-mina86@mina86.com> <20141104054307.GA23102@bbox> <5458C501.3040505@hurleysoftware.com> <xa1tvbmv6qco.fsf@mina86.com>
In-Reply-To: <xa1tvbmv6qco.fsf@mina86.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2014 08:35 AM, Michal Nazarewicz wrote:
> On Tue, Nov 04 2014, Peter Hurley <peter@hurleysoftware.com> wrote:
>> On 11/04/2014 12:43 AM, Minchan Kim wrote:
>>> Hello,
>>>
>>> On Mon, Nov 03, 2014 at 05:57:53PM +0100, Michal Nazarewicz wrote:
>>>> Having test_pages_isolated failure message as a warning confuses
>>>> users into thinking that it is more serious than it really is.  In
>>>> reality, if called via CMA, allocation will be retried so a single
>>>> test_pages_isolated failure does not prevent allocation from
>>>> succeeding.
>>>>
>>>> Demote the warning message to an info message and reformat it such
>>>> that the text “failed” does not appear and instead a less worrying
>>>> “PFNS busy” is used.
>>>
>>> What do you expect from this message? Please describe it so that we can
>>> review below message helps your goal.
>>
>> I expect this message to not show up in logs unless there is a real problem.
> 
> So frankly I don't care.  Feel free to send a patch removing the message
> all together.  I'll be happy to ack it.

I'd rather just remove CMA allocation from the iommu providers on x86.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285AbaKDMWa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 07:22:30 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:32824 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751626AbaKDMW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 07:22:29 -0500
Message-ID: <5458C501.3040505@hurleysoftware.com>
Date: Tue, 04 Nov 2014 07:22:25 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Michal Nazarewicz <mina86@mina86.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm: alloc_contig_range: demote pages busy message from
 warn to info
References: <2457604.k03RC2Mv4q@avalon> <1415033873-28569-1-git-send-email-mina86@mina86.com> <20141104054307.GA23102@bbox>
In-Reply-To: <20141104054307.GA23102@bbox>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2014 12:43 AM, Minchan Kim wrote:
> Hello,
> 
> On Mon, Nov 03, 2014 at 05:57:53PM +0100, Michal Nazarewicz wrote:
>> Having test_pages_isolated failure message as a warning confuses
>> users into thinking that it is more serious than it really is.  In
>> reality, if called via CMA, allocation will be retried so a single
>> test_pages_isolated failure does not prevent allocation from
>> succeeding.
>>
>> Demote the warning message to an info message and reformat it such
>> that the text “failed” does not appear and instead a less worrying
>> “PFNS busy” is used.
> 
> What do you expect from this message? Please describe it so that we can
> review below message helps your goal.

I expect this message to not show up in logs unless there is a real problem.

This message is trivially reproducible on a 10GB x86 machine on 3.16.y
kernels configured with CONFIG_DMA_CMA.



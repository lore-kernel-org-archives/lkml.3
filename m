Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757430Ab3IMBl1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 21:41:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26066 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754414Ab3IMBlZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 21:41:25 -0400
Message-ID: <52326D37.8040400@redhat.com>
Date: Thu, 12 Sep 2013 21:41:11 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: dhillf@sina.com
CC: Mel Gorman <mgorman@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Hillf Danton <dhillf@gmail.com>
Subject: Re: [RFC PATCH] ANB(Automatic NUMA Balancing): erase mm footprint
 of migrated page
References: <20130913004538.A7AA3428001@webmail.sinamail.sina.com.cn>
In-Reply-To: <20130913004538.A7AA3428001@webmail.sinamail.sina.com.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2013 08:45 PM, Hillf Danton wrote:
> If a page monitored by ANB is migrated, its footprint should be erased from
> numa-hint-fault account, because it is no longer used. Or two pages, the
> migrated page and its target page, are used in the view of task placement.
> 
> 
> Signed-off-by: Hillf Danton <dhillf@gmail.com>

NAK

The numa faults buffer contains the number of pages on each
node that the task recently faulted on.

If the page got migrated, it is only counted on the new node,
not on the old one. That means there is no need to subtract
it on the old node.

-- 
All rights reversed

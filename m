Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933829Ab3LIP55 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 10:57:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57838 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932555Ab3LIP5z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 10:57:55 -0500
Message-ID: <52A5E87B.9080209@redhat.com>
Date: Mon, 09 Dec 2013 10:57:47 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Alex Thorlton <athorlton@sgi.com>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 09/18] mm: numa: Clear numa hinting information on mprotect
References: <1386572952-1191-1-git-send-email-mgorman@suse.de> <1386572952-1191-10-git-send-email-mgorman@suse.de>
In-Reply-To: <1386572952-1191-10-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2013 02:09 AM, Mel Gorman wrote:
> On a protection change it is no longer clear if the page should be still
> accessible.  This patch clears the NUMA hinting fault bits on a protection
> change.

I had to think about this one, because my first thought was
"wait, aren't NUMA ptes inaccessible already?".

Then I thought about doing things like adding read or write
permission in the mprotect, eg. changing from PROT_NONE to
PROT_READ ... and it became unclear what to do with the NUMA
bit in that case...

This patch clears up some confusing situations :)

> Cc: stable@vger.kernel.org
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed

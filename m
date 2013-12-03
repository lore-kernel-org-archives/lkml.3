Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755650Ab3LCXIA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 18:08:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56863 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755617Ab3LCXH5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 18:07:57 -0500
Message-ID: <529E6447.4030304@redhat.com>
Date: Tue, 03 Dec 2013 18:07:51 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Alex Thorlton <athorlton@sgi.com>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 04/15] mm: numa: Serialise parallel get_user_page against
 THP migration
References: <1386060721-3794-1-git-send-email-mgorman@suse.de> <1386060721-3794-5-git-send-email-mgorman@suse.de>
In-Reply-To: <1386060721-3794-5-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2013 03:51 AM, Mel Gorman wrote:

> +
> +	if (page_count(page) != 2) {
> +		set_pmd_at(mm, mmun_start, pmd, orig_entry);
> +		flush_tlb_range(vma, mmun_start, mmun_end);

The mmun_start and mmun_end variables are introduced in patch 5.

-- 
All rights reversed

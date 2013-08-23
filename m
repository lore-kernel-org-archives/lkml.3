Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556Ab3HWBGJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 21:06:09 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:39646 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752965Ab3HWBGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 21:06:08 -0400
Message-ID: <5216B578.5050506@oracle.com>
Date: Fri, 23 Aug 2013 09:06:00 +0800
From: Joe Jin <joe.jin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Mike Snitzer <snitzer@redhat.com>
CC: Mikulas Patocka <mpatocka@redhat.com>,
        device-mapper development <dm-devel@redhat.com>,
        Alasdair Kergon <agk@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dm: allow error target to replace either bio-based and
 request-based targets
References: <5214CC25.1070307@oracle.com> <alpine.LRH.2.02.1308211041180.10797@file01.intranet.prod.int.rdu2.redhat.com> <52157C6E.6080406@oracle.com> <20130822201900.GB22556@redhat.com> <20130823001750.GA29366@redhat.com>
In-Reply-To: <20130823001750.GA29366@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/13 08:17, Mike Snitzer wrote:
> Here is a patch that should work for your needs (I tested it to work
> with 'dmsetup wipe_table' on both request-based and bio-based devices):

This really what I looking for, thanks!

> 
> From: Mike Snitzer <snitzer@redhat.com>
> Date: Thu, 22 Aug 2013 18:21:38 -0400
> Subject: [PATCH] dm: allow error target to replace either bio-based and request-based targets
> 
> In may be useful to switch a request-based table to the "error" target.
> Enhance the DM core to allow a single hybrid target to be capable of
> handling either bios or requests.
> 
> Add a request-based (.map_rq) member to the error target_type and train
> dm_table_set_type() to prefer the md's established type (request-based
> or bio-based).  If the md doesn't have an established type default to
> making the hybrid target bio-based.

Signed-off-by: Joe Jin <joe.jin@oracle.com>

Thanks,
Joe

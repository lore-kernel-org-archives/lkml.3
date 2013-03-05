Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402Ab3CEXzH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 18:55:07 -0500
Received: from zill.ext.symas.net ([69.43.206.106]:45211 "EHLO
	zill.ext.symas.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753616Ab3CEXzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 18:55:05 -0500
Message-ID: <513685D6.7080102@symas.com>
Date: Tue, 05 Mar 2013 15:55:02 -0800
From: Howard Chu <hyc@symas.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:22.0) Gecko/20100101 Firefox/22.0 SeaMonkey/2.19a1
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: mmap vs fs cache
References: <5136320E.8030109@symas.com>
In-Reply-To: <5136320E.8030109@symas.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Howard Chu wrote:
> 2 questions:
>     why is there data in the FS cache that isn't owned by (the mmap of) the
> process that caused it to be paged in in the first place?
>     is there a tunable knob to discourage the page cache from stealing from the
> process?

This Unmapped page cache control http://lwn.net/Articles/436010/ sounds like 
it might have been helpful here. I.e., having a way to prioritize so that 
unmapped cache pages get reclaimed in preference to mapped pages could help. 
Though I still don't understand why these pages in the cache aren't mapped in 
the first place.

-- 
   -- Howard Chu
   CTO, Symas Corp.           http://www.symas.com
   Director, Highland Sun     http://highlandsun.com/hyc/
   Chief Architect, OpenLDAP  http://www.openldap.org/project/

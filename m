Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760091Ab3EAWvI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 18:51:08 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:36148 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758355Ab3EAWvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 18:51:06 -0400
Message-ID: <51819C54.3030704@linux.vnet.ibm.com>
Date: Wed, 01 May 2013 15:51:00 -0700
From: Cody P Schafer <cody@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] memory_hotplug: use pgdat_resize_lock() when updating
 node_present_pages
References: <1367446635-12856-1-git-send-email-cody@linux.vnet.ibm.com> <1367446635-12856-5-git-send-email-cody@linux.vnet.ibm.com> <alpine.DEB.2.02.1305011530050.8804@chino.kir.corp.google.com> <518199FE.7060908@linux.vnet.ibm.com> <alpine.DEB.2.02.1305011547450.8804@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1305011547450.8804@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13050122-2876-0000-0000-000008331950
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2013 03:48 PM, David Rientjes wrote:
> On Wed, 1 May 2013, Cody P Schafer wrote:
>
>> Guaranteed to be stable means that if I'm a reader and pgdat_resize_lock(),
>> node_present_pages had better not change at all until I pgdat_resize_unlock().
>>
>> If nothing needs this guarantee, we should change the rules of
>> pgdat_resize_lock(). I played it safe and went with following the existing
>> rules.
>>
>
> __offline_pages() breaks your guarantee.
>

Thanks for pointing that out. Seems I fixed online_pages() but missed 
__offline_pages().


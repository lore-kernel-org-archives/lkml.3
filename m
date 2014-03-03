Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874AbaCCQqz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 11:46:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8935 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753236AbaCCQqy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 11:46:54 -0500
Message-ID: <5314B190.5060906@redhat.com>
Date: Mon, 03 Mar 2014 11:45:04 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Igor Mammedov <imammedo@redhat.com>, linux-kernel@vger.kernel.org
CC: prarit@redhat.com, mgorman@suse.de, peterz@infradead.org,
        alex.shi@intel.com, hpa@zytor.com
Subject: Re: deadlock between cpu_stopper & native_flush_tlb_others()->smp_call_function_many()
References: <20140303174356.082ec348@nial.usersys.redhat.com>
In-Reply-To: <20140303174356.082ec348@nial.usersys.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/2014 11:43 AM, Igor Mammedov wrote:
> It looks like I hit a deadlock between smp_call_function_many() and
> cpu_stopper threads.

> Are there any suggestions on how to fix this nicely?

This patch should fix it:

https://lkml.org/lkml/2014/2/28/194

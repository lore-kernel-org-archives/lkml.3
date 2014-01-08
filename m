Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103AbaAHLub (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 06:50:31 -0500
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:50851 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754960AbaAHLu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 06:50:28 -0500
Message-ID: <52CD3D36.1010706@linux.vnet.ibm.com>
Date: Wed, 08 Jan 2014 17:27:42 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Damien Ramonda <damien.ramonda@intel.com>,
        Linus <torvalds@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH V3] mm readahead: Fix the readahead fail in case of
 empty numa node
References: <1389003715-29733-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com> <20140106141300.4e1c950d45c614d6c29bdd8f@linux-foundation.org> <52CD1113.2070003@linux.vnet.ibm.com> <20140108104713.GB8256@quack.suse.cz>
In-Reply-To: <20140108104713.GB8256@quack.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14010811-2674-0000-0000-00000C327F05
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2014 04:17 PM, Jan Kara wrote:
> On Wed 08-01-14 14:19:23, Raghavendra K T wrote:
>> On 01/07/2014 03:43 AM, Andrew Morton wrote:
>>> On Mon,  6 Jan 2014 15:51:55 +0530 Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com> wrote:
[...]
>> But having said that I am not able to get an idea of sane implementation
>> to solve this readahead failure bug overcoming the anomaly you pointed
>> :(.  hints/ideas.. ?? please let me know.
>    So if we would be happy with just fixing corner cases like this, we might
> use total node memory size to detect them, can't we? If total node memory
> size is 0, we can use 16 MB (or global number of free pages / 2 if we would
> be uneasy with fixed 16 MB limit) as an upperbound...
>

Thanks Honza.

This seems to be more sensible option, I 'll send the patch with that
change (including 16MB limit if nobody disagrees).


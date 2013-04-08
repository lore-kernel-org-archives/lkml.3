Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934711Ab3DHBvn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 21:51:43 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:54544 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934669Ab3DHBvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 21:51:42 -0400
Message-ID: <516222A7.7020407@gmail.com>
Date: Mon, 08 Apr 2013 09:51:35 +0800
From: Simon Jeons <simon.jeons@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Shaohua Li <shli@kernel.org>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC] mm: remove swapcache page early
References: <1364350932-12853-1-git-send-email-minchan@kernel.org> <alpine.LNX.2.00.1303271230210.29687@eggly.anvils> <515ADFCF.4010209@gmail.com> <51611F94.7060801@gmail.com> <20130408014845.GB6394@blaptop>
In-Reply-To: <20130408014845.GB6394@blaptop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2013 09:48 AM, Minchan Kim wrote:
> Hello Simon,
>
> On Sun, Apr 07, 2013 at 03:26:12PM +0800, Simon Jeons wrote:
>> Ping Minchan.
>> On 04/02/2013 09:40 PM, Simon Jeons wrote:
>>> Hi Hugh,
>>> On 03/28/2013 05:41 AM, Hugh Dickins wrote:
>>>> On Wed, 27 Mar 2013, Minchan Kim wrote:
>>>>
>>>>> Swap subsystem does lazy swap slot free with expecting the page
>>>>> would be swapped out again so we can't avoid unnecessary write.
>>>>                               so we can avoid unnecessary write.
>>> If page can be swap out again, which codes can avoid unnecessary
>>> write? Could you point out to me? Thanks in advance. ;-)
> Look at shrink_page_list.
>
> 1) PageAnon(page) && !PageSwapCache()
> 2) add_to_swap's SetPageDirty
> 3) __remove_mapping
>
> P.S)
> It seems you are misunderstanding. Here isn't proper place to ask a
> question for your understanding the code. As I know, there are some
> project(ex, kernelnewbies) and books for study and sharing the
> knowledge linux kernel.
>
> I recommend Mel's "Understand the Linux Virtual Memory Manager".
> It's rather outdated but will be very helpful to understand VM of
> linux kernel. You can get it freely but I hope you pay for.
> So if author become a billionaire by selecting best book in Amazon,
> he might print out second edition which covers all of new VM features
> and may solve all of you curiosity.
>
> It would be a another method to contribute open source project. :)
>
> I believe you talented developers can catch it up with reading the
> code enoughly and find more bonus knowledge. I think it's why our senior
> developers yell out RTFM and I follow them.

What's the meaning of RTFM?

>
> Cheers!
>
>


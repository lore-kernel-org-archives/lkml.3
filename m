Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964824AbaFQTha (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 15:37:30 -0400
Received: from 99-65-72-227.uvs.sntcca.sbcglobal.net ([99.65.72.227]:59686
	"EHLO stargate3.asicdesigners.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933325AbaFQTh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 15:37:29 -0400
Message-ID: <53A098F5.6040104@chelsio.com>
Date: Tue, 17 Jun 2014 12:37:25 -0700
From: Anish Bhatt <anish@chelsio.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] checkpatch: Warn on unnecessary void function return
 statements
References: <1401728316.5770.9.camel@joe-AO725>	 <1402961300-17985-1-git-send-email-anish@chelsio.com>	 <1402964898.11561.2.camel@joe-AO725> <539F8F62.4000805@chelsio.com> <1402970429.2797.3.camel@joe-AO725>
In-Reply-To: <1402970429.2797.3.camel@joe-AO725>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2014 07:00 PM, Joe Perches wrote:
> On Mon, 2014-06-16 at 17:44 -0700, Anish Bhatt wrote:
>> My code has multiple exit lables:
>> void function(void)
>> {
>> 	...
>>
>> 	if (err1)
>> 		goto exit1;
>> 	...
>> 	if (err2)
>> 		goto exit2;
>>
>> 	...
>> 	return; /* Good return, no errors */
>> exit1:
>> 	printk(err1);
>> 	return;
>> exit2:
>> 	printk(err2);
>> }
>>
>> The single tabbed return was required to prevent the good return & err1 
>> messages cascading down. The extra exit label with a noop looks weird, 
>> but is passing checkpatch.pl --strict, so I will go with that, thanks.
>> -Anish
>>
> 
> Hmm, those return uses seem reasonable
> to me.
> 
> Perhaps the test should warn only on
> this specific 3 line sequence:
> 
> [any line but a label]
> 	return;
> }
> 
> Andrew?  Anyone else?  Opinions?
> 
I think simply 

	return;
}

should trigger the warning. If you are using a label just to exit, you could just do it in-place (though possibly someone might want to a goto instead of multiple returns)

-Anish


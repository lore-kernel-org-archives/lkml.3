Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064Ab3LNVVq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 16:21:46 -0500
Received: from nigelcunningham.com.au ([178.79.133.97]:51162 "EHLO
	nigelcunningham.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753906Ab3LNVVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 16:21:45 -0500
Message-ID: <52ACCBE0.5060404@nigelcunningham.com.au>
Date: Sun, 15 Dec 2013 08:21:36 +1100
From: Nigel Cunningham <nigel@nigelcunningham.com.au>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
CC: Jens Axboe <axboe@kernel.dk>, tomaz.solc@tablix.org, aaron.lu@intel.com,
        linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH] libata, freezer: avoid block device removal while system
 is frozen
References: <20131213174932.GA27070@htj.dyndns.org> <20131213185237.GD27070@htj.dyndns.org> <20131213204034.GE27070@htj.dyndns.org> <52AB8E27.90308@nigelcunningham.com.au> <20131213230744.GA17954@htj.dyndns.org> <52AB9509.1080004@nigelcunningham.com.au> <20131214203121.GB4020@htj.dyndns.org> <20131214203652.GC4020@htj.dyndns.org>
In-Reply-To: <20131214203652.GC4020@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On 15/12/13 07:36, Tejun Heo wrote:
> On Sat, Dec 14, 2013 at 03:31:21PM -0500, Tejun Heo wrote:
>> So, all this is about hibernation?  Does that mean that it's safe to
>> unfreeze before invoking resume?  ie. we currently do,
>>
>> 	freeze
>> 	suspend devs
>> 	resume devs
>> 	unfreeze
>>
>> If we can just do,
>>
>> 	freeze
>> 	suspend devs
>> 	unfreeze
>> 	resume devs
> Ummm... even better, does that mean, in the long term, we can decouple
> freezing and device pm operations?  If this is just about hibernation,
> there's no reason to wrap device driver pm ops with freezer, right?
>
> Thanks.
>
Rafael has spent far more time than me thinking about the semantics 
here, so I'd like to defer to him. Rafael?...

Regards,

Nigel

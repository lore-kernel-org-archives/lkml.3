Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075Ab3KSOYb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 09:24:31 -0500
Received: from a-pb-sasl-quonix.pobox.com ([208.72.237.25]:46629 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720Ab3KSOY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 09:24:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=message-id:date
	:from:mime-version:to:cc:subject:references:in-reply-to
	:content-type:content-transfer-encoding; q=dns; s=sasl; b=Q5l+6t
	Zuwj9s3FsizvPy9BilrZ/nxLCHCzChnqh4Z4L36vhm3rMww8LqEHowXAmfubaHEI
	6AMb3HeawM/osRTjDBzqiyXkdioVspWQEBp7p8rJkTw2J5TqE7FMId9KnVwGxtqW
	05ETmtBGGNSZDqREYw3wlhhHPX+71wPAvtgTM=
Message-ID: <528B749B.7050304@pobox.com>
Date: Tue, 19 Nov 2013 09:24:27 -0500
From: Mark Lord <mlord@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: David Laight <David.Laight@ACULAB.COM>, Ming Lei <ming.lei@canonical.com>,
        davem@davemloft.net, netdev@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Subject: Re: net/usb/ax88179_178a driver broken in linux-3.12
References: <52890C7E.6000607@pobox.com> <52891178.2080509@pobox.com>	 <52891341.4020403@pobox.com>	 <AE90C24D6B3A694183C094C60CF0A2F6026B742B@saturn3.aculab.com>	 <AE90C24D6B3A694183C094C60CF0A2F6026B742F@saturn3.aculab.com>	 <528A9A36.50903@pobox.com>	 <AE90C24D6B3A694183C094C60CF0A2F6026B7431@saturn3.aculab.com>	 <528B6F73.7040801@pobox.com> <1384870550.8604.101.camel@edumazet-glaptop2.roam.corp.google.com>
In-Reply-To: <1384870550.8604.101.camel@edumazet-glaptop2.roam.corp.google.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Pobox-Relay-ID: 4C9D6BE4-5126-11E3-B277-F66B0E5B5709-82205200!a-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-11-19 09:15 AM, Eric Dumazet wrote:
> On Tue, 2013-11-19 at 09:02 -0500, Mark Lord wrote:
>> On 13-11-19 05:04 AM, David Laight wrote:
>>>> From: Mark Lord
>> ..
>>>> except the ax88179_178a driver still does not work in linux-3.12,
>>>> whereas it works fine in all earlier kernels.
>>>>
>>>> That's a regression.
>>>> And a simple revert (earlier in this thread) fixes it.
>>>> So.. let's revert it for now, until a proper xhci compatible patch is produced.
>> ...
>>> There is a patch to xhci-ring.c that should fix the SG problem.
>>> http://www.spinics.net/lists/linux-usb/msg97176.html
>>>
>>> I think it should apply to the 3.12 sources.
>>
>> I am running with that patch here now (thanks),
>> and it too appears to prevent the lockups.
>>
>> But is this patch upstream already?
>> If yes, then it needs to get pushed out to -stable for 3.12 at least.
>>
>> If not upstream, then the revert is probably safest for -stable,
>> rather than new code that has never been upstream before.
>>
> 
>> Both patches are attached to this email.
>> One or the other is required for the USB 3.0 network adapters to function in 3.12.
> 
> I do not see any error in commit f27070158d6754765f2
> ("ax88179_178a: avoid copy of tx tcp packets")
> Quite the contrary in fact...
> 
> I suspect a TSO bug, and would rather disable TSO for this nic.

David's explanation for the XHCI issue seems to explain it nicely,
and the patch he linked to does indeed address/fix the issue,
without disabling TSO.

So on the evidence, probably NOT a TSO bug.
-- 
Mark Lord
Real-Time Remedies Inc.
mlord@pobox.com

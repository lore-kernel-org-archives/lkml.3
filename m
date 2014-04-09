Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933294AbaDINIw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 09:08:52 -0400
Received: from a-pb-sasl-quonix.pobox.com ([208.72.237.25]:43440 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932674AbaDINIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 09:08:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=message-id:date
	:from:mime-version:to:cc:subject:references:in-reply-to
	:content-type:content-transfer-encoding; q=dns; s=sasl; b=p51goV
	DEKBO+NeFf8uhymig7hUDqTDKjHrCAci09xrGV5cb2BHy0wiHWa25vN6LzvFZqlT
	qobAeZeQ5lcRVTDG7uU1C/Rqsjo7YWSu5a3iK9e8Fxy5YIKHx5mTZ8dtUu0bYKeE
	TPZXAQZG/y4vxIIo4x0Qn0jy8maBagoVYk7y8=
Message-ID: <53454660.5090603@pobox.com>
Date: Wed, 09 Apr 2014 09:08:48 -0400
From: Mark Lord <mlord@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Bjorn Helgaas <bhelgaas@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, "Theodore Ts'o" <tytso@mit.edu>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: driver skip pci_set_master, fix it? No.
References: <5344251D.7040805@pobox.com>	 <CAErSpo6KuYLaoEsxR4jJQ98P23kNEMzMcu_-RyM3nWd6YRxgag@mail.gmail.com>	 <5344679E.1030008@pobox.com> <1397011868.3671.94.camel@pasglop>
In-Reply-To: <1397011868.3671.94.camel@pasglop>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Pobox-Relay-ID: 1669C51E-BFE8-11E3-A3C1-873F0E5B5709-82205200!a-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-04-08 10:51 PM, Benjamin Herrenschmidt wrote:
> On Tue, 2014-04-08 at 17:18 -0400, Mark Lord wrote:
>>> I assume you're talking about the one added by cf3e1feba7f9 ("PCI:
>>> Workaround missing pci_set_master in pci drivers"), but as far as I
>>> can tell, it only calls pci_set_master() for *bridge* devices.  What
>>> am I missing?  Is pci_set_master() being called for your endpoint?
>>> What path is that?
>>
>> Yes, it is being called during execution of the _probe() function in my driver,
>> as evidenced by the annoying (and wrong) message it produces.
>>
>> Next time I've got the hardware at hand, I'll put a "dump_stack()" into there
>> to see the exact calling path.
> 
> Note that one of the reason we want to do it early on bridges is that without it,
> we may also not get the PCIe error messages.

Sure, for bridges.

I'll get a stack trace later today, but what I suspect is happening
is that this multi-function card is being treated by the PCI layers
as a "bridge" for purposes of the multiple virtual functions it implements.

We will probably need to distinguish this kind of device from real bridges here.
-- 
Mark Lord
Real-Time Remedies Inc.
mlord@pobox.com

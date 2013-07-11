Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755748Ab3GKM41 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 08:56:27 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:40271 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754088Ab3GKM4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 08:56:25 -0400
Message-ID: <51DEAB71.8020109@ozlabs.ru>
Date: Thu, 11 Jul 2013 22:56:17 +1000
From: Alexey Kardashevskiy <aik@ozlabs.ru>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Alexander Graf <agraf@suse.de>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev@lists.ozlabs.org,
        David Gibson <david@gibson.dropbear.id.au>,
        Paul Mackerras <paulus@samba.org>,
        Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm-ppc@vger.kernel.org
Subject: Re: [PATCH 6/8] KVM: PPC: Add support for multiple-TCE hcalls
References: <1373123227-22969-1-git-send-email-aik@ozlabs.ru> <1373123227-22969-7-git-send-email-aik@ozlabs.ru> <51DC4228.7010607@suse.de> <51DCEA76.9070808@ozlabs.ru> <D10E7B99-3A7C-4275-9A49-3CB15598E705@suse.de> <51DE3ECB.7080803@ozlabs.ru> <43E93931-F213-47CC-ADCF-D3A6D6BC4372@suse.de> <51DE8EE9.2000508@ozlabs.ru> <C6BC1E27-4C9C-4A18-A64A-052202DA64B5@suse.de> <1373546368.19894.87.camel@pasglop> <4133424D-B105-4CB1-A72A-4F47A6184DC7@suse.de>
In-Reply-To: <4133424D-B105-4CB1-A72A-4F47A6184DC7@suse.de>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2013 10:51 PM, Alexander Graf wrote:
> 
> On 11.07.2013, at 14:39, Benjamin Herrenschmidt wrote:
> 
>> On Thu, 2013-07-11 at 13:15 +0200, Alexander Graf wrote:
>>> And that's bad. Jeez, seriously. Don't argue this case. We enable new
>>> features individually unless we're 100% sure we can keep everything
>>> working. In this case an ENABLE_CAP doesn't hurt at all, because user
>>> space still needs to handle the hypercalls if it wants them anyways.
>>> But you get debugging for free for example.
>>
>> An ENABLE_CAP is utterly pointless. More bloat. But you seem to like
>> it :-)
> 

> I don't like bloat usually. But Alexey even had an #ifdef DEBUG in there
> to selectively disable in-kernel handling of multi-TCE. Not calling
> ENABLE_CAP would give him exactly that without ugly #ifdefs in the
> kernel.


No, it would not give m anithing. My ugly debug was to disable realmode
only and still leave virtual mode on, not to disable both real and virtual
modes. It is a lot easier to disable in kernel handling in QEMU.



-- 
Alexey

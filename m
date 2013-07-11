Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932133Ab3GKNVx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 09:21:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45545 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755118Ab3GKNVw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 09:21:52 -0400
Subject: Re: [PATCH 6/8] KVM: PPC: Add support for multiple-TCE hcalls
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=US-ASCII
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <51DEAF60.2000902@ozlabs.ru>
Date: Thu, 11 Jul 2013 15:21:46 +0200
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev@lists.ozlabs.org,
        David Gibson <david@gibson.dropbear.id.au>,
        Paul Mackerras <paulus@samba.org>,
        Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm-ppc@vger.kernel.org
Content-Transfer-Encoding: 7BIT
Message-Id: <996F5EDD-9C1A-4920-8D5C-D7561AA00769@suse.de>
References: <1373123227-22969-1-git-send-email-aik@ozlabs.ru>  <1373123227-22969-7-git-send-email-aik@ozlabs.ru>  <51DC4228.7010607@suse.de> <51DCEA76.9070808@ozlabs.ru>  <D10E7B99-3A7C-4275-9A49-3CB15598E705@suse.de> <51DE3ECB.7080803@ozlabs.ru>  <43E93931-F213-47CC-ADCF-D3A6D6BC4372@suse.de> <51DE8EE9.2000508@ozlabs.ru>  <C6BC1E27-4C9C-4A18-A64A-052202DA64B5@suse.de>  <1373546368.19894.87.camel@pasglop>  <4133424D-B105-4CB1-A72A-4F47A6184DC7@suse.de> <1373547480.19894.102.camel@pasglop> <51DEAF60.2000902@ozlabs.ru>
To: Alexey Kardashevskiy <aik@ozlabs.ru>
X-Mailer: Apple Mail (2.1278)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 11.07.2013, at 15:13, Alexey Kardashevskiy wrote:

> On 07/11/2013 10:58 PM, Benjamin Herrenschmidt wrote:
>> On Thu, 2013-07-11 at 14:51 +0200, Alexander Graf wrote:
>>> I don't like bloat usually. But Alexey even had an #ifdef DEBUG in
>>> there to selectively disable in-kernel handling of multi-TCE. Not
>>> calling ENABLE_CAP would give him exactly that without ugly #ifdefs in
>>> the kernel.
>> 
>> I don't see much point in disabling it... but ok, if that's a valuable
>> feature, then shoot some VM level ENABLE_CAP (please don't iterate all
>> VCPUs, that's gross).
> 
> No use for me whatsoever as I only want to disable real more handlers and
> keep virtual mode handlers enabled (sometime, for debug only) and this
> capability is not about that - I can easily just not enable it in QEMU with
> the exactly the same effect.
> 
> So please, fellas, decide whether I should iterate vcpu's or add ENABLE_CAP
> per KVM. Thanks.

Thinking hard about this it might actually be ok to not have an ENABLE_CAP for this, if kernel code always works properly, because from the guest's point of view nothing changes - it either gets handled by kernel or by user space. And user space either handles it or doesn't, so it's ok.

Just leave it out this time. But be very weary of adding new features without an ENABLE_CAP switch. They might be guest visible changes.


Alex


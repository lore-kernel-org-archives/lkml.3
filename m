Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932538Ab3FQImW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 04:42:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58213 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756132Ab3FQImU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 04:42:20 -0400
Subject: Re: [PATCH 1/4] KVM: PPC: Add support for multiple-TCE hcalls
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=us-ascii
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <1371458225.21896.153.camel@pasglop>
Date: Mon, 17 Jun 2013 10:42:18 +0200
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>, linuxppc-dev@lists.ozlabs.org,
        David Gibson <david@gibson.dropbear.id.au>,
        Paul Mackerras <paulus@samba.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm-ppc@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <6BF879F8-F9F6-4622-81BA-05EB26CA0580@suse.de>
References: <1370412673-1345-1-git-send-email-aik@ozlabs.ru> <1370412673-1345-2-git-send-email-aik@ozlabs.ru> <0A6C24DE-1422-4ABA-A516-2B864F4714F8@suse.de> <51BEC0FE.4020805@ozlabs.ru> <1371458225.21896.153.camel@pasglop>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
X-Mailer: Apple Mail (2.1278)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 17.06.2013, at 10:37, Benjamin Herrenschmidt wrote:

> On Mon, 2013-06-17 at 17:55 +1000, Alexey Kardashevskiy wrote:
>> David:
>> ===
>> So, in the case of MULTITCE, that's not quite right.  PR KVM can
>> emulate a PAPR system on a BookE machine, and there's no reason not to
>> allow TCE acceleration as well.  We can't make it dependent on PAPR
>> mode being selected, because that's enabled per-vcpu, whereas these
>> capabilities are queried on the VM before the vcpus are created.
>> ===
>> 
>> Wrong?
> 
> The capability just tells qemu the kernel supports it, it doesn't have
> to depend on PAPR mode, qemu can sort things out no ?

Yes, this goes hand-in-hand with the documentation bit I'm trying to get through to Alexey atm. The CAP merely says that if in PAPR mode the kernel can handle hypercalls X and Y itself.

This is true for all book3s implementations as the patches stand. It is not true for BookE as the patches stand. Hence the CAP should be limited to book3s, regardless of its mode :).


Alex


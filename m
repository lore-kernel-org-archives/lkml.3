Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754349Ab3GJKmK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 06:42:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51929 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752561Ab3GJKmI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 06:42:08 -0400
Subject: Re: [PATCH 8/8] KVM: PPC: Add hugepage support for IOMMU in-kernel handling
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=us-ascii
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <D5AD40B0-B069-4BAD-90E0-3ECE2FE81038@suse.de>
Date: Wed, 10 Jul 2013 12:42:04 +0200
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>, linuxppc-dev@lists.ozlabs.org,
        David Gibson <david@gibson.dropbear.id.au>,
        Paul Mackerras <paulus@samba.org>,
        Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm-ppc@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <BEA4EEEE-D485-4574-A32B-31F2FA3319C5@suse.de>
References: <1373123227-22969-1-git-send-email-aik@ozlabs.ru> <1373123227-22969-9-git-send-email-aik@ozlabs.ru> <51DC4923.5010501@suse.de> <51DC9CDA.3070906@ozlabs.ru> <778C7C81-5F7F-4E21-8B72-92F336002F9E@suse.de> <1373452753.19894.19.camel@pasglop> <D5AD40B0-B069-4BAD-90E0-3ECE2FE81038@suse.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
X-Mailer: Apple Mail (2.1278)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 10.07.2013, at 12:40, Alexander Graf wrote:

> 
> On 10.07.2013, at 12:39, Benjamin Herrenschmidt wrote:
> 
>> On Wed, 2013-07-10 at 12:33 +0200, Alexander Graf wrote:
>>> 
>>> It's not exactly obvious that you're calling it with writing == 1 :).
>>> Can you create a new local variable "is_write" in the calling
>>> function, set that to 1 before the call to get_user_pages_fast and
>>> pass it in instead of the 1? The compiler should easily optimize all
>>> of that away, but it makes the code by far easier to read.
>> 
>> Ugh ?
>> 
>> Nobody else does that .... (look at futex :-)
> 
> Yeah, that's fortunately code that I don't have to read :).

The "proper" alternative would be to pass an enum for read/write into the function rather than an int. But that'd be a pretty controversial, big change that I'd rather not put on Alexey. With a local variable we're nicely self-contained readable ;)


Alex


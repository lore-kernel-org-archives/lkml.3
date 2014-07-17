Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759275AbaGQXoS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 19:44:18 -0400
Received: from mail-yk0-f170.google.com ([209.85.160.170]:47295 "EHLO
	mail-yk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758044AbaGQXoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 19:44:15 -0400
Message-ID: <53C85FE9.6010304@gmail.com>
Date: Thu, 17 Jul 2014 19:44:41 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Christoph Lameter <cl@gentwo.org>
CC: rdunlap@infradead.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] doc: Add remote CPU access details and others
 to this_cpu_ops.txt
References: <1405552141-8506-1-git-send-email-bobby.prani@gmail.com> <alpine.DEB.2.11.1407170848490.27584@gentwo.org> <53C7D93B.4090006@gmail.com> <alpine.DEB.2.11.1407170934220.28121@gentwo.org> <53C7E234.3020503@gmail.com> <alpine.DEB.2.11.1407171005450.28248@gentwo.org>
In-Reply-To: <alpine.DEB.2.11.1407171005450.28248@gentwo.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2014 11:19 AM, Christoph Lameter wrote:
> Regarding atomic_t in per cpu areas: I am uncomfortable especially
> because both locked and unlocked RMW write operations could be acting on
> values in the same cacheline. I am concerned that the unlocked operation
> could have an unpredictable result.
> 
> 
> f.e. the following per cpu data structure
> 
> struct test {
> 	atomic_t a;
> 	int b;
> } onecacheline;
> 
> 
> Local cpu does
> 
> 	this_cpu_inc(onecacheline.b);
> 
> If this is racing with a remote cpus:
> 
> 	atomic_inc(percpu(&a, cpu))
> 
> then we have on x86 a increment operation with locked semantics racing
> with an unlocked one on the same cacheline.
> 

OK, I will add this as a warning in the documentation. Thanks!

--
Pranith

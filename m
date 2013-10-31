Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456Ab3JaLOX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 07:14:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54420 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753445Ab3JaLOV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 07:14:21 -0400
Message-ID: <52723B87.1050609@redhat.com>
Date: Thu, 31 Oct 2013 12:14:15 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130923 Thunderbird/17.0.9
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: paulmck@linux.vnet.ibm.com, linux-kernel <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org, gleb@redhat.com
Subject: Re: [PATCH RFC] kvm: optimize out smp_mb using srcu_read_unlock
References: <20131030190929.GA7153@redhat.com>
In-Reply-To: <20131030190929.GA7153@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 30/10/2013 20:09, Michael S. Tsirkin ha scritto:
> I noticed that srcu_read_lock/unlock both have a memory barrier,
> so just by moving srcu_read_unlock earlier we can get rid of
> one call to smp_mb().
> 
> Unsurprisingly, the gain is small but measureable using the unit test
> microbenchmark:
> before
> 	vmcall 1407
> after
> 	vmcall 1357
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

Across how many runs?  Best or average or "all runs were in that
ballpark", :) and what's the minimum/maximum before and after the patch?

As you say the benefit is not surprising, but the experiments should be
documented properly.

Paolo

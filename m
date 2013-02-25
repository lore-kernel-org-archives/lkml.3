Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759473Ab3BYO6H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 09:58:07 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:59960 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751661Ab3BYO6C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 09:58:02 -0500
Message-ID: <512B784E.5070002@linux.vnet.ibm.com>
Date: Mon, 25 Feb 2013 06:42:22 -0800
From: Dave Hansen <dave@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Gleb Natapov <gleb@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 0/5] [v3] fix illegal use of __pa() in KVM code
References: <20130122212428.8DF70119@kernel.stglabs.ibm.com> <1361741338.21499.38.camel@thor.lan>
In-Reply-To: <1361741338.21499.38.camel@thor.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13022514-9360-0000-0000-00001109284B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2013 01:28 PM, Peter Hurley wrote:
> Now that the alloc_remap() has been/is being removed, is most/all of
> this being reverted?

I _believe_ alloc_remap() is the only case where we actually remapped
low memory.  However, there is still other code that does __pa()
translations for percpu areas: per_cpu_ptr_to_phys().  I _think_ it's
still theoretically possible to get some percpu data in the vmalloc() area.

> So in short, my questions are:
> 1) is the slow_virt_to_phys() necessary anymore?

kvm_vcpu_arch has a

        struct pvclock_vcpu_time_info hv_clock;

and I believe I mistook the two 'hv_clock's for each other.  However,
this doesn't hurt anything, and the performance difference is probably
horribly tiny.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046AbaHEEAK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 00:00:10 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:54036 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbaHEEAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 00:00:07 -0400
Message-ID: <53E056C2.9070101@linux.vnet.ibm.com>
Date: Tue, 05 Aug 2014 12:00:02 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Sasha Levin <sasha.levin@oracle.com>, gleb@kernel.org, pbonzini@redhat.com
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: MMU: Use hashtable for MMU page hash
References: <1407185689-27727-1-git-send-email-sasha.levin@oracle.com>
In-Reply-To: <1407185689-27727-1-git-send-email-sasha.levin@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14080504-4790-0000-0000-00000310C9A6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2014 04:54 AM, Sasha Levin wrote:
> Use the kernel hashtable interface instead of the hlist interface.
> This allows us to eliminate some unneeded code and make the code
> simpler.

The side effect is that the hash function is changed, the current
way is:
	gfn & ((1 << KVM_MMU_HASH_SHIFT) - 1);

Guest memory is always continuous and big region, i guess it's better
than the one you introduced.

Anyway, benchmark is needed and always welcome. :)


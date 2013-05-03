Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933189Ab3ECOzR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 10:55:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:59114 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933054Ab3ECOzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 10:55:15 -0400
Message-ID: <5183CFAC.8020005@infradead.org>
Date: Fri, 03 May 2013 07:54:36 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@linux.intel.com>,
        David Rientjes <rientjes@google.com>, hpa@zytor.com,
        linux-kernel@vger.kernel.org, penberg@kernel.org,
        levinsasha928@gmail.com, mtosatti@redhat.com, tglx@linutronix.de,
        bp@suse.de, fengguang.wu@intel.com, linux-tip-commits@vger.kernel.org,
        Michal Marek <mmarek@suse.cz>
Subject: Re: [tip:x86/urgent] x86/kconfig:  Add a Kconfig shortcut for building
 working KVM guest kernels
References: <20130426095140.GA15361@pd.tnic> <tip-7e0320e733eec67e40d2b53e438d9971f079862d@git.kernel.org> <alpine.DEB.2.02.1305021104440.2493@chino.kir.corp.google.com> <5182AB66.6020307@linux.intel.com> <20130502194556.GB3553@gmail.com> <20130502200703.GE16684@pd.tnic> <20130503142900.GA3433@pd.tnic>
In-Reply-To: <20130503142900.GA3433@pd.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/13 07:29, Borislav Petkov wrote:
> On Thu, May 02, 2013 at 10:07:03PM +0200, Borislav Petkov wrote:a
>> I wonder if one can exclude options from randconfig until 'select' has
>> been taught to resolve dependencies...
> 
> So I talked to Michal on IRC about the whole deal and the fact of the
> matter is, unless someone steps up and rewrites the Kconfig solver so
> that selects work as expected, this option would break whenever one
> of those selected option's dependencies change or said option is made
> configurable.
> 
> Which means, the next best thing would be to have a small file
> somewhere, maybe in scripts/kconfig/ or so, called 'allrand.config' and
> which has default settings for randconfig builds. It would have
> 
> # CONFIG_KVM_GUEST_COMMON_OPTIONS is not set
> 
> so that this option is always disabled in randconfigs.
> 
> Frankly, I much rather prefer this than going nuts and including every
> possible dependency just so some obscure randconfigs don't break (that's
> not the point of this option anyway); and then having to run around and
> fix it once some of the selected option's dependencies change.
> 
> Opinions?


Could you alternately have a kvm_guest.config that should always work
for you?


-- 
~Randy

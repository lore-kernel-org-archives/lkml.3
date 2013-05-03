Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934089Ab3ECRTY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 13:19:24 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:63335 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933603Ab3ECRTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 13:19:22 -0400
Date: Fri, 3 May 2013 10:19:20 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Borislav Petkov <bp@alien8.de>, Michal Marek <mmarek@suse.cz>,
        Randy Dunlap <rdunlap@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org,
        penberg@kernel.org, levinsasha928@gmail.com, mtosatti@redhat.com,
        tglx@linutronix.de, bp@suse.de, fengguang.wu@intel.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86/kconfig:  Add a Kconfig shortcut for building
 working KVM guest kernels
In-Reply-To: <aea679e3-048a-4f28-b164-73191095a995@email.android.com>
Message-ID: <alpine.DEB.2.02.1305031016290.32047@chino.kir.corp.google.com>
References: <20130426095140.GA15361@pd.tnic> <tip-7e0320e733eec67e40d2b53e438d9971f079862d@git.kernel.org> <alpine.DEB.2.02.1305021104440.2493@chino.kir.corp.google.com> <5182AB66.6020307@linux.intel.com> <20130502194556.GB3553@gmail.com> <20130502200703.GE16684@pd.tnic>
 <20130503142900.GA3433@pd.tnic> <5183CFAC.8020005@infradead.org> <20130503150818.GC3433@pd.tnic> <5183D357.8000204@suse.cz> <20130503153134.GD3433@pd.tnic> <alpine.DEB.2.02.1305030952140.30317@chino.kir.corp.google.com>
 <aea679e3-048a-4f28-b164-73191095a995@email.android.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 May 2013, H. Peter Anvin wrote:

> For minimal you'd probably use yes n | ...
> 

Works fine unless kvm_guest.config enables an option that requires a 
numbered choice, such as CONFIG_EXPERT enabling the the ability to select 
CONFIG_SLOB from the list of allocators.  Instead of relying on yes(1), 
I think you'll need to modify this custom script to explicitly disable 
remaining options and select the default when there's a choice.

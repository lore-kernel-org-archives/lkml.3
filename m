Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751246AbaKFWIS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 17:08:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58627 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750963AbaKFWIP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:08:15 -0500
Date: Thu, 6 Nov 2014 17:07:31 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: David Rientjes <rientjes@google.com>
Cc: Prarit Bhargava <prarit@redhat.com>, linux-kernel@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@linux.intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Fabian Frederick <fabf@skynet.be>, isimatu.yasuaki@jp.fujitsu.com,
        jbaron@akamai.com, linux-doc@vger.kernel.org,
        kexec@lists.infradead.org, linux-api@vger.kernel.org
Subject: Re: [PATCH v8] kernel, add panic_on_warn
Message-ID: <20141106220731.GA13590@redhat.com>
References: <1415187736-16242-1-git-send-email-prarit@redhat.com>
 <alpine.DEB.2.10.1411051357050.31575@chino.kir.corp.google.com>
 <545B733C.6080903@redhat.com>
 <alpine.DEB.2.10.1411061352440.1526@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1411061352440.1526@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 01:57:36PM -0800, David Rientjes wrote:

[..]
> You see that doing
> 
> 	if (panic_on_warn) {
> 		panic_on_warn = 0;
> 		panic(...);
> 	}
> 
> is racy, I hope.  If two threads WARN() at the same time, then there's 
> nothing preventing a double panic() because WARN() itself is not 
> serialized against anything.  So both the current comment and your 
> suggested revision comment are bogus.

panic() is serialized on panic_lock. So I guess it is fine to hit WARN()
on multiple cpus. Do you see an issue there?

Thanks
Vivek

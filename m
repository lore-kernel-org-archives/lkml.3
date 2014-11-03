Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135AbaKCNd1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 08:33:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56396 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758AbaKCNdZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 08:33:25 -0500
Message-ID: <545783FA.4050508@redhat.com>
Date: Mon, 03 Nov 2014 08:32:42 -0500
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131028 Thunderbird/17.0.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Jonathan Corbet <corbet@lwn.net>, kexec@lists.infradead.org,
        Rusty Russell <rusty@rustcorp.com.au>, linux-doc@vger.kernel.org,
        jbaron@akamai.com, Fabian Frederick <fabf@skynet.be>,
        isimatu.yasuaki@jp.fujitsu.com, "H. Peter Anvin" <hpa@zytor.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-api@vger.kernel.org,
        vgoyal@redhat.com
Subject: Re: [PATCH] kernel, add panic_on_warn
References: <1414688627-5298-1-git-send-email-prarit@redhat.com> <20141031015843.GW9743@dangermouse.emea.sgi.com>
In-Reply-To: <20141031015843.GW9743@dangermouse.emea.sgi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 10/30/2014 09:58 PM, Hedi Berriche wrote:
> On Thu, Oct 30, 2014 at 17:06 Prarit Bhargava wrote:
> | There have been several times where I have had to rebuild a kernel to
> | cause a panic when hitting a WARN() in the code in order to get a crash
> | dump from a system.  Sometimes this is easy to do, other times (such as
> | in the case of a remote admin) it is not trivial to send new images to the
> | user.
> | 
> | A much easier method would be a switch to change the WARN() over to a
> | panic.  This makes debugging easier in that I can now test the actual
> | image the WARN() was seen on and I do not have to engage in remote
> | debugging.
> 
> Do we want to leave it to usersspace[1] to ensure panic_on_warn is out
> of the way in when the kdump kernel boots? or would a self-contained
> approach be more preferable i.e. test whether we're a kdump kernel
> before bothering with panic_on_warn?

Hmm ... this is a good point.  Vivek, do you have a preference?  I'm willing to
code it either way.  I should be able to put in a is_kdump_kernel() check
without any problems but I'm not sure if that is the right thing to do here.

P.

> 
> Cheers,
> Hedi.
> 
> [1] kexec-tools in the case of the boot param by filtering it out of the
>     kdump kernel cmdline. In the case of sysctl.conf, it would depend on
>     whether there are distros out there that  include it in the kdump
>     initrd.
> 
